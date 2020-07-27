/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-07 17:06:22
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-06-02 18:58:45
 */ 
class Api {
  // 基地址
  // static const String BASE_URL = 'http://192.168.10.111';
  // WebSocket 服务
  // static const String WS_URI = 'ws://192.168.10.111:8080';
  // 初始化
  static const String INIT_STATUS = '/api/main/initStatus';
  // 登录
  static const String LOGIN = '/api/user/login';

  // 屏幕列表
  static const String SCREEN_LIST = '/api/screen/readAllList';
  // 输入源列表
  static const String INPUT_LIST = '/api/input/readList';
  // 输出源列表
  static const String OUTPUT_LIST = '/api/output/readList';
  // 图层列表及详情
  static const String LAYER_LIST = '/api/layer/detailList';
  // 场景列表
  static const String PRESET_LIST = '/api/preset/readList';
  // 场景播放
  static const String PRESET_PLAY = '/api/preset/play';
  // 场景轮巡
  static const String PRESET_GROUP_LIST = '/api/preset/groupList';
  // 场景轮巡播放
  static const String PRESET_POLL = '/api/preset/presetPoll';
  // 读取场景轮巡播放
  static const String READ_PRESET_POLL = '/api/preset/readPresetPoll';

  // 读取屏幕当前播放场景
  static const String READ_PRESET_READPLAY = '/api/preset/readPlay';

  // 初始化
  static const String init_Status = '/api/main/initStatus';

  // 登录
  static const String login = '/api/user/login';

  // 批量删除图层
  static const String DELETE_LAYER_BATCH = '/api/layer/deleteBatch';

  // 批量创建图层
  static const String CREATE_LAYER_BATCH = '/api/layer/screenLayerTake';

  // 获取屏幕详情
  static const String GET_SCREEN_DETAIL = '/api/screen/readDetail';

  // 设置屏幕冻结
  static const String SET_SCREEN_FREEZE = '/api/screen/writeFreeze';

  // 调节屏幕亮度
  static const String SET_SCREEN_BRIGHTNESS = '/api/screen/writeBrightness';

  // 设置黑屏
  static const String SET_SCREEN_FTB = '/api/screen/ftb';

  // 用户登出
  static const String LOGOUT = '/api/user/logout';

  //开窗
  static const String CREATE_LAYER = '/api/layer/create';

  //设置指定图层的位置和大小信息
  static const String WRITE_LAYER_WINDOW = '/api/layer/writeWindow';

  //图层切源
  static const String WRITE_LAYER_SOURCE = '/api/layer/writeSource';

  //删除图层
  static const String DELETE_LAYER = '/api/layer/delete';

  //读取设备详情
  static const String READ_DEVICE_DETAIL = '/api/device/readDetail';

  static const String REFRESH_DEVICE = '/api/device/refresh';

  // 获取slot信息
  static const String GET_SLOT_INFO = '/api/device/readSlot';

  // TODO: 添加需要的接口

}
