package com.video;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;

import com.video.bean.BmpContainer;

import java.util.Timer;
import java.util.TimerTask;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import video.VideoPlayer;

/**
 * 对接张旭冉ffmpeg方式的SDK.
 */
public class PlayerSDK implements VideoPlayer.ICallBack, MethodChannel.MethodCallHandler {
    private static final String TAG = "PlayerSDK";

    private VideoPlayer player;
    private BmpContainer bmpContainer = new BmpContainer();
    private VideoSDK sdk = VideoSDK.getInstance();

    private Timer timerReCon = null; // 重连机制-Timer
    private boolean opened = false; // true-已经开启;false-未开启
    private boolean conSts = false; // true-链接OK;false-链接中断
    private boolean conIng = false; // true-创建链接工作进行中;false-创建链接工作结束

    private String url;
    private int videoW;
    private int videoH;
    private int rowNum;
    private int colNum;
    private int displayVideo; // 是否显示视频(0-不显示；1-显示)

    public PlayerSDK(FlutterEngine flutterEngine) {
        player = VideoPlayer.CreateVideoPlayer();
        player.SetEventCallBack(this);
        bmpContainer.setPlayer(player);

        final String key = PlayerSDK.class.getCanonicalName();

        ShimPluginRegistry shimPluginRegistry = new ShimPluginRegistry(flutterEngine);
        if (shimPluginRegistry.hasPlugin(key)) return;

        PluginRegistry.Registrar registrar = shimPluginRegistry.registrarFor(key);
        MethodChannel methodChannel = new MethodChannel(registrar.messenger(), "plugins.video/playerSDK");
        methodChannel.setMethodCallHandler(this);
        Log.i(TAG, "plugins.video/playerSDK 主接口注册-成功!");
    }

    /**
     * 初始化.
     */
    public int init() {
        player.Init();
        startReConTimer();
        return 0;
    }

    /**
     * 开启切割任务.
     * @param call
     * @return
     */
    private int startTask(MethodCall call) {
        int code = 0;
        url = call.argument("url");
        videoW = call.argument("w");
        videoH = call.argument("h");
        rowNum = call.argument("row");
        colNum = call.argument("column");
        displayVideo = call.argument("displayVideo");

        if (null != url && !"".equals(url)) {
            startTask(url, videoW, videoH, rowNum, colNum, displayVideo);
        } else {
            Log.e(TAG, "视频打开-失败：url为空!");
            code = 1;
        }

        return code;
    }

    private void startTask(String url, int videoW, int videoH, int rowNum, int colNum, int displayVideo) {
        conIng = true;
        opened = true;

        player.SetOutSize(videoW, videoH);
        player.SetUrl(url);

        if (bmpContainer.isFfmpegCorpModel()) {
            player.SetRowCol(rowNum, colNum);
        } else {
            player.SetRowCol(1, 1);
        }

//        sdk.createCropTask(bmpContainer, null, videoW, videoH, rowNum, colNum);

        if (1 == displayVideo) {
            int rs = player.Play();

            if (rs == 0) {
                this.conSts = true;
                Log.i(TAG, "开启切割任务-成功! url:" + url + ", videoW:" + videoW + ", videoH:" + videoH + ", rowNum:" + rowNum + ", colNum:" + colNum + ", ffmpegCropModel:" + bmpContainer.isFfmpegCorpModel());
            } else {
                Log.i(TAG, "开启切割任务-失败! url:" + url + ", videoW:" + videoW + ", videoH:" + videoH + ", rowNum:" + rowNum + ", colNum:" + colNum + ", ffmpegCropModel:" + bmpContainer.isFfmpegCorpModel());
            }
        } else {
            Log.i(TAG, "开启切割任务-不显示视频! url:" + url + ", videoW:" + videoW + ", videoH:" + videoH + ", rowNum:" + rowNum + ", colNum:" + colNum + ", ffmpegCropModel:" + bmpContainer.isFfmpegCorpModel());
        }

        conIng = false;
    }

    /**
     * 开启重连机制.
     */
    private synchronized void startReConTimer() {
        this.stopReConTimer();

        if (null == timerReCon) {
            this.timerReCon = new Timer();
            timerReCon.schedule(new TimerTask() {
                public void run() {
                    try {
                        if (opened && !conSts && !conIng) {
                            Log.i(TAG, "**************************************进入重连*******************");
                            stopTask(false);
                            startTask(url, videoW, videoH, rowNum, colNum, 1);
                        }
                    } catch (Exception e) {
                        Log.e(TAG, "重连时-出现异常:{}", e);
                    }
                }
            }, 5000, 10000);
        }
    }

    /**
     * 停止切割任务.
     * @param model 关闭模式[true-人工关闭、false-程序关闭]
     * @return
     */
    public int stopTask(boolean model) {
        Log.i(TAG, "*************** 停止切割任务！");
        player.Stop();
        this.conSts = false;

        if (model) {
            this.opened = false;
        }

        return 0;
    }

    /**
     * 停止重连机制.
     */
    private void stopReConTimer() {
        if (null != this.timerReCon) {
            this.timerReCon.cancel();
            this.timerReCon = null;
        }
    }

    /**
     * 根据'视图标识'释放View.
     * @param call
     * @return 错误码
     */
    private int removeView(MethodCall call) {
        int code = 0;
        Integer viewId = call.argument("viewId");

        if (null != viewId) {
            sdk.removeViewByViewId(viewId);
        } else {
            code = 1;
            Log.e(TAG, "View释放-失败：viewId为空！");
        }

        return code;
    }

    /**
     * 根据'视图组标识'释放View.
     * @param call
     * @return 错误码
     */
    private int removeViewByGroupId(MethodCall call) {
        int code = 0;
        Integer groupId = call.argument("groupId");

        if (null != groupId) {
            sdk.removeViewByGroupId(groupId);
        } else {
            code = 1;
            Log.e(TAG, "根据组ID释放View-失败：groupId为空！");
        }

        return code;
    }

    /**
     * 切源.
     * @param call
     * @return 错误码
     */
    private int changeVideoIndexByViewId(MethodCall call) {
        int code = 0;
        Integer viewId = call.argument("viewId");
        Integer videoIndex = call.argument("videoIndex"); // 可以为空
        Integer type = call.argument("type"); // type:视频类型(0-源;1-截取源/子源)
        Integer offsetX = call.argument("offsetX");
        Integer offsetY = call.argument("offsetY");
        Integer w = call.argument("w");
        Integer h = call.argument("h");

        if (null != viewId) {
            sdk.changeViewVideoIndexByViewId(viewId, videoIndex, type, offsetX, offsetY, w, h);
        } else {
            code = 1;
            Log.e(TAG, "切源-失败：viewId为空！");
        }

        return code;
    }

    /**
     * 切源.
     * @param call
     * @return 错误码
     */
    private int changeVideoIndexByLayerId(MethodCall call) {
        int code = 0;
        Integer groupId = call.argument("groupId");
        Integer layerId = call.argument("layerId");
        Integer videoIndex = call.argument("videoIndex"); // 可以为空
        Integer type = call.argument("type"); // type:视频类型(0-源;1-截取源/子源)
        Integer offsetX = call.argument("offsetX");
        Integer offsetY = call.argument("offsetY");
        Integer w = call.argument("w");
        Integer h = call.argument("h");

        if (null != groupId && null != layerId) {
            sdk.changeVideoIndexByLayerId(groupId, layerId, videoIndex, type, offsetX, offsetY, w, h);
        } else {
            code = 1;
            Log.e(TAG, "切源-失败：groupId & layerId为空！");
        }

        return code;
    }

    private byte[] getImageFrame(MethodCall call) {
        return bmpContainer.getByteArray();
    }

    public void OnEvent(VideoPlayer player, VideoPlayer.VideoEvent ev, final Object obj) {
        if (ev == VideoPlayer.VideoEvent.VideoEvenRecvData) {
            Log.i(TAG, "eeeeeeeeeeeeeeee VideoPlayer.VideoEvent.VideoEvenRecvData");
//            if (null != obj) {
//                byte[] byteArray = (byte[])obj;
//
//                if (null != byteArray && byteArray.length > 0) {
//                    Log.i(TAG, "回调中收到帧");
//                    Bitmap bmp = BitmapFactory.decodeByteArray(byteArray,0, byteArray.length);
//                    bmpContainer.appendBmp(bmp, null);
//                    Log.i(TAG, "接收到帧数据. buffer.length = " + byteArray.length);
//                } else {
//                    Log.i(TAG, "接收到帧数据长度为：0！");
//                }
//            } else {
//                Log.i(TAG, "接收到帧数据为空！");
//            }

//            ImageView imageView = (ImageView) v.findViewById(R.id.imageView);
//            handler.post(new ImpRunnable(imageView,bmp));
        } else if (ev == VideoPlayer.VideoEvent.VideoEvenConnectSuccess) {
            this.conSts = true;
            Log.i(TAG, "eeeeeeeeeeeeeeee VideoEvenConnectSuccess链接成功" + ev.name());
        } else if (ev == VideoPlayer.VideoEvent.VideoEvenConnectFailure) {
            this.conSts = false;
            Log.i(TAG, "eeeeeeeeeeeeeeee VideoEvenConnectFailure链接失败" + ev.name());
        } else if (ev == VideoPlayer.VideoEvent.VideoEvenLoopEnd) {
            this.conSts = false;
            Log.i(TAG, "eeeeeeeeeeeeeeee VideoEvenLoopEnd切割任务结束" + ev.name());
        }
    }

    /**
     * Flutter调用接口.
     * @param call
     * @param result [0-成功、1-输入参数错误]
     */
    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        int code = 0;

        if ("init".equals(call.method)) {
            code = init();
        } else if ("startTask".equals(call.method)) {
            code = startTask(call);
        } else if ("stopTask".equals(call.method)) {
            code = stopTask(true);
        } else if ("removeView".equals(call.method)) {
//            code = removeView(call);
        } else if ("removeViewByGroupId".equals(call.method)) {
//            code = removeViewByGroupId(call);
        } else if ("changeVideoIndexByViewId".equals(call.method)) {
            code = changeVideoIndexByViewId(call);
        } else if ("changeVideoIndexByLayerId".equals(call.method)) {
            code = changeVideoIndexByLayerId(call);
        }

        if ("getImageFrame".equals(call.method)) {
            byte[] buffer = getImageFrame(call);
            if (null != buffer) {
                result.success(buffer);
            } else {
                result.success(null);
            }
        } else {
            result.success(code);
        }
    }

}
