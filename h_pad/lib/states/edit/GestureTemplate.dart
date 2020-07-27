import 'package:flutter/material.dart';

class GestureTemplateProvider with ChangeNotifier {
  //手势框offsetTop
  double _templateTop = 0;
  double get templateTop => _templateTop;
  set templateTop(double value) {
    _templateTop = value;
    notifyListeners();
  }
  //手势框offSetLeft
  double _templateLeft = 0;
  double get templateLeft => _templateLeft;
  set templateLeft(double value) {
    _templateLeft = value;
    notifyListeners();
  }
  //手势框宽
  double _templateWidth = 0;
  double get templateWidth => _templateWidth;
  set templateWidth(double value) {
    _templateWidth = value;
    notifyListeners();
  }
  //手势框高
  double _templateHeight = 0;
  double get templateHeight => _templateHeight;
  set templateHeight(double value) {
    _templateHeight = value;
    notifyListeners();
  }

  //手势框是否显示
  bool _isTemplateVisible = true;
  bool get isTemplateVisible => _isTemplateVisible;
  set isTemplateVisible(bool value) {
    _isTemplateVisible = value;
    notifyListeners();
  }
}
