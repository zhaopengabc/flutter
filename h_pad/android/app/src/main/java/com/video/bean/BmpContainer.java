package com.video.bean;

import android.graphics.Bitmap;
import android.util.Log;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingDeque;
import video.VideoPlayer;

/**
 * 获得Bmp的容器.
 * 切割线程/CropPushVideoThread通过此容器/桥梁获得Bmp帧数据.
 */
public class BmpContainer {
    private static final String TAG = "BmpContainer";

    private boolean ffmpegCorpModel = false; // true-切割多份；false-不切割
    private byte[] byteArray = new byte[54*64+1920*1080*4]; // 接收C语言传递过来的数据容器
    private Bitmap bmp;
    private BlockingQueue<Bitmap> queue = new LinkedBlockingDeque<Bitmap>();
    private BlockingQueue<byte[]> queueByte = new LinkedBlockingDeque<byte[]>();
    private VideoPlayer player;


    public byte[] getByteArray() {
        boolean bln = player.TakeFrames(byteArray); // [1280*720]经测试从C语言获得数据耗时很短：0~3毫秒；回调方式需要30毫秒左右.

        if (bln) {
            return byteArray;
        } else {
//            Log.e(TAG, "&&&&&&&&&&&&&&&&&77 未能获得帧图片!");
            return null;
        }
    }

    public void setByteArray(byte[] byteArray) {
        this.byteArray = byteArray;
    }

    public Bitmap getBmp() {
        return bmp;
    }

    public void appendBmp(Bitmap bmp, byte[] bytes) {
        this.bmp = bmp;
        // 仅用于work6
        if (this.queue.size() < 25) {
            if (null != bmp) {
                this.queue.offer(bmp);
            } else {
                if (null != bytes) {
                    this.queueByte.offer(bytes);
                }
            }
        } else {
            Log.i(TAG, "主动丢帧以降低压力");
        }
    }

    public BlockingQueue<Bitmap> getQueue() {
        return queue;
    }

    public void setPlayer(VideoPlayer player) {
        this.player = player;
    }

    public boolean isFfmpegCorpModel() {
        return ffmpegCorpModel;
    }

    public void setFfmpegCorpModel(boolean ffmpegCorpModel) {
        this.ffmpegCorpModel = ffmpegCorpModel;
    }
}
