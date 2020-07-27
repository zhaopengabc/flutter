import 'package:h_pad/models/input/InputModel.dart';

class InputListInfoModel {
  List<InputModel> inputList = new List();
  InputListInfoModel({this.inputList});

  factory InputListInfoModel.fromJson(List<dynamic> listJson) {
    List<InputModel> screenList =  
        listJson.map((value) => new InputModel.fromJson(value)).toList();  
    return InputListInfoModel(inputList: screenList);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.inputList != null) {
      data['inputList'] = this.inputList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}