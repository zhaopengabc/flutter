import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:path_provider/path_provider.dart';

class Storage {
  //  // _getLocalFile函数，获取本地文件目录
  // static _getLoaclFile(String fileName) async{
  //   //获取应用目录// 获取本地文档目录
  //   //  String dir=(await getTemporaryDirectory()).path;  //获取临时文件夹
  //   String dir=(await getApplicationDocumentsDirectory()).path;
  //   String strDir = dir+"/"+"logs";
  //   var fileDir = Directory(strDir);
  //   File file;
  //   try {
  //     bool exists = await fileDir.exists();
  //     if (!exists) {
  //       await fileDir.create();
  //     }
  //     file =await createFile(strDir,fileName);
  //   } catch (e) {
  //     print(e);
  //   }
  //   return file;
  // }
  // static Future<File> createFile(String path, String fileName) async {
  //   final filePath = path+"/"+fileName;
  //   //或者file对象（操作文件记得导入import 'dart:io'）
  //   File file = File('$filePath');
  //   if(!await file.exists()){
  //     await file.create();
  //   }
  //   return file;
  // }
  static Future<File> writeCounter(content) async {
    var date = new DateTime.now().day;
    final file = await _getLoaclFile();
    return file.writeAsString('$content');
  }


  // _getLocalFile函数，获取本地文件目录
  static Future<File> _getLoaclFile() async{
    //获取应用目录// 获取本地文档目录
    String dir=(await getApplicationDocumentsDirectory()).path;
    return new File('$dir/counter.txt');
  }
}

