/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-05-07 17:06:22
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-06-05 20:34:39
 */ 
class Result {
  int code; //返回的状态码，包含0和非0（http返回的错误码，还包括自定义的错误状态码、网络异常、代码异常、数组越界等自定义的状态码）
  String msg;
  final data;

  Result(this.code, this.msg, this.data);
}
