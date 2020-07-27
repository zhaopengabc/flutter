package com.example.hpad;

import android.Manifest;
import android.content.pm.PackageManager;
import android.util.Log;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.video.PlayerSDK;
import com.video.plugin.MyViewFlutterPlugin;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String TAG = "MainActivity";

  public void configureFlutterEngine(FlutterEngine flutterEngine) {
    Log.i(TAG, "*********************** MainActivity.configureFlutterEngine");

    if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
        ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 100);
    }

    GeneratedPluginRegistrant.registerWith(flutterEngine);

    PlayerSDK playerSDK = new PlayerSDK(flutterEngine);

    MyViewFlutterPlugin plugin = new MyViewFlutterPlugin(null, null);
    plugin.registerWith(flutterEngine);
  }

//  @Override
//  protected void onCreate(Bundle savedInstanceState) {
//    super.onCreate(savedInstanceState);
//    Log.i(TAG, "*********************** MainActivity.onCreate");
//
//    PlayerSDK playerSDK = new PlayerSDK(this);
//
//    MyViewFlutterPlugin plugin = new MyViewFlutterPlugin(null, null);
//    plugin.registerWith(this);
//  }
}