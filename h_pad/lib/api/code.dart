/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-07 17:06:22
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-06-05 20:57:07
 */ 
///业务特殊编码
class Code {
  /// TOKEN用户权限问题 105～109 重定向到登陆页面
  static const TOKEN_EXPIRED_START = 105;
  /// TOKEN用户权限问题 105～109 重定向到登陆页面
  static const TOKEN_EXPIRED_END = 109;
  /// 设备正在初始化 跳转初始化页面
  static const LOADING_CODE = 912;
  /// 设备正在升级 跳转升级页面
  static const UPGRADE_CODE = 913;
  /// 设备正在自检 跳转设备自检页面
  static const SELFCHECK_CODE = 914;
  /// 网络未连接
  static const NETWORK_UNREACHABLE = 50000;
  /// 设备不在网络中
  static const NETWORK_NO_HOST = 50001;
  /// 网络通信超时
  static const NETWORK_TIMEOUT = 50002;
  /// 单纯的不想提示，入登出系统是调用logout接口
  static const NONEEDRETURN_CODE = 60000;
  /// 其他错误
  static const OTHER_CODE = 10500;
}
