<!--
 * @Description: 一些插件的使用方法示例
 * @Author: ZuoSuqian
 * @Date: 2020-03-16 18:49:30
 * @LastEditors: ZuoSuqian
 * @LastEditTime: 2020-03-16 18:53:13
 -->

<!--EasyLoading 插件的使用方法 -->

<!-- loading打开 -->
EasyLoading.show(status: 'loading...');  <!-- status为loading展示内容 -->
EasyLoading.instance ..maskType =  EasyLoadingMaskType.black; <!-- 设置遮罩颜色 -->

<!-- loading关闭 -->
EasyLoading.dismiss();
