package com.video.bean;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.os.Build;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.ImageView;

import androidx.annotation.RequiresApi;

import java.text.DecimalFormat;


/**
 * 显示切割视频的视图.
 */
@SuppressLint("AppCompatCustomView")
public class CropView extends ImageView {
    private static final String TAG = "CropView";
    private boolean destroy = false; // 是否被销毁[true-是]
    private Bitmap bmp;
    private Rect src;
    private Rect dst;
    private int wView;
    private int hView;
    private long detachedLastTime = 0;
    private DecimalFormat df = new DecimalFormat("0.00"); //设置保留位数

    public CropView(Context context) {
        super(context);
        setScaleType(ScaleType.FIT_CENTER);
    }

    public CropView(Context context, AttributeSet attrs) {
        super(context, attrs);
        setScaleType(ScaleType.FIT_CENTER);
    }

    public CropView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        setScaleType(ScaleType.FIT_CENTER);
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public CropView(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        setScaleType(ScaleType.FIT_CENTER);
    }

    public void showImage(Bitmap bit) {
        this.bmp = bit;
        this.setImageBitmap(bit);
        // view.invalidate(); 注释掉竟然也可以正常显示视频内容
    }

    public void showImage(Bitmap bit, int x, int y, int width, int height) {
        this.bmp = bit;

        if (null != this.bmp && !this.bmp.isRecycled()) {
            wView = getWidth();
            hView = getHeight();

            src = new Rect(x, y, x + width, y + height);
            dst = new Rect(0, 0, wView, hView);

            postInvalidate();
        } else {
            Log.i(TAG, "bmp为空不进行渲染！");
        }
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);

        if (!destroy && null != this.bmp && null != src && null != dst && !this.bmp.isRecycled()) {
            canvas.drawBitmap(this.bmp, src, dst, null);
        }
//        Log.i(TAG, "1个视图 onDraw 耗时(ms)：" + (et-st));  // 耗时：0~1ms
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        detachedLastTime = System.currentTimeMillis();
//        Log.i(TAG, "&&&&&&&&&&&&&&&&&&&&&&&&&& onDetachedFromWindow()");
    }

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
//        Log.i(TAG, "&&&&&&&&&&&&&&&&&&&&&&&&&& onAttachedToWindow()");
    }

    public boolean isDestroy() {
        return destroy;
    }

    public void setDestroy(boolean destroy) {
        this.destroy = destroy;
    }

    public long getDetachedLastTime() {
        return detachedLastTime;
    }
}

//@SuppressLint("AppCompatCustomView")
//public class CropView extends ImageView {
//    private static final String TAG = "CropView";
//    private boolean destroy = false; // 是否被销毁[true-是]
//
//    public CropView(Context context) {
//        super(context);
//    }
//
//    public CropView(Context context, AttributeSet attrs) {
//        super(context, attrs);
//    }
//
//    public CropView(Context context, AttributeSet attrs, int defStyleAttr) {
//        super(context, attrs, defStyleAttr);
//    }
//
//    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
//    public CropView(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
//        super(context, attrs, defStyleAttr, defStyleRes);
//    }
//
//    public void showImage(Bitmap bit) {
//        this.setImageBitmap(bit);
//        // view.invalidate(); 注释掉竟然也可以正常显示视频内容
//    }
//
//    @Override
//    protected void onDetachedFromWindow() {
//        super.onDetachedFromWindow();
//        destroy = true;
//        Log.i(TAG, "&&&&&&&&&&&&&&&&&&&&&&&&&& onDetachedFromWindow()");
//    }
//
//    public boolean isDestroy() {
//        return destroy;
//    }
//}
