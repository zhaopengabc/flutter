package com.video.bean;

import java.io.Serializable;

public class ViewBean implements Serializable {
    private CropView view;

    // addView时会根据videoIndex计算出rowNo、colNo
    private Integer videoIndex; // 每个截取部分的索引号(按照从上到下、从左到右，从0依次递增)
    private Integer viewId;     // 视图标识
    private Integer groupId;    // 视图组标识
    private Integer layerId;   // 图层ID
    private Integer rowNo;      // [行号]每个截取部分的索引号(按照从上到下、从左到右，从0依次递增)
    private Integer colNo;      // [列号]每个截取部分的索引号(按照从上到下、从左到右，从0依次递增)
    private Integer type;      // type:视频类型(0-源;1-截取源/子源)
    private Integer offsetX;   // 截取源-偏移坐标X
    private Integer offsetY;   // 截取源-偏移坐标Y
    private Integer w;         // 截取源-宽
    private Integer h;         // 截取源-高


    public ViewBean() {}

    public ViewBean(CropView view) {
        this(view, null, null, null, null,null,null,null,null,null,null,null);
    }

    public ViewBean(CropView view, int videoIndex) {
        this(view, videoIndex, null, null, null, null,null,null,null,null,null,null);
    }

    public ViewBean(CropView view, int rowNo, int colNo) {
        this(view, null, null, null,null, rowNo, colNo,null,null,null,null,null);
    }

    public ViewBean(CropView view, Integer videoIndex, Integer viewId, Integer groupId, Integer layerId, Integer rowNo, Integer colNo, Integer type, Integer offsetX, Integer offsetY, Integer w, Integer h) {
        this.view = view;
        this.videoIndex = videoIndex;
        this.viewId = viewId;
        this.groupId = groupId;
        this.layerId = layerId;
        this.rowNo = rowNo;
        this.colNo = colNo;
        this.type = type; // type:视频类型(0-源;1-截取源/子源)
        this.offsetX = offsetX;
        this.offsetY = offsetY;
        this.w = w;
        this.h = h;
    }

    public CropView getView() {
        return view;
    }

    public void setView(CropView view) {
        this.view = view;
    }

    public Integer getVideoIndex() {
        return videoIndex;
    }

    public void setVideoIndex(Integer videoIndex) {
        this.videoIndex = videoIndex;
    }

    public Integer getViewId() {
        return viewId;
    }

    public void setViewId(Integer viewId) {
        this.viewId = viewId;
    }

    public Integer getGroupId() {
        return groupId;
    }

    public void setGroupId(Integer groupId) {
        this.groupId = groupId;
    }

    public Integer getRowNo() {
        return rowNo;
    }

    public void setRowNo(Integer rowNo) {
        this.rowNo = rowNo;
    }

    public Integer getColNo() {
        return colNo;
    }

    public void setColNo(Integer colNo) {
        this.colNo = colNo;
    }

    public Integer getLayerId() {
        return layerId;
    }

    public void setLayerId(Integer layerId) {
        this.layerId = layerId;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public Integer getOffsetX() {
        return offsetX;
    }

    public void setOffsetX(Integer offsetX) {
        this.offsetX = offsetX;
    }

    public Integer getOffsetY() {
        return offsetY;
    }

    public void setOffsetY(Integer offsetY) {
        this.offsetY = offsetY;
    }

    public Integer getW() {
        return w;
    }

    public void setW(Integer w) {
        this.w = w;
    }

    public Integer getH() {
        return h;
    }

    public void setH(Integer h) {
        this.h = h;
    }
}
