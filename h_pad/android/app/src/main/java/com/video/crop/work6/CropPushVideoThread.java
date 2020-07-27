package com.video.crop.work6;

import android.graphics.Bitmap;
import android.util.Log;

import com.video.crop.CropPushVideoHolder;
import com.video.bean.ViewBean;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.BlockingQueue;

/**
 * 切割与播放/推送视频.
 */
public class CropPushVideoThread extends Thread {
    private static final String TAG = "CropPushVideoThread";
    private CropPushVideoHolder holder;
    private BlockingQueue<Bitmap> queue;
    private int maxCacheNum = 256; // 图片缓存的数量间接控制图片销毁的时间.因为CropView中使用了“postInvalidate()、onDraw()”所以不能立即销毁，
    private Bitmap[] bmpArray = new Bitmap[maxCacheNum];
    private int bmpArrayIterator = 0;

    // 每个图片的尺寸.初始默认为：0
    private int imgW = 0;
    private int imgH = 0;

    public CropPushVideoThread(CropPushVideoHolder holder) {
        this.holder = holder;
        this.queue = holder.getBmpContainer().getQueue();

        if (null == this.queue) {
            Log.e(TAG, "^^^^^^^^^^^^^^^^^^^^^^^^^ queue不可为空!");
        }
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

                if (holder.getViewLst().size() > 0) {
                    long st = System.currentTimeMillis();

                    bit = this.queue.take(); // 获得帧图片

                    if (null != bit) {
                        sleepTime = sleepWork;
                        imgProcess(bit);
//                        appendToDel(bit);

                        long et = System.currentTimeMillis();
//                        Log.i(TAG, "555切割&发送,不转码 耗时(ms)：" + (et-st) + ", rowNum:" + holder.getRowNum() + ", colNum:" + holder.getColNum() + ", sleepTime:" + sleepTime); // 切割&发送,不转码 耗时(ms)：100
                    } else {
                        Log.e(TAG, "周期‘切割与播放/推送视频’未能获得帧图片!");
                    }
                } else {
                    sleepTime = sleepFree; // 视图集合为空时加大sleep时间以降低设备压力
                    Thread.sleep(sleepTime);
                }
            } catch (Exception e) {
                Log.e(TAG, "周期‘切割与播放/推送视频’过程中出现异常:", e);
            }
        }

        Log.i(TAG, "&&&&&&&&&&&&&& 切割任务退出！holder.index:" + holder.getIndex());
    }

    private void appendToDel(Bitmap bmp) {
        int saveIndex = bmpArrayIterator++;
        if (saveIndex > (maxCacheNum - 1)) {
            saveIndex = 0;
        }

        Bitmap temp = bmpArray[saveIndex];

        if (null != temp && !temp.isRecycled()) {
            temp.recycle();
            temp = null;
            bmpArray[saveIndex] = null;
//            Log.i(TAG, ">>>>>>>>>>>>>>>>>>>>>>>>>> 释放帧图片！");
        }

        bmpArray[saveIndex] = bmp;
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
    private int right;
    private int bottom;
    private int videoIndex = 0;
    private int rowNo = -1;
    private int colNo = -1;
    private int iterateI = 0;

    /**
     * 将原图进行切割并推送到所对应的View上.
     * @param sourceBit 原图
     */
    private void imgProcess(Bitmap sourceBit) {
        viewLst = holder.getViewLst();
        count = viewLst.size();
        if (0 == count) {
            Log.i(TAG, "终止切割处理-视频数量未0！");
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

        List<ViewBean> viewBeanToDelLst = new ArrayList<ViewBean>();

        // 切割视频图片,并放到对应的View上
        iterateI = 0;
        for(; iterateI < count; iterateI++) { // 切割&发送64张耗时(ms)：200;  不发送，只切割64张耗时(ms)：50
            viewBeanTemp = viewLst.get(iterateI);

            if (null != viewBeanTemp.getVideoIndex() && null != viewBeanTemp.getRowNo() && null != viewBeanTemp.getColNo()) {
                if (viewBeanTemp.getView().isDestroy()) {
                    viewBeanToDelLst.add(viewBeanTemp);
                    continue;
                }

                // 处理越界情况
                if (viewBeanTemp.getRowNo() > (holder.getRowNum()-1) || viewBeanTemp.getColNo() > (holder.getColNum()-1)) {
                    Log.e(TAG, "视图行列号越界.rowNo:" + viewBeanTemp.getRowNo() + "; colNo:" + viewBeanTemp.getColNo());
                    continue;
                }

                rowNo = viewBeanTemp.getRowNo().intValue();
                colNo = viewBeanTemp.getColNo().intValue();
                x = colNo * this.imgW;
                y = rowNo * this.imgH;
                right = x + this.imgW;
                bottom = y + this.imgH;

                viewBeanTemp.getView().showImage(sourceBit, x, y, right, bottom);

            } else {
                Log.i(TAG, "小图尺寸 参数有为空的, count.iterateI:" + iterateI);
            }
        }

        holder.removeViewBean(viewBeanToDelLst);
    }

}
