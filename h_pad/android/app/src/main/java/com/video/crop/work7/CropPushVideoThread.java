package com.video.crop.work7;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;

import com.video.bean.CropView;
import com.video.crop.CropPushVideoHolder;
import com.video.bean.ViewBean;
import com.video.util.VUtil;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingDeque;

/**
 * 切割与播放/推送视频.
 */
public class CropPushVideoThread extends Thread {
    private static final String TAG = "CropPushVideoThread";
    private CropPushVideoHolder holder;
    private BlockingQueue<Bitmap> queue;
    private BlockingQueue<byte[]> queueByte;
    private int maxCacheNum = 256;
    private Bitmap[] bmpArray = new Bitmap[maxCacheNum];
    private int bmpArrayIterator = 0;
    private long viewDelayClearTime = 3000; // 视图延迟清理时间(单位：毫秒)

    // 每个图片的尺寸.初始默认为：0
    private int imgW = 0;
    private int imgH = 0;

    public CropPushVideoThread(CropPushVideoHolder holder) {
        this.holder = holder;
        this.queue = holder.getBmpContainer().getQueue();
        this.queueByte = new LinkedBlockingDeque<byte[]>();

        if (null == this.queue) {
            Log.e(TAG, "^^^^^^^^^^^^^^^^^^^^^^^^^ queue不可为空!");
        }
    }

    @Override
    public void run() {
        int sleepTime = 1000; // 切割周期
        int sleepFree = 1000; // 无内容时的切割周期
        int sleepWork = 66;   // 有内容时的切割周期（经过测试该值建议在3~5ms,因为：图片接收&渲染64张耗时1~4ms[大部分都是1、2]）
        byte[] bit = null;
        byte[] byteArray = null;
        boolean ffmpegCorpModel = this.holder.getBmpContainer().isFfmpegCorpModel(); // true-底层C语言切割；false-android切割

        while (true) {
            try {
                if (!this.holder.cropSts) {
                    release();
                    break;
                }
                Thread.sleep(sleepTime);

                if (holder.getViewLst().size() > 0) {
                    sleepTime = sleepWork;
//                    long st = System.currentTimeMillis();
                    byteArray = holder.getBmpContainer().getByteArray();

                    if (null != byteArray) {
                        if (ffmpegCorpModel) {
                            imgProcessByte(byteArray);
                        } else {
                            Bitmap bitmap = BitmapFactory.decodeByteArray(byteArray,0, byteArray.length);
                            imgProcessBmp(bitmap);
                        }
//                        long et = System.currentTimeMillis();
//                        Log.i(TAG, "555切割&发送,不转码 耗时(ms)：" + (et-st) + ", rowNum:" + holder.getRowNum() + ", colNum:" + holder.getColNum() + ", sleepTime:" + sleepTime); // 切割&发送,不转码 耗时(ms)：100
                    } else {
//                        Log.e(TAG, "周期‘切割与播放/推送视频’未能获得帧图片!");
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
     * 将bmp添加到删除数组队列中.
     * @param bmp
     */
    private void appendToDel(Bitmap bmp) {
        int saveIndex = bmpArrayIterator++;
        if (saveIndex > (maxCacheNum - 1)) {
            saveIndex = 0;
        }

        Bitmap temp = bmpArray[saveIndex];

        if (null != temp && !temp.isRecycled()) {
            temp.recycle();
            temp = null;
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
    private CropView viewTemp = null;
    private int x = 0;
    private int y = 0;
    private int right;
    private int bottom;
    private int videoIndex = 0;
    private int rowNo = -1;
    private int colNo = -1;
    private int iterateI = 0;
    private List<ViewBean> viewBeanToDelLst = new ArrayList<ViewBean>();

    /**
     * 将原图进行切割并绘制到所对应的View上.
     * @param sourceBit 原图
     */
    private void imgProcessByte(byte[] sourceBit) {
        viewBeanToDelLst.clear();
        viewLst = holder.getViewLst();
        count = viewLst.size();
        if (0 == count) {
            return;
        }

        int smallImgSize = VUtil.bytesToint(sourceBit, 0x2, 4); // 小图-大小

        // 切割视频图片,并放到对应的View上
        iterateI = 0;
        for(; iterateI < count; iterateI++) {
            viewBeanTemp = viewLst.get(iterateI);
            viewTemp = viewBeanTemp.getView();

            // 侦测View是否被销毁
            if (null != viewTemp) {
                if (!viewTemp.isAttachedToWindow() && null == viewTemp.getDisplay() && viewTemp.isShown() == false) {
                    if (0 != viewTemp.getDetachedLastTime() && (System.currentTimeMillis()-viewTemp.getDetachedLastTime()) > viewDelayClearTime) {
                        viewTemp.setDestroy(true);
                        viewBeanToDelLst.add(viewBeanTemp);
                        continue;
                    }
                }
            } else {
                viewBeanToDelLst.add(viewBeanTemp);
                continue;
            }

            if (null != viewBeanTemp.getVideoIndex() && null != viewBeanTemp.getRowNo() && null != viewBeanTemp.getColNo()) {
                if (viewBeanTemp.getRowNo() > (holder.getRowNum()-1) || viewBeanTemp.getColNo() > (holder.getColNum()-1)) { // 处理越界情况
                    Log.e(TAG, "视图行列号越界.rowNo:" + viewBeanTemp.getRowNo() + "; colNo:" + viewBeanTemp.getColNo());
                    continue;
                }

                videoIndex = viewBeanTemp.getVideoIndex();
                Bitmap temp = BitmapFactory.decodeByteArray(sourceBit,smallImgSize*videoIndex, smallImgSize);

                if (0 == viewBeanTemp.getType()) {
                    viewBeanTemp.getView().showImage(temp, 0, 0, temp.getWidth(), temp.getHeight());
                } else {
                    viewBeanTemp.getView().showImage(temp, viewBeanTemp.getOffsetX(), viewBeanTemp.getOffsetY(), viewBeanTemp.getW(), viewBeanTemp.getH());
                }
//                appendToDel(temp); // 释放图片
            } else {
                Log.i(TAG, "小图尺寸 参数有为空的, count.iterateI:" + iterateI);
            }
        }

        holder.removeViewBean(viewBeanToDelLst);
    }

    /**
     * 将原图进行切割并推送到所对应的View上.
     * @param sourceBit 原图
     */
    private void imgProcessBmp(Bitmap sourceBit) {
        viewBeanToDelLst.clear();
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

        // 切割视频图片,并放到对应的View上
        iterateI = 0;
        for(; iterateI < count; iterateI++) {
            viewBeanTemp = viewLst.get(iterateI);
            viewTemp = viewBeanTemp.getView();

            // 侦测View是否被销毁
            if (null != viewTemp) {
                if (!viewTemp.isAttachedToWindow() && null == viewTemp.getDisplay() && viewTemp.isShown() == false) {
                    if (0 != viewTemp.getDetachedLastTime() && (System.currentTimeMillis()-viewTemp.getDetachedLastTime()) > viewDelayClearTime) {
                        viewTemp.setDestroy(true);
                        viewBeanToDelLst.add(viewBeanTemp);
                        continue;
                    }
                }
            } else {
                viewBeanToDelLst.add(viewBeanTemp);
                continue;
            }

            if (null != viewBeanTemp.getVideoIndex() && null != viewBeanTemp.getRowNo() && null != viewBeanTemp.getColNo()) {
                if (viewBeanTemp.getRowNo() > (holder.getRowNum()-1) || viewBeanTemp.getColNo() > (holder.getColNum()-1)) { // 处理越界情况
                    Log.e(TAG, "视图行列号越界22.rowNo:" + viewBeanTemp.getRowNo() + "; colNo:" + viewBeanTemp.getColNo());
                    continue;
                }

                videoIndex = viewBeanTemp.getVideoIndex();
                rowNo = viewBeanTemp.getRowNo().intValue();
                colNo = viewBeanTemp.getColNo().intValue();
                x = colNo * this.imgW;
                y = rowNo * this.imgH;
                right = x + this.imgW;
                bottom = y + this.imgH;

                if (0 == viewBeanTemp.getType()) {
//                    viewBeanTemp.getView().showImage(sourceBit, x, y, right, bottom);
                    viewBeanTemp.getView().showImage(sourceBit, x, y, this.imgW, this.imgH);
                } else {
//                    viewBeanTemp.getView().showImage(sourceBit, x+viewBeanTemp.getOffsetX(), y+viewBeanTemp.getOffsetY(), x+viewBeanTemp.getOffsetX()+viewBeanTemp.getW(), y+viewBeanTemp.getOffsetY()+viewBeanTemp.getH());
                    viewBeanTemp.getView().showImage(sourceBit, x+viewBeanTemp.getOffsetX(), y+viewBeanTemp.getOffsetY(), viewBeanTemp.getW(), viewBeanTemp.getH());
                }
//                appendToDel(sourceBit); // 释放图片
            } else {
                Log.i(TAG, "略过改View的切割：小图尺寸 参数有为空的, count.iterateI:" + iterateI);
            }
        }

        holder.removeViewBean(viewBeanToDelLst);
    }

}
