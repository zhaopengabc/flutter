package com.video.crop;

import android.util.Log;
import android.view.TextureView;
import android.view.View;
import android.view.ViewGroup;

import com.video.bean.BmpContainer;
import com.video.bean.CropView;
import com.video.bean.ViewBean;
import com.video.crop.work7.CropPushVideoThread;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;


/**
 * '切割与播放/推送视频'Holder.
 */
public class CropPushVideoHolder {
    private static final String TAG = "CropPushVideoHolder";
    private Integer index = null; // CropPushVideoHolder实例序号

    public boolean cropSts = false; // 切割状态[true-切割中;false-人工停止]
    private CropPushVideoThread cropPushVideoThread;
    private BmpContainer bmpContainer;
    private TextureView sourceView;
    private List<ViewBean> viewLst = Collections.synchronizedList(new LinkedList<ViewBean>());

    // 要切割的行列数
    private int rowNum = 2;
    private int colNum = 2;

    // 视频分辨率,单位：像素
    private int videoW = 1920;
    private int videoH = 1080;
    private volatile boolean viewChange = true; // view信息是否发生变化(添加、删除、切源 都视为变化)
    private Map<Integer, List<ViewBean>> viewCache = new HashMap<Integer, List<ViewBean>>();

    public CropPushVideoHolder(Integer index) {
        this(index,null, null, 2, 2, 1920, 1080);
    }

    public CropPushVideoHolder(Integer index, BmpContainer bmpContainer, TextureView view) {
        this(index, bmpContainer, view, 2, 2, 1920, 1080);
    }

    public CropPushVideoHolder(Integer index, BmpContainer bmpContainer, TextureView view, int rowNum, int colNum) {
        this(index, bmpContainer, view, rowNum, colNum, 1920, 1080);
    }

    public CropPushVideoHolder(Integer index, BmpContainer bmpContainer, TextureView view, int rowNum, int colNum, int videoW, int videoH) {
        this.index = index;
        this.bmpContainer = bmpContainer;
        this.sourceView = view;
        this.rowNum = rowNum;
        this.colNum = colNum;
        this.videoW = videoW;
        this.videoH = videoH;

        this.flushRowColNo(); // 刷新所有视图的行列号
        this.setViewWH(view, videoW, videoH); // 设置视频源视图的尺寸

        // 开启视频切割显示任务
        this.cropPushVideoThread = new CropPushVideoThread(this);
        this.cropPushVideoThread.start();
        this.cropSts = true;
    }

    /**
     * 销毁.
     */
    public void destroy() {
        this.cropSts = false;
        this.sourceView = null;
    }

    /**
     * 设置切割视频的行列数,并刷新所有视图的行列号.
     * @param rowNum
     * @param colNum
     */
    public void setRowColNum(int rowNum, int colNum) {
        if (rowNum > 0 && colNum > 0) {
            this.rowNum = rowNum;
            this.colNum = colNum;
            this.flushRowColNo(); // 刷新所有视图的行列号
        } else {
            Log.i(TAG, "行列数量必须大于0. rowNum：" + rowNum + ", colNum：" + colNum);
        }
    }

    public Integer addView(CropView view) {
        boolean bln = viewLst.add(new ViewBean(view));
        viewChange = true;

        if (bln) {
            return viewLst.size() - 1;
        } else {
            Log.e(TAG, "添加视频-失败!");
            return null;
        }
    }

    public Integer addView(CropView view, Integer videoIndex, int viewId, Integer groupId, Integer layerId, Integer type, Integer offsetX, Integer offsetY, Integer w, Integer h) {
        boolean bln = viewLst.add(new ViewBean(view, videoIndex, viewId, groupId, layerId, videoIndex/this.colNum, videoIndex%this.colNum, type, offsetX, offsetY, w, h));
        viewChange = true;

        if (bln) {
            return viewLst.size() - 1;
        } else {
            Log.e(TAG, "添加视频-失败!");
            return null;
        }
    }

    /**
     * 从视图集合中删除指定的View.
     * @param viewIndex 视图索引
     */
    public void removeView(int viewIndex) {
        viewLst.remove(viewIndex);
        viewChange = true;
    }

    /**
     * 从视图集合中删除指定的View.
     * @param viewId 视图标识
     */
    public boolean removeViewByViewId(int viewId) {
        return removeViewBean(findViewBeanByViewId(viewId));
    }

    /**
     * 从视图集合中删除指定的View.
     * @param view
     */
    public void removeView(CropView view) {
        ViewBean viewBean = this.findViewBean(view);

        if (null != viewBean) {
            viewChange = true;
            viewLst.remove(viewBean);
        }
    }

    public boolean removeViewBean(ViewBean viewBean) {
        if (null != viewBean) {
            viewLst.remove(viewBean);
            viewChange = true;
            viewBean = null;
            return true;
        }
        return false;
    }

    public void removeViewBean(List<ViewBean> viewBeanLst) {
        if (viewBeanLst.size() > 0) {
            ViewBean temp = null;
            for(int i = 0; i < viewBeanLst.size(); i++) {
                temp = viewBeanLst.get(i);
                removeViewBean(temp);
                temp = null;
            }
            Log.i(TAG, "从'视图集合'中清理掉:" + viewBeanLst.size() + "个视图! 剩余图层数量：" + this.getViewNum());
        }
    }

    /**
     * 改变View对应的视频索引.
     * @param view 视图
     * @param videoIndex 视频索引[可为空]
     */
    public void changeViewVideoIndex(CropView view, Integer videoIndex, Integer type, Integer offsetX, Integer offsetY, Integer w, Integer h) {
        ViewBean viewBean = this.findViewBean(view);
        this.changeVideoIndex(viewBean, videoIndex, type, offsetX, offsetY, w, h);
    }

    /**
     * 改变View对应的视频索引.
     * @param viewIndex 视图索引
     * @param videoIndex 视频索引[可为空]
     */
    public void changeViewVideoIndex(int viewIndex, Integer videoIndex, Integer type, Integer offsetX, Integer offsetY, Integer w, Integer h) {
        if (viewIndex < viewLst.size()) {
            this.changeVideoIndex(viewLst.get(viewIndex), videoIndex, type, offsetX, offsetY, w, h);
        } else {
            Log.e(TAG, "改变View对应的视频索引-失败：viewIndex不存在! viewIndex:" + viewIndex);
        }
    }

    /**
     * 改变View对应的视频索引.
     * @param viewId 视图标识
     * @param videoIndex 视频索引[可为空]
     */
    public boolean changeViewVideoIndexByViewId(int viewId, Integer videoIndex, Integer type, Integer offsetX, Integer offsetY, Integer w, Integer h) {
        boolean rs = false;
        ViewBean viewBean = findViewBeanByViewId(viewId);

        if (null != viewBean) {
            rs = this.changeVideoIndex(viewBean, videoIndex, type, offsetX, offsetY, w, h);
            if (rs) {
                Log.i(TAG, "changeViewVideoIndexByViewId/改变View对应的视频索引-成功! viewId:" + viewId + ", videoIndex:" + videoIndex);
            } else {
                Log.e(TAG, "changeViewVideoIndexByViewId/改变View对应的视频索引-失败! viewId:" + viewId + ", videoIndex:" + videoIndex);
            }
        } else {
            Log.e(TAG, "changeViewVideoIndexByViewId/改变View对应的视频索引-失败：viewId不存在! viewId:" + viewId + ", videoIndex:" + videoIndex);
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
        ViewBean viewBean = findViewBeanByLayerId(groupId, layerId);

        if (null != viewBean) {
            rs = this.changeVideoIndex(viewBean, videoIndex, type, offsetX, offsetY, w, h);
            if (rs) {
                Log.i(TAG, "changeVideoIndexByLayerId/改变View对应的视频索引-成功! groupId:" + groupId + ", layerId:" + layerId + ", videoIndex:" + videoIndex);
            } else {
                Log.e(TAG, "changeVideoIndexByLayerId/改变View对应的视频索引-失败! groupId:" + groupId + ", layerId:" + layerId + ", videoIndex:" + videoIndex);
            }
        } else {
            Log.e(TAG, "changeVideoIndexByLayerId/改变View对应的视频索引-失败：layerId不存在! groupId:" + groupId + ", layerId:" + layerId + ", videoIndex:" + videoIndex);
        }

        return rs;
    }

    /**
     * 设置指定视图的‘视频索引’.
     * @param viewBean
     * @param videoIndex
     */
    private boolean changeVideoIndex(ViewBean viewBean, Integer videoIndex, Integer type, Integer offsetX, Integer offsetY, Integer w, Integer h) {
        boolean rs = false;

        if (null != viewBean) {
            viewBean.setVideoIndex(videoIndex);
            viewBean.setType(type);
            viewBean.setOffsetX(offsetX);
            viewBean.setOffsetY(offsetY);
            viewBean.setW(w);
            viewBean.setH(h);

            if (null != videoIndex) {
                viewBean.setRowNo(videoIndex.intValue()/this.colNum);
                viewBean.setColNo(videoIndex.intValue()%this.colNum);
                Log.i(TAG, "切源中 rowNo:" + viewBean.getRowNo() + ", colNo:" + viewBean.getColNo());
            } else {
                viewBean.setRowNo(null);
                viewBean.setColNo(null);
            }
            viewChange = true;
            rs = true;
        }

        return rs;
    }

    /**
     * 根据view获得对应的Bean.
     * @param view
     * @return
     */
    private ViewBean findViewBean(CropView view) {
        ViewBean temp = null;

        for(int i = 0; i < viewLst.size(); i++) {
            temp = viewLst.get(i);

            if (null != temp && view == temp.getView()) {
                return temp;
            }
        }

        return null;
    }

    /**
     * 根据view获得对应的Bean.
     * @param viewId 视图标识
     * @return
     */
    private ViewBean findViewBeanByViewId(int viewId) {
        ViewBean temp = null;

        for(int i = 0; i < viewLst.size(); i++) {
            temp = viewLst.get(i);

            if (null != temp && temp.getViewId() == viewId) {
                return temp;
            }
        }

        return null;
    }

    /**
     * 根据view获得对应的Bean.
     * @param groupId 视图组标识
     * @param layerId 视图标识
     * @return
     */
    private ViewBean findViewBeanByLayerId(Integer groupId, int layerId) {
        ViewBean temp = null;

        for(int i = 0; i < viewLst.size(); i++) {
            temp = viewLst.get(i);

            if (null != temp) {
                if (null != groupId) {
                    if (temp.getLayerId() == layerId && temp.getGroupId() == groupId) {
                        return temp;
                    }
                } else {
                    if (temp.getLayerId() == layerId) {
                        return temp;
                    }
                }
            }
        }

        return null;
    }

    /**
     * 获得指定视图组内的所有ViewBean.
     * @param groupId 视图组标识
     * @return
     */
    public List<ViewBean> findViewBeanByGroupId(int groupId) {
        List<ViewBean> rs = new ArrayList<ViewBean>();

        for(int i = 0; i < viewLst.size(); i++) {
            ViewBean temp = viewLst.get(i);

            if (null != temp && temp.getGroupId() == groupId) {
                rs.add(temp);
            }
        }

        return rs;
    }

    public void clearViewLst() {
        viewLst.clear();
        viewChange = true;
    }

    public TextureView getSourceView() {
        return sourceView;
    }

    public void setSourceView(TextureView sourceView) {
        this.setSourceView(sourceView, null, null);
    }

    /**
     * 设置视频播放器界面以及尺寸.尺寸必须与视频帧的分辨率保持一致.
     * @param sourceView 视频播放容器
     * @param viewW 宽（单位：像素）
     * @param viewH 高（单位：像素）
     */
    public void setSourceView(TextureView sourceView, Integer viewW, Integer viewH) {
        this.sourceView = sourceView;
        this.setViewWH(sourceView, viewW, viewH);
    }

    private void setViewWH(View view, Integer viewW, Integer viewH) {
        if (null != view) {
            ViewGroup.LayoutParams lp = view.getLayoutParams();

            if (null != viewW) {
                lp.width = viewW;
            }
            if (null != viewH) {
                lp.height = viewH;
            }

            view.setLayoutParams(lp);
            view.invalidate();
        } else {
            Log.i(TAG, "设置View尺寸-失败：view为空！(可以为空)");
        }
    }

    /**
     * 获得当前Holder中视图的数量.
     * @return
     */
    public int getViewNum() {
        return this.viewLst.size();
    }

    /**
     * 根据videoIndex重新计算出所有视图的rowNo、colNo.
     */
    private void flushRowColNo() {
        int count = this.viewLst.size();
        ViewBean temp = null;
        int videoIndex = -1;
        Integer videoIndexI = null;

        // 根据videoIndex计算出rowNo、colNo
        for(int i = 0; i < count; i++) {
            temp = this.viewLst.get(i);
            videoIndexI = temp.getVideoIndex().intValue();

            if (null != videoIndexI) {
                videoIndex = videoIndexI.intValue();
                temp.setRowNo(videoIndex/this.colNum);
                temp.setColNo(videoIndex%this.colNum);
            }
        }
    }

    /**
     * 根据'视频索引'获得对应的ViewBean.
     * 备注：会有多个ImgHalderThread线程访问该方法
     * @param rowNo 切割图片的索引-行号
     * @param colNo 切割图片的索引-列号
     * @param videoIndex 切割图片的索引号
     * @return ViewBean[可能为空]
     */
    public synchronized List<ViewBean> findViewBeanByIndex(int rowNo, int colNo, int videoIndex) {

        // 如果view没有发生变化则优先从缓存中获取
        if (!isViewChange()) {
            List<ViewBean> viewLstCache = viewCache.get(videoIndex);
            if (null != viewLstCache) {
                return viewLstCache;
            }
        }

        List<ViewBean> rs = new ArrayList<ViewBean>();
        ViewBean temp = null;

        for(int i = 0; i < getViewLst().size(); i++) {
            temp = getViewLst().get(i);

            if (null != temp) {
                if (null != temp.getView()) {
                    if (null != temp.getVideoIndex()) {
                        if (videoIndex == temp.getVideoIndex().intValue()) {
                            rs.add(temp);
                        }
                    } else {
                        if (null != temp.getRowNo() && null != temp.getColNo()) {
                            if (rowNo == temp.getRowNo().intValue() && colNo == temp.getColNo().intValue()) {
                                rs.add(temp);
                            }
                        }
                    }
                }
            }
        }

        viewCache.put(videoIndex, rs);
        setViewChange(false);

        return rs;
    }

    public List<ViewBean> getViewLst() {
        return this.viewLst;
    }

    public int getRowNum() {
        return rowNum;
    }

    public void setRowNum(int rowNum) {
        this.rowNum = rowNum;
    }

    public int getColNum() {
        return colNum;
    }

    public void setColNum(int colNum) {
        this.colNum = colNum;
    }

    public int getVideoW() {
        return videoW;
    }

    public void setVideoW(int videoW) {
        this.videoW = videoW;
    }

    public int getVideoH() {
        return videoH;
    }

    public void setVideoH(int videoH) {
        this.videoH = videoH;
    }

    public Integer getIndex() {
        return index;
    }

    public boolean isViewChange() {
        return viewChange;
    }

    public void setViewChange(boolean viewChange) {
        this.viewChange = viewChange;
    }

    public BmpContainer getBmpContainer() {
        return bmpContainer;
    }
}
