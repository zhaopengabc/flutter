package com.video;

import android.content.Context;
import android.net.Uri;
import android.util.Log;
import android.view.TextureView;

import com.video.bean.BmpContainer;
import com.video.bean.CropView;
import com.video.bean.ViewBean;
import com.video.crop.CropPushVideoHolder;

import org.videolan.libvlc.LibVLC;
import org.videolan.libvlc.Media;
import org.videolan.libvlc.MediaPlayer;
import org.videolan.libvlc.interfaces.IVLCVout;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import video.VideoPlayer;

/**
 * 对接播放器的SDK.
 * cropModle=true还不可以使用，经测试不是很稳定、程序崩溃.
 */
public class VideoSDK {
    private static final String TAG = "VideoSDK";

    private LibVLC libVLC;
    private MediaPlayer mediaPlayer;
    private IVLCVout vout;
    private boolean manualPlaySts = false; // 记录播放操作状态
    private boolean realPlaySts = false;   // 记录实际播放状态

    private boolean cropModle = false; // 是否需要启用动态Holder模式
    private Integer holderMaxNum; // CropPushVideoHolder数量上限
    private List<CropPushVideoHolder> videoHolderLst = Collections.synchronizedList(new ArrayList<CropPushVideoHolder>());

    private Context context;
    private TextureView faceView;
    private String url;
    private Integer cacheI;
    private Timer timer;
    private static VideoSDK instance;

    public static synchronized VideoSDK getInstance() {
        if (null == instance) {
            instance = new VideoSDK();
        }
        return instance;
    }

    public VideoSDK() {
        this(false, null);
    }

    /**
     * @param cropModle 切割模式[true-启用多线程处理]
     */
    public VideoSDK(boolean cropModle) {
        this(cropModle, null);
    }

    /**
     * @param cropModle 切割模式[true-启用多线程处理]
     * @param holderMaxNum 线程数量上限
     */
    public VideoSDK(boolean cropModle, Integer holderMaxNum) {
        this.cropModle = cropModle;
        this.holderMaxNum = holderMaxNum;
        this.init();
    }

    private void init() {
        this.timer = new Timer();
        this.timer.schedule(new ReConnectPlay(), 5000, 10000);
    }

    /**
     * 开始播放视频.
     * @param context 上下文
     * @param faceView 视频源的显示视图
     * @param url 视频地址
     * @param cacheI 缓冲buffer
     */
    public synchronized void startPlay(Context context, TextureView faceView, String url, Integer cacheI) {
        try {
            if (null == context) {
                Log.i(TAG, "context不可为空！");
                return;
            }
            if (null == faceView) {
                Log.i(TAG, "faceView不可为空！");
                return;
            }
            if (null == url || "".equals(url.trim())) {
                Log.i(TAG, "url不可为空！");
                return;
            }
            this.context = context;
            this.faceView = faceView;
            this.url = url;
            this.cacheI = cacheI;
            Log.i(TAG, "&&&&&&&&&&&&&&&&&&&&&  rtsp.url:" + url);

            if (mediaPlayer != null && mediaPlayer.isPlaying()) {
                releasePlayer();
            }

            List<String> options = new ArrayList<String>();
            options.add("--aout=opensles");
            options.add("--audio-time-stretch"); // time stretching
            options.add("-vvv"); // verbosity
            libVLC = new LibVLC(context, options);

            mediaPlayer = new MediaPlayer(libVLC);
            vout = mediaPlayer.getVLCVout();
            vout.setVideoView(faceView);
            //  vout.setWindowSize(R.dimen.surfaceW, R.dimen.surfaceH);

            final Media media = new Media(libVLC, Uri.parse(url));
            int cache = null!=cacheI?cacheI.intValue():50;
            media.addOption(":network-caching=" + cache);
            media.addOption(":file-caching=" + cache);
            media.addOption(":live-cacheing=" + cache);
            media.addOption(":sout-mux-caching=" + cache);
            media.addOption(":codec=mediacodec,iomx,all");

            vout.attachViews(); // 播放前还要调用这个方法
            mediaPlayer.setMedia(media);
            mediaPlayer.setEventListener(new MediaEvenListener());
            mediaPlayer.play();
            this.manualPlaySts = true;
        } catch (Exception e) {
            this.releasePlayer();
            Log.i(TAG, "出异常了：", e);
        }
    }

    public void stopPlay() {
        this.releasePlayer();
        this.manualPlaySts = false;
    }

    /**
     * 关闭&释放视频.
     */
    private synchronized void releasePlayer() {
        // mediaPlayer.setVideoCallback(null, null, null); aar中无此方法
        if (null != mediaPlayer) {
            if (null != mediaPlayer.getMedia()) {
                mediaPlayer.getMedia().clearSlaves();
                mediaPlayer.getMedia().release();
            }
            mediaPlayer.setMedia(null);
            mediaPlayer.stop();
            mediaPlayer.release();
        }
        if (null != vout) {
            vout.detachViews();
        }
        if (null != libVLC) {
            libVLC.release();
        }
        mediaPlayer = null;
        vout = null;
        libVLC = null;
        Log.i(TAG, "&&&&&&&&&&& releasePlayer()!");
    }

    /**
     * 创建切割任务.
     *   viewW、viewH不为空时会改变sourceView的尺寸.
     *  备注：欲启用动态模式，需先设置模式再调用此方法.
     * @param bmpContainer 帧数据容器(从其中获得图片数据)
     * @param sourceView 视频源的显示视图
     * @param viewW 视图宽度
     * @param viewH 视频高度
     * @param rowNum 切割的行数
     * @param colNum 切割的列数
     * @return 切割任务索引
     */
    public void createCropTask(BmpContainer bmpContainer, TextureView sourceView, Integer viewW, Integer viewH, int rowNum, int colNum) {
        if (null != sourceView || null != bmpContainer) {
            if (this.videoHolderLst.size() == 0) {
                if (this.cropModle) {
                    int cpuNum = Runtime.getRuntime().availableProcessors(); // 获得CPU数量
                    int hoderNum = cpuNum - 2;
                    Log.i(TAG, "############################## cpu.num:" + cpuNum);

                    if (null != this.holderMaxNum) {
                        hoderNum = this.holderMaxNum.intValue();
                    } else if (hoderNum < 1) {
                        hoderNum = 1;
                    }

                    for(int i = 0; i < hoderNum; i++) {
                        this.videoHolderLst.add(new CropPushVideoHolder(i, bmpContainer, sourceView, rowNum, colNum, viewW, viewH));
                    }
                } else {
                    this.videoHolderLst.add(new CropPushVideoHolder(0, bmpContainer, sourceView, rowNum, colNum, viewW, viewH));
                }
            } else {
                Log.i(TAG, "******************** VideoHolder已经初始化过，本次不进行初始化！");
            }
        } else {
            Log.e(TAG, "创建切割任务-失败：sourceView不可为空！");
        }
    }

    /**
     * 销毁切割任务.
     */
    public void destroyCropTask() {
        int size = videoHolderLst.size();
        CropPushVideoHolder temp = null;

        for(int i = 0; i < size; i++) {
            temp = videoHolderLst.get(i);
            temp.destroy();
            temp.getViewLst().clear();
            temp = null;
        }

        videoHolderLst.clear();
    }

    /**
     * 为切割任务添加新的显示视图.
     * 备注：需要先调用'createCropTask(.)/创建切割任务'再使用该方法.
     * @param view 视频源、播放空间
     * @param videoIndex 视频索引，指定的view所关联的视频ID
     * @param viewId 视图标识
     * @param groupId 视图组标识
     * @param layerId 图层ID
     * @return Integer viewIndex/视图索引[可为空]
     */
    public synchronized Integer addView(CropView view, Integer videoIndex, int viewId, Integer groupId, Integer layerId, Integer type, Integer offsetX, Integer offsetY, Integer w, Integer h) {
        Integer rs = null;

        if (null != view) {
            CropPushVideoHolder videoHolder = this.selectHolder(videoIndex);

            if (null != videoHolder) {
//                Log.i(TAG, "向‘视图集合’中添加View-成功！");
                rs = this.addView(videoHolder, view, videoIndex, viewId, groupId, layerId, type, offsetX, offsetY, w, h);
//                Log.i(TAG, "添加1个视图后，当前图层数量：" + getViewNum() + ", videoIndex:" + ", viewId:" + viewId);
            } else {
                Log.i(TAG, "添加切割视图时-失败：videoHolder为空!确定是否调用了'createCropTask(.)/创建切割任务'?");
            }
        } else {
            Log.i(TAG, "添加切割视图时-失败：view不可为空！");
        }

        return rs;
    }

    /**
     * 为切割任务添加新的显示视图.
     * @param videoHolder 切割任务索引(createCropTask(.)的返回值)
     * @param view 视频源、播放空间
     * @param videoIndex 视频索引，表面指定的view所关联的视频ID
     * @param viewId 视图标识
     * @param groupId 视图组标识
     * @param layerId 图层ID
     * @return Integer viewIndex/视图索引[可为空]
     */
    private Integer addView(CropPushVideoHolder videoHolder, CropView view, Integer videoIndex, int viewId, Integer groupId, Integer layerId, Integer type, Integer offsetX, Integer offsetY, Integer w, Integer h) {
        return videoHolder.addView(view, videoIndex, viewId, groupId, layerId, type, offsetX, offsetY, w, h);
    }

    /**
     * 从视图集合中删除指定的View.
     * @param viewId 视图标识
     * @return boolean true-删除成功；false-删除失败
     */
    public boolean removeViewByViewId(int viewId) {
        boolean rs = false;
        int count = this.videoHolderLst.size();

        if (count == 0) {
            Log.i(TAG, "删除视图-失败:未开启切割任务！");
            return rs;
        }

        CropPushVideoHolder tempHolder = null;
        for(int i = 0; i < count; i++) {
            tempHolder = this.videoHolderLst.get(i);
            rs = tempHolder.removeViewByViewId(viewId);
            if (rs) {
                break;
            }
        }

        if (rs) {
            Log.i(TAG, "删除1个视图-成功！后，当前图层数量：" + getViewNum());
        } else {
            Log.e(TAG, "删除1个视图-失败！后，当前图层数量：" + getViewNum());
        }

        return rs;
    }

    /**
     * 从视图集合中删除指定组内的所有View.
     * @param groupId 视图组标识
     * @return boolean true-删除成功；false-删除失败
     */
    public boolean removeViewByGroupId(int groupId) {
        boolean rs = false;
        int delNum = 0;
        int count = this.videoHolderLst.size();

        if (count == 0) {
            Log.i(TAG, "删除视图-失败:未开启切割任务！");
            return rs;
        }

        CropPushVideoHolder tempHolder = null;
        for(int i = 0; i < count; i++) {
            tempHolder = this.videoHolderLst.get(i);
            List<ViewBean> lstToDel = tempHolder.findViewBeanByGroupId(groupId);

            for(int k = 0; k < lstToDel.size(); k++) {
                rs = tempHolder.removeViewByViewId(lstToDel.get(k).getViewId());
                if (rs) {
                    delNum++;
                }
            }
        }

        if (delNum > 0) {
            rs = true;
            Log.i(TAG, "根据视图组删除" + delNum + "个视图-成功！后，当前图层数量：" + getViewNum());
        } else {
            rs = false;
            Log.e(TAG, "根据视图组删除" + delNum + "个视图-失败！后，当前图层数量：" + getViewNum());
        }

        return rs;
    }

    /**
     * 改变View对应的视频索引.
     * @param viewId 视图标识
     * @param videoIndex 视频索引[可为空]
     */
    public boolean changeViewVideoIndexByViewId(int viewId, Integer videoIndex, Integer type, Integer offsetX, Integer offsetY, Integer w, Integer h) {
        boolean rs = false;
        int count = this.videoHolderLst.size();

        if (count == 0) {
            Log.i(TAG, "切源-失败:未开启切割任务！");
            return rs;
        }

        CropPushVideoHolder tempHolder = null;
        for(int i = 0; i < count; i++) {
            tempHolder = this.videoHolderLst.get(i);
            rs = tempHolder.changeViewVideoIndexByViewId(viewId, videoIndex, type, offsetX, offsetY, w, h);
            if (rs) {
                break;
            }
        }

        if (rs) {
            Log.i(TAG, "切源-成功！后，当前图层数量：" + getViewNum() + ", viewId:" + viewId + ", videoIndex:" + videoIndex);
        } else {
            Log.e(TAG, "切源失败！后，当前图层数量：" + getViewNum() + ", viewId:" + viewId + ", videoIndex:" + videoIndex);
        }

        return rs;
    }

    /**
     * 改变View对应的视频索引.
     * @param groupId 视图组标识
     * @param layerId 图层ID
     * @param videoIndex 视频索引[可为空]
     */
    public boolean changeVideoIndexByLayerId(Integer groupId, int layerId, Integer videoIndex, Integer type, Integer offsetX, Integer offsetY, Integer w, Integer h) {
        boolean rs = false;
        int count = this.videoHolderLst.size();

        if (count == 0) {
            Log.i(TAG, "切源-失败:未开启切割任务！");
            return rs;
        }

        CropPushVideoHolder tempHolder = null;
        for(int i = 0; i < count; i++) {
            tempHolder = this.videoHolderLst.get(i);
            rs = tempHolder.changeVideoIndexByLayerId(groupId, layerId, videoIndex, type, offsetX, offsetY, w, h);
            if (rs) {
                break;
            }
        }

        if (rs) {
            Log.i(TAG, "切源-成功！后，当前图层数量：" + getViewNum() + ", layerId:" + layerId + ", videoIndex:" + videoIndex + ", groupId:" + groupId);
        } else {
            Log.e(TAG, "切源失败！后，当前图层数量：" + getViewNum() + ", layerId:" + layerId + ", videoIndex:" + videoIndex + ", groupId:" + groupId);
        }

        return rs;
    }

    /**
     * 获得视图数量.
     * @return int 视图数量
     */
    public int getViewNum() {
        int rs = 0;
        int size = videoHolderLst.size();
        CropPushVideoHolder holderTemp = null;

        for(int i = 0; i < size; i++) {
            holderTemp = videoHolderLst.get(i);
            rs += holderTemp.getViewLst().size();
        }

        return rs;
    }

    public void destroy() {
        this.timer.cancel();
        this.timer.purge();

        this.destroyCropTask();
        this.stopPlay();

        this.context = null;
        this.faceView = null;
        this.url = null;
        this.cacheI = null;
    }

    /**
     * 选择压力小的Holder.
     * @param videoIndex 视频索引，表面指定的view所关联的视频ID
     * @return CropPushVideoHolder实例[可能为空]
     */
    private CropPushVideoHolder selectHolder(int videoIndex) {
        int count = this.videoHolderLst.size();

        if (count == 0) {
            Log.i(TAG, "操作-失败:未开启切割任务！");
            return null;
        }

        // 优先选择含有同videoIndex的holder,若没有则选择压力小的holder
        CropPushVideoHolder tempHolder = null;
        CropPushVideoHolder minHolder = null; // 压力最小的holder
        Integer minNun = null;

        for(int i = 0; i < count; i++) {
            tempHolder = this.videoHolderLst.get(i);

            // 选择含有同videoIndex的holder
            List<ViewBean> viewLst = tempHolder.getViewLst();
            ViewBean viewBeanTemp = null;
            Integer videoIndexTemp = null;

            for(int j = 0; j < viewLst.size(); j++) {
                viewBeanTemp = viewLst.get(j);
                videoIndexTemp = viewBeanTemp.getVideoIndex();
                if (null != videoIndexTemp && videoIndexTemp.intValue() == videoIndex) {
                    return tempHolder;
                }
            }

            // 记录压力最小的holder
            if (null == minNun) {
                minNun = tempHolder.getViewNum();
                minHolder = tempHolder;
            } else {
                if (tempHolder.getViewNum() < minNun.intValue()) {
                    minNun = tempHolder.getViewNum();
                    minHolder = tempHolder;
                }
            }
        }

        return minHolder;
    }

    public boolean isCropModle() {
        return cropModle;
    }

    public void setCropModle(boolean cropModle) {
        this.cropModle = cropModle;
    }

    public Integer getHolderMaxNum() {
        return holderMaxNum;
    }

    public void setHolderMaxNum(Integer holderMaxNum) {
        this.holderMaxNum = holderMaxNum;
    }

    public class MediaEvenListener implements MediaPlayer.EventListener {
        @Override
        public void onEvent(MediaPlayer.Event event) {
            // Log.d(TAG, "================ onEvent: " + String.valueOf(event.type) + ", isPlaying:" + mediaPlayer.isPlaying()); // 播放时会不停地有输出
            if (event.type == MediaPlayer.Event.EndReached) {
                Log.d("MediaPlayer", "onEvent:  MediaPlayer.Event.EndReached");
            } else if (event.type == MediaPlayer.Event.Playing) {
                if (mediaPlayer.isPlaying()) {
                    realPlaySts = true;
                }
            } else if (event.type == MediaPlayer.Event.Stopped) {
                releasePlayer();
                realPlaySts = false;
            }
        }
    }

    public class ReConnectPlay extends TimerTask {
        @Override
        public void run() {
//            Log.i(TAG, "**************重连 manualPlaySts：" + manualPlaySts + ", realPlaySts:" + realPlaySts + ", mediaPlayer is null:" + (null==mediaPlayer?"true":"false"));
            if (manualPlaySts) {
                if (null == mediaPlayer || (!mediaPlayer.isPlaying() && !realPlaySts)) {
                    if (null != context) {
                        if (null != faceView) {
                            if (null != url) {
                                startPlay(context, faceView, url, cacheI);
                            } else {
                                Log.i(TAG, "**************重连 url 不可为空！");
                            }
                        } else {
                            Log.i(TAG, "**************重连 faceView 不可为空！");
                        }
                    } else {
                        Log.i(TAG, "**************重连 context 不可为空！");
                    }
                }
            }
        }
    }
}
