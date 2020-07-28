class PhysicalAndLogicalConverter {
  /// @description: 物理宽转逻辑宽
  ///* [phyValue]: 要转化的值
  ///* [phyScreenWidth]: 物理屏幕宽
  ///* [logScreenWidth]: 逻辑屏幕宽
  ///* @return: 逻辑宽

  static physicalToLogicalWidth(
      double phyValue, double phyScreenWidth, double logScreenWidth) {
    return phyScreenWidth == 0
        ? phyValue
        : phyValue * logScreenWidth / phyScreenWidth;
  }

  /// @description: 物理高度转逻辑高度
  ///* [phyValue]: 要转化的值
  ///* [phyScreenWidth]: 物理屏幕高
  ///* [logScreenWidth]: 逻辑屏幕高
  ///* @return: 逻辑高
  static physicalToLogicalHeight(
      double phyValue, double phyScreenHeight, double logScreenHeight) {
    return phyScreenHeight == 0
        ? phyValue
        : phyValue * logScreenHeight / phyScreenHeight;
  }

  /// @description: 逻辑宽转物理宽
  ///* [phyValue]: 要转化的值
  ///* [phyScreenWidth]: 物理屏幕宽
  ///* [logScreenWidth]: 逻辑屏幕宽
  ///* @return: 物理宽度
  static logicalToPhysicalWidth(
      double logValue, double phyScreenWidth, double logScreenWidth) {
    return logScreenWidth == 0
        ? logValue
        : logValue * phyScreenWidth / logScreenWidth;
  }

  /// @description: 逻辑高度转物理高度
  ///* [phyValue]: 要转化的值
  ///* [phyScreenWidth]: 物理屏幕宽
  ///* [logScreenWidth]: 逻辑屏幕宽
  ///* @return: 物理高度
  static logicalToPhysicalHeight(
      double logValue, double phyScreenHeight, double logScreenHeight) {
    return logScreenHeight == 0
        ? logValue
        : logValue * phyScreenHeight / logScreenHeight;
  }
}
