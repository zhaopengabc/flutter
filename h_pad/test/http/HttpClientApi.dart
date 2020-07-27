class Api {
  // 初始化
  static const String INIT_STATUS = '/api/main/initStatus';
  // 登录
  static const String LOGIN = '/api/user/login';
  // 屏幕列表
  static const String SCREEN_LIST = '/api/screen/readAllList';
  // 输入源列表
  static const String INPUT_LIST = '/api/input/readList';
  // 图层列表及详情
  static const String LAYER_LIST = '/api/layer/detailList';
  // 场景列表
  static const String PRESET_LIST = '/api/preset/readList';
  // 场景轮询
  static const String PRESET_GROUP_LIST = '/api/preset/groupList';
  // 批量删除图层
  static const String DELETE_LAYER_BATCH = '/api/layer/deleteBatch';

  // 批量创建图层
  static const String CREATE_LAYER_BATCH = '/api/layer/screenLayerTake';

  // 获取屏幕详情
  static const String GET_SCREEN_DETAIL = '/api/screen/readDetail';

  // TODO: 添加需要的接口

}
