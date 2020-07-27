package com.video.util;

import android.content.Context;

public class VUtil {
    public static int dip2px(Context context, float dipValue) {
        float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dipValue * scale + 0.5f);
    }

    public static int px2dip(Context context, float pxValue) {
        float scale = context.getResources().getDisplayMetrics().density;
        return (int) (pxValue / scale + 0.5f);
    }

    public static int bytesToint(byte[] value,int offset,int length) {
        int ret = 0;
        for (int i = 0; i < length; i++) {
            ret += (value[offset+i] & 0xFF) << (i * 8);
        }
        return ret;
    }

}
