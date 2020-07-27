/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-07-01 19:04:33
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-07-06 11:46:09
 */
import 'package:h_pad/common/component_index.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileHelper {
  static Future<File> _getLocalFile() async {
    try {
      // 获取应用目录
      String dir = (await getApplicationDocumentsDirectory()).path;
      File timeFile = File('$dir/timeFile.txt');
      var isExist = await timeFile.exists();
      if (isExist) return timeFile;
      return new File('$dir/timeFile.txt');
    } catch (e) {
      print('读取应用目录错误！');
    }
  }

  static Future<String> readTime() async {
    try {
      File file = await _getLocalFile();
      // 读取点击次数（以字符串）
      String contents = await file.readAsString();
      return contents;
    } on FileSystemException {
      return '';
    }
  }

  //保存已试用时间 0：已授权；-1：已过试用期但未授权;
  //文件中保存的时间单位为秒
  static Future setLocalFile(String strTime) async {
    try {
      // 获取应用目录
      File file = await _getLocalFile();
      file.writeAsString('$strTime');
    } catch (e) {
      print('写文件错误！');
    }
  }
}

// class StorageHelper{

//   /// 利用SharedPreferences存储数据
//   static Future saveString(String key,String strValue) async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     sharedPreferences.setString(
//         key, strValue);
//   }
  
//   /// 获取存在SharedPreferences中的数据
//   static Future getString(String key) async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     return sharedPreferences.get(key);
//   }
// }
