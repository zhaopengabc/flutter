package com.video.plugin;

import android.content.Context;
import android.util.Log;
import android.view.View;

import com.video.bean.CropView;
import com.video.VideoSDK;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class MyView implements PlatformView { // , MethodChannel.MethodCallHandler
    private static final String TAG = "MyView";
    private final CropView cropView;
    private Context context;
    private VideoSDK sdk;

    public MyView(Context context, BinaryMessenger messenger, int id, Map<String, Object> params) {
        this.context = context;

        Integer inputId = (Integer) params.get("inputId");
        Integer groupId = (Integer) params.get("groupId");
        Integer layerId = (Integer) params.get("layerId");
        Integer type = (Integer) params.get("type"); // type:视频类型(0-源;1-截取源/子源)
        Integer offsetX = (Integer) params.get("offsetX");
        Integer offsetY = (Integer) params.get("offsetY");
        Integer w = (Integer) params.get("w");
        Integer h = (Integer) params.get("h");

        if (null == inputId) {
            Log.i(TAG, "inputId不可为空!");
        }
        if (null == groupId) {
            Log.i(TAG, "groupId不可为空!");
        }
        if (null == layerId) {
            Log.i(TAG, "layerId不可为空!");
        }
        if (null == type) {
            Log.i(TAG, "type不可为空!采用默认值：0");
            type = 0;
        }

        this.sdk = VideoSDK.getInstance();
        this.cropView = new CropView(context);
        sdk.addView(cropView, inputId, id, groupId, layerId, type, offsetX, offsetY, w, h);
        Log.i(TAG, ">>>>>> 创建新的View. groupId:" + groupId + ", layerId:" + layerId + ", inputId:" + inputId + ",添加1个视图后，当前图层数量：" + sdk.getViewNum());

//        MethodChannel methodChannel = new MethodChannel(messenger, "plugins.video/cutView_" + id);
//        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public View getView() {
        return this.cropView;
    }

    @Override
    public void dispose() {
    }

//    @Override
//    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
////        if ("setText".equals(call.method)) {
////            String text = (String) call.arguments;
////            this.view.setText("原生组件显示Flutter传过来的内容：" + text);
////        }
//
//        Log.i(TAG, "CutView上的接口还未定义、实现!");
//        result.success(null);
//    }
}