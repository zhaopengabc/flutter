
// 视频初始化参数
class VideoParam {
  String url;       // RTSP地址
  bool cut;         // 切割模式 true/false
  bool origin;      // 显示模式
  int cutRow;       // 切割行数
  int cutColumn;    // 切割列数
  int width;        // 视频分辨率-宽度
  int height;       // 视频分辨率-高度
  int displayVideo; // 是否显示视频[1-是;0-否]

  static const int w = 1920;   // 视频分辨率-宽度
  static const int h = 1080;   // 视频分辨率-宽度
  static const int row = 8; // 切割行数
  static const int col = 8; // 切割列数

//  VideoParam(this.url, this.cut, this.origin, this.cutRow, this.cutColumn, this.width, this.height, this.displayVideo);
  VideoParam(this.url, {this.cut=true, this.origin=true, this.cutRow=row, this.cutColumn=col, this.width=w, this.height=h, this.displayVideo=1});
}