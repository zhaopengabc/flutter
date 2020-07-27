package com.video.plugin;

import android.util.Log;
import android.view.TextureView;
import android.view.View;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;
import io.flutter.plugin.common.PluginRegistry;

public class MyViewFlutterPlugin {
    private static final String TAG = "MyViewFlutterPlugin";
    private View faceViewContainer;
    private TextureView faceView;

    public MyViewFlutterPlugin(View faceViewContainer, TextureView faceView) {
        this.faceViewContainer = faceViewContainer;
        this.faceView = faceView;
    }

    public void registerWith(FlutterEngine flutterEngine) {
        final String key = MyViewFlutterPlugin.class.getCanonicalName();

        ShimPluginRegistry shimPluginRegistry = new ShimPluginRegistry(flutterEngine);
        if (shimPluginRegistry.hasPlugin(key)) return;

        PluginRegistry.Registrar registrar = shimPluginRegistry.registrarFor(key);

        Log.i(TAG, "**************** 注册原生View--开始");
        registrar.platformViewRegistry().registerViewFactory("plugins.video/playerView", new MyPlayerViewFactory(registrar.messenger(), faceViewContainer, faceView));
        registrar.platformViewRegistry().registerViewFactory("plugins.video/cutView", new MyViewFactory(registrar.messenger()));
        Log.i(TAG, "**************** 注册原生View--结束");
    }

}