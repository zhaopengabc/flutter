package com.video.bean;

import android.graphics.Bitmap;

public class ImgMessage {
    public int rowNo;
    public int colNo;
    public int videoIndex;
    public Bitmap img;

    public ImgMessage(int rowNo, int colNo, int videoIndex, Bitmap img) {
        this.rowNo = rowNo;
        this.colNo = colNo;
        this.videoIndex = videoIndex;
        this.img = img;
    }
}
