package com.video.crop.work4;

import android.annotation.SuppressLint;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import com.video.crop.CropPushVideoHolder;
import com.video.bean.CropView;
import com.video.bean.ViewBean;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

/**
 * 切割与播放/推送视频.
 */
public class CropPushVideoThread extends Thread {
    private static final String TAG = "CropPushVideoThread";
    private CropPushVideoHolder holder;

    // 每个图片的尺寸.初始默认为：0
    private int imgW = 0;
    private int imgH = 0;
    private Hashtable<Integer, Bitmap> table = new Hashtable<Integer, Bitmap>();

    public CropPushVideoThread(CropPushVideoHolder holder) {
        this.holder = holder;
    }

    @Override
    public void run() {
        int sleepTime = 1000; // 切割周期
        int sleepFree = 1000; // 无内容时的切割周期
        int sleepWork = 20;   // 有内容时的切割周期（经过测试该值建议在3~5ms,因为：图片接收&渲染64张耗时1~4ms[大部分都是1、2]）
        Bitmap bit = null;

        while (true) {
            try {
                if (!this.holder.cropSts) {
                    release();
                    break;
                }
                Thread.sleep(sleepTime);

                if (holder.getViewLst().size() > 0) {
                    long st = System.currentTimeMillis();

                    bit = getBmp(); // 获得帧图片

                    if (null != bit) {
                        sleepTime = sleepWork;
                        imgProcess(bit);

                        long et = System.currentTimeMillis();
                        Log.i(TAG, "444切割&发送,不转码 耗时(ms)：" + (et-st) + ", rowNum:" + holder.getRowNum() + ", colNum:" + holder.getColNum() + ", sleepTime:" + sleepTime); // 切割&发送,不转码 耗时(ms)：100
                    } else {
                        Log.e(TAG, "周期‘切割与播放/推送视频’未能获得帧图片!");
                    }
                } else {
                    sleepTime = sleepFree; // 视图集合为空时加大sleep时间以降低设备压力
                }
            } catch (Exception e) {
                Log.e(TAG, "周期‘切割与播放/推送视频’过程中出现异常:", e);
            }
        }

        Log.i(TAG, "&&&&&&&&&&&&&& 切割任务退出！holder.index:" + holder.getIndex());
    }

    /**
     * 获得图片数据.
     * 优先从BmpContainer中获取，如果BmpContainer为空则从SourceView上获取.
     * @return
     */
    private Bitmap getBmp() {
        if (null != holder.getBmpContainer()) {
            return holder.getBmpContainer().getBmp();
        } else if (null != holder.getSourceView()) {
            return holder.getSourceView().getBitmap(); // 从播放器上获得图片耗时(ms)：50
        } else {
            Log.e(TAG, "获得帧数据-失败：BmpContainer与SourceView都为空!");
            return null;
        }
    }

    /**
     * 任务结束时处理需要释放、销毁的内容.
     */
    private void release() {
        this.imgW = 0;
        this.imgH = 0;
    }

    private List<ViewBean> viewLst = null;
    private int count = 0;
    private int w = 0;
    private int h = 0;
    private Bitmap tempSmallImg = null;
    private ViewBean viewBeanTemp = null;
    private int x = 0;
    private int y = 0;
    private int videoIndex = 0;
    private int rowNo = -1;
    private int colNo = -1;
    private int iterateI = 0;
//    private ArrayList<Integer> videoIndexLst = new ArrayList<Integer>(); // 记录每轮切割过的视频

    /**
     * 将原图进行切割并推送到所对应的View上.
     * @param sourceBit 原图
     */
    private void imgProcess(Bitmap sourceBit) {
        viewLst = holder.getViewLst();
        count = viewLst.size();
        if (0 == count) {
            return;
        }

        // 计算要切割图片的尺寸(只首次进行计算,否在每次都计算的话会有99%的不必要CPU浪费)。缺点：如果播放过程中播放器View尺寸变化则导致切割图像不正确.
        if (this.imgW == 0) {
            w = sourceBit.getWidth();
            h = sourceBit.getHeight();

            if (w > 0 && h > 0) {
                this.imgW = w/holder.getColNum();
                this.imgH = h/holder.getRowNum();
            } else {
                Log.e(TAG, "视频帧尺寸竟然==0!!!");
                return;
            }
        }

//        videoIndexLst.clear(); // 切割前要清空上一轮的切割记录
        ArrayList<Integer> videoIndexLst = new ArrayList<Integer>();
        iterateI = 0;

        // 切割视频图片,并放到对应的View上
        for(; iterateI < count; iterateI++) { // 切割&发送64张耗时(ms)：200;  不发送，只切割64张耗时(ms)：50
            viewBeanTemp = viewLst.get(iterateI);

            if (null != viewBeanTemp.getVideoIndex() && null != viewBeanTemp.getRowNo() && null != viewBeanTemp.getColNo()) {

                // 处理越界情况
                if (viewBeanTemp.getRowNo() > (holder.getRowNum()-1) || viewBeanTemp.getColNo() > (holder.getColNum()-1)) {
                    Log.e(TAG, "视图行列号越界.rowNo:" + viewBeanTemp.getRowNo() + "; colNo:" + viewBeanTemp.getColNo());
                    continue;
                }

                videoIndex = viewBeanTemp.getVideoIndex().intValue();
                if (videoIndexLst.contains(videoIndex)) {
                    continue; // 如果该videoIndex位置的视频已经切割过了，就没有必要再切割了
                }

                rowNo = viewBeanTemp.getRowNo().intValue();
                colNo = viewBeanTemp.getColNo().intValue();
                x = colNo * this.imgW;
                y = rowNo * this.imgH;
                videoIndexLst.add(videoIndex);

                tempSmallImg = Bitmap.createBitmap(sourceBit, x, y, this.imgW, this.imgH); // 图片扣取部分内容
                table.put(videoIndex, tempSmallImg);

            } else {
                Log.i(TAG, "小图尺寸 参数有为空的, count.iterateI:" + iterateI);
            }
        }

        this.pushImgToView(rowNo, colNo, videoIndexLst);
    }

    /**
     * 将切割后的图片推送到对应的View上.
     * @param rowNo 切割图片的索引-行号
     * @param colNo 切割图片的索引-列号
     * @param videoIndexLst 切割图片的索引号-集合
     */
    private void pushImgToView(int rowNo, int colNo, ArrayList<Integer> videoIndexLst) {
        Message msg = new Message();
        Bundle bundle = new Bundle();
        bundle.putInt("rowNo", rowNo);
        bundle.putInt("colNo", colNo);
        bundle.putIntegerArrayList("videoIndexLst", videoIndexLst);
        msg.setData(bundle);
        msg.what = holder.getIndex();

        handler.sendMessage(msg); //发消息到主线程
    }

    @SuppressLint("HandlerLeak")
    private Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            if (msg.what == holder.getIndex()) { // 图片还原&ImageView渲染1张耗时(ms)：2
//                long st = System.currentTimeMillis();
                Bundle data = msg.getData();
                int rowNo = data.getInt("rowNo");
                int colNo = data.getInt("colNo");
                ArrayList<Integer> videoIndexLst = data.getIntegerArrayList("videoIndexLst");

                if (null != videoIndexLst) {
                    int videoIndexTemp = 0;
                    int videoIndexCount = videoIndexLst.size();
                    Bitmap img = null;

                    for(int ii = 0; ii < videoIndexCount; ii++) {
                        videoIndexTemp = videoIndexLst.get(ii);
                        img = table.get(videoIndexTemp);

                        if (null != img) {
                            List<ViewBean> viewBeanLst = holder.findViewBeanByIndex(rowNo, colNo, videoIndexTemp);
                            int viewNum = viewBeanLst.size();
                            ViewBean viewBeanTemp = null;
                            CropView viewTemp = null;

                            for(int kk = 0; kk < viewNum; kk++) {
                                viewBeanTemp = viewBeanLst.get(kk);
                                viewTemp = viewBeanTemp.getView();

                                if (null != viewTemp) {
                                    if (!viewTemp.isDestroy()) {
                                        viewTemp.showImage(img); // ImageView渲染1张耗时0~1ms
                                    } else {
                                        holder.removeViewBean(viewBeanTemp); // 如果View已被销毁则从集合中删除
                                        Log.i(TAG, "***********************View已被销毁固从集合中删除!");
                                    }
                                } else {
                                    Log.e(TAG, "图片接收/刷新-失败：ViewBean中无对应的view！rowNo:" + rowNo + ", colNo:" + colNo + ", videoIndexTemp:" + videoIndexTemp);
                                }
                            }
                        } else {
                            Log.e(TAG, "图片接收/刷新-失败：img为空!");
                        }
                    }
                } else {
                    Log.e(TAG, "图片接收/刷新-失败：videoIndex为空！ videoIndex:" + videoIndex);
                }

//                long et = System.currentTimeMillis();
//                Log.i(TAG, "图片还原&ImageView渲染"+videoIndexLst.size()+"张耗时(ms)：" + (et-st)); // 图片还原&ImageView渲染64张耗时(ms)：3
            }
        }
    };

}
