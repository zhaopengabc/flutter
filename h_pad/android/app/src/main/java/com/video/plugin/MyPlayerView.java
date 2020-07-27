package com.video.plugin;

import android.content.Context;
import android.view.TextureView;
import android.view.View;
import android.view.ViewGroup;
import android.widget.HorizontalScrollView;
import android.widget.ScrollView;
import android.widget.TextView;

import com.video.VideoSDK;

import java.util.Map;

//import io.flutter.Log;
import android.util.Log;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class MyPlayerView implements PlatformView, MethodChannel.MethodCallHandler {
    private static final String TAG = "MyPlayerView";
    private View faceViewContainer;
    private ScrollView scrollView;
    private TextureView faceView;
    private Context context;
    private VideoSDK sdk = VideoSDK.getInstance();

    public MyPlayerView(Context context, BinaryMessenger messenger, int id, Map<String, Object> params, View faceViewContainer, TextureView faceView) {
        this.context = context;
        this.faceViewContainer = faceViewContainer;
        this.faceView = faceView;

//        scrollView = new ScrollView(context);
//        HorizontalScrollView hsv = new HorizontalScrollView(context);
        this.faceView = new TextureView(context);
//        this.setViewWH(this.faceView, 1920, 1080);
//        scrollView.addView(hsv);
//        hsv.addView(faceView);

        System.out.println("**************** 注册主函数--开始.id:" + id);
        MethodChannel methodChannel = new MethodChannel(messenger, "plugins.video/playerView_" + id);
        methodChannel.setMethodCallHandler(this);
        System.out.println("**************** 注册主函数--结束");

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
            Log.e(TAG, "设置View尺寸-失败：view不可为空！");
        }
    }

    @Override
    public View getView() {
        return this.faceView;
    }

    @Override
    public void dispose() {
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        int code = 0;
//        Map<String, Object> args = (Map<String, Object>) call.arguments;

        if (null == sdk) {
            Log.i(TAG, "方法调用时sdk为空!");
            code = -1;
            result.success(code);
            return;
        }

        if ("startPlay".equals(call.method)) {
            String url = call.argument("url");
            if (null != url && !"".equals(url)) {
                if (null != faceView) {
                    sdk.startPlay(context, faceView, url, null);
                    Log.i(TAG, "视频打开-成功! url：" + url);
                } else {
                    Log.e(TAG, "视频打开-失败：faceView为空!");
                    code = 3;
                }
            } else {
                Log.e(TAG, "视频打开-失败：url为空!");
                code = 2;
            }
        } else if ("stopPlay".equals(call.method)) {
            sdk.stopPlay();
            Log.i(TAG, "视频关闭-成功!");
        } else if ("createCropTask".equals(call.method)) {
            if (null != faceView) {
                int videoW = call.argument("w");
                int videoH = call.argument("h");
                int rowNum = call.argument("row");
                int colNum = call.argument("column");

                sdk.createCropTask(null, faceView, videoW, videoH, rowNum, colNum);
                Log.i(TAG, "创建切割任务-成功!");
            } else {
                Log.e(TAG, "创建切割任务-失败：faceView为空!");
                code = 3;
            }
        } else if ("destroyCropTask".equals(call.method)) {
            sdk.destroyCropTask();
            Log.i(TAG, "销毁切割任务-成功!");
        } else {
            code = 1;
            Log.e(TAG, "接口调用-失败：接口名称不在定义范围之内!");
        }

        result.success(code);
    }
}
