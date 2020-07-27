/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-07 17:06:22
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-07-09 15:10:39
 */ 
class RegExps {
  //分段数规则
  static const Subsection_Normal = "/^20\$|^(\d|[1-9]\d)\$/";

  //屏体数规则
  static const Screen_Normal = "/^100.0|100\$|^(\d|[1-9]\d)(\.\d+)*\$/";

  //环境数规则
  static const Ambient_Normal = "/^([1-9]\d*|[0]{1,1})\$/";

  // ip验证
  // static const ip_Normal = "/^((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)\$/";
  static const ip_Normal = r"^((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)$";

  static const abcRegex = r"^(2[0-1]\d|22[0-3]|[01]?\d\d?)$";
  static const ipRegex = r"^(2[0-4]\d|25[0-5]|[01]?\d\d?)$";
  //子网掩码验证
  static const mask_Normal = "/^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])(\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])){3}\$/";

  //验证密码 6- 20位  英文 不区分大小写
  // static RegExp pass_Normal = new RegExp("^[a-z_A-Z0-9-\.!@#\$%\\\^&\*\)\(\+\=\{\}\[\]\/\"\,\'<>~\·`\?:;|]{8,25}$");
  // static const pass_Normal = "^[a-z_A-Z0-9\-\.\!\@\#\$\%\\\^\&\*\(\)\+\=\{\}\[\]\/\,\'\<\>\~\·\`\?\:\;\|]{8,25}\$";
  static const pass_Normal = r"^[a-zA-Z0-9]{5,20}$";
  static const user_Normal = r"^[a-zA-Z0-9]{4,15}$";

  //验证ap名称
  static const ap_Normal = "/^[a-z_A-Z0-9-\.!@#\$%\\\^&\*\)\(\+=\{\}\[\]\/\",'<>~\·`\?:;|]{1,32}\$/";

  //邮件
  static const email_Normal = r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\\w+)*$";

  //验证GroupID
  static const groupId_Normal = r"^[a-zA-Z0-9]{1,10}$";

  //匹配非负整数（正整数 + 0）
  static const number_Normal = "/^-?[0-9]\d*\$/";
}
