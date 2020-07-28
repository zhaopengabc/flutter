import 'package:h_pad/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';

// 申请权限
Future requestPermission() async {
  bool roots = true;
  Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler()
      .requestPermissions([PermissionGroup.storage, PermissionGroup.location, PermissionGroup.camera]);
  // 申请结果
//  bool isOpened = await PermissionHandler().openAppSettings(); 打开设置页面

  if (permissions[PermissionGroup.camera] != PermissionStatus.granted) {
    print("无照相权限");
    roots = false;
  }
  if (permissions[PermissionGroup.location] != PermissionStatus.granted) {
    print("无定位权限");
    roots = false;
  }
  if (permissions[PermissionGroup.storage] != PermissionStatus.granted) {
    print("无存储权限");
    roots = false;
    Utils.pop();
  }
  return roots;
}
