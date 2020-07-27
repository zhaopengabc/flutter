package com.video.plugin;

import android.content.Context;
import android.view.TextureView;
import android.view.View;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class MyPlayerViewFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;
    private View faceViewContainer;
    private TextureView faceView;

    public MyPlayerViewFactory(BinaryMessenger messenger, View faceViewContainer, TextureView faceView) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
        this.faceViewContainer = faceViewContainer;
        this.faceView = faceView;
    }

    @SuppressWarnings("unchecked")
    @Override
    public PlatformView create(Context context, int id, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        return new MyPlayerView(context, messenger, id, params, faceViewContainer, faceView);
    }
}
