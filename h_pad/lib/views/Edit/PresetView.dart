// 场景Layout
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:h_pad/api/index.dart';
import 'package:h_pad/common/component_index.dart';
import 'package:h_pad/models/input/InputModel.dart';
import 'package:h_pad/models/preset/PresetGroupListModel.dart';
import 'package:h_pad/states/edit/PresetProvider.dart';
import 'package:h_pad/style/colors.dart';
import 'package:h_pad/views/Edit/presetWidget/PresetGroupListView.dart';
import 'package:h_pad/views/Edit/presetWidget/PresetListView.dart';
// import 'package:h_pad/widgets/showLoadingDialog.dart';
import 'package:provider/provider.dart';

class PresetView extends StatefulWidget {
  PresetView({Key key}) : super(key: key);

  @override
  _PresetViewState createState() => _PresetViewState();
}

class _PresetViewState extends State<PresetView> with SingleTickerProviderStateMixin {
  // final List<dynamic> presets = List();
  int sid;
  TabController _tabController;
  int currentId = -1;
  bool needLoading = false;
  /*
   * @description: 并行获取场景、场景轮巡
   * @param { int }  id 屏幕id
   */
  void parallelData(id) {
    var data = {'deviceId': 0, 'screenId': id};
    try{
      if(EasyLoading.instance.key == null){
        EasyLoading.show(status: 'loading...');
        EasyLoading.instance..maskType = EasyLoadingMaskType.black;
      }
      // LoadingDialog loadingDialog = new LoadingDialog(context);
      HttpUtil http = HttpUtil(context).getInstance();
      Future.wait([http.request(Api.PRESET_LIST, data: data), http.request(Api.PRESET_GROUP_LIST, data: data)])
          .then((List responses) {
        getPresetList(responses[0]);
        getPresetGroupList(responses[1]);
      }).catchError((err) {
        EasyLoading.dismiss();
        // print('并行获取场景、场景轮询err===$err');
        // if (LoadingDialog.state) {
        //   loadingDialog.dispose();
        // }
      }).whenComplete(() {
        needLoading = false;
        EasyLoading.dismiss();
        // if (LoadingDialog.state) {
        //   loadingDialog.dispose();
        // }
      });
    }catch(e){
      EasyLoading.dismiss();
    }
  }

  /*
   * @description: 获取场景列表，PresetProvider赋值
   * @param { int }  id 屏幕id
   */
  void getPresetList(Result res) async {
    try {
      // var data = {'deviceId': 0, 'screenId': id};
      // HttpUtil http = HttpUtil(context).getInstance();
      // Result res = await http.request(Api.PRESET_LIST, data: data);
      if (res == null || res.code != 0){
        return;
      } 
      final presets = json.encode(res.data['presets']);
      List<dynamic> list = json.decode(presets);
      PresetList presetList = PresetList.fromJson(list);
      Provider.of<PresetProvider>(context, listen: false).presetList = presetList?.presetList;
      Provider.of<PresetProvider>(context, listen: false).currentPresetId = -1;
    } catch (e) {
      print(e);
    }
  }

  /*
   * @description: 获取场景轮巡列表，PresetGroupProvider赋值
   * @param { int }  id 屏幕id
   */
  void getPresetGroupList(Result res) async {
    try {
      // var data = {'deviceId': 0, 'screenId': id};
      // HttpUtil http = HttpUtil(context).getInstance();
      // Result res = await http.request(Api.PRESET_GROUP_LIST, data: data);
      if (res == null || res.code != 0){
        return;
      }
      final presetGroups = json.encode(res.data['presetGroups']);
      List<dynamic> list = json.decode(presetGroups);
      PresetGroupList presetGroupList = PresetGroupList.fromJson(list);
      Provider.of<PresetGroupProvider>(context, listen: false).presetGroupList = presetGroupList?.presetGroupList;
      Provider.of<PresetGroupProvider>(context, listen: false).currentPresetGroupId = -1;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.animation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EditProvider editProvider = Provider.of<EditProvider>(context);
    sid = editProvider.currentScreenId;
    // if (sid != -1) {
    //   getPresetList(sid);
    //   getPresetGroupList(sid);
    // }
    // print('获取场景的时候------${editProvider.currentScreen}-----${editProvider.screenList}---${editProvider.currentScreenId}');
    // currentId = -1;
    if (sid != -1 && editProvider.currentScreen !=null && (currentId != sid || editProvider.forceUpdatePreset == true)) {
      needLoading = true;
      Future.delayed(Duration(milliseconds: 200)).then((e) {
        needLoading = true;
        editProvider.forceUpdatePreset = false;
        currentId = sid;
        parallelData(sid);
      });
    }
    else{
       Future.delayed(Duration(milliseconds: 1000)).then((e) {
        //  print('查看easyLoading---${EasyLoading.instance.key}-----$needLoading');
         if(EasyLoading.instance?.key != null && !needLoading){
          EasyLoading.dismiss();
          needLoading = false;
        } 
      });
    }
    return Container(
        child: Column(children: <Widget>[
      Container(
        padding: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
        width: Utils.setWidth(156),
        decoration: BoxDecoration(
          color: ColorMap.input_background,
        ),
        child: Container(
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.all(Utils.setWidth(1)),
          height: Utils.setHeight(32),
          width: Utils.setWidth(140),
          decoration: BoxDecoration(
            color: ColorMap.preset_tabbar_background,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: _tabBarSwitcher(),
        ),
      ),
      Expanded(
          child: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Center(child: Consumer<PresetProvider>(builder: (BuildContext context, data, Widget child) {
            return PresetListView();
          })),
          Center(child: Consumer<PresetGroupProvider>(builder: (BuildContext context, data, Widget child) {
            return PresetGroupListView();
          })),
        ],
      ))
    ]));
  }

  Widget _tabBarSwitcher() {
    double tabHeight = Utils.setHeight(30);
    double tabWidth = Utils.setWidth(69);
    TextStyle tabStyle = TextStyle(fontSize: Utils.setFontSize(14),);
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        Positioned(
          height: tabHeight,
          width: tabWidth,
          // 每次tab移动的距离=当前移动到的位置*单个tab的宽
          left: _tabController.animation.value * tabWidth,
          child: Container(
            height: double.infinity,
            width: tabWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorMap.preset_tabbar_start,
                  ColorMap.preset_tabbar_end,
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
        ),
        TabBar(
          labelPadding: EdgeInsets.zero, // 必须
          controller: _tabController,
          isScrollable: false,
          // indicatorColor: Colors.transparent,
          indicator: UnderlineTabIndicator(borderSide: BorderSide(style: BorderStyle.none)),
          tabs: <Widget>[
            Tab(child: Text('场景', style: tabStyle)),
            Tab(child: Text('场景轮巡', style: tabStyle)),
          ],
        )
      ],
    );
  }
}
