typedef void DartEventCallback(arg);

class DartEventBus {
  DartEventBus._internal();
  static DartEventBus get instance => getInstance();
  factory DartEventBus() => getInstance();
  static DartEventBus _instance;

  static DartEventBus getInstance() {
    if (_instance == null) {
      _instance = new DartEventBus._internal();
    }
    return _instance;
  }

  /// Object是事件标识， 观察者可以有多个所以要用数组List保存
  var _eventMap = new Map<Object, List<DartEventCallback>>();

  ///注册观察者
  ///[name]是观察者标识，一般是字符串
  ///[callback]回调
  bool register(name, DartEventCallback callback) {
    if (name == null || callback == null) {
      return false;
    }

    ///三目操作符，如果为空则实例化列表，非空时无操作
    _eventMap[name] ??= new List<DartEventCallback>();
    if (_eventMap[name].contains(callback)) {
      print(name + " had already register");
    } else {
      _eventMap[name].add(callback);
    }
    return true;
  }

  ///移除多个观察者
  ///[name]是观察者标识，一般是字符串
  ///[callback] 回调数组，根据标识删除若干个回调
  bool unregister(name, [DartEventCallback callback]) {
    var list = _eventMap[name];
    if (name == null || list == null || list.length == 0) {
      return false;
    }

    if (callback == null) {
      _eventMap[name] = null;
    } else {
      ///批量移除
      list.remove(callback);
    }
    return true;
  }

  ///触发事件
  void postEvent(name, arg) {
    if (name == null) {
      return;
    }
    var list = _eventMap[name];
    if (list == null || list.length == 0) {
      return;
    }

    for (var i = list.length - 1; i >= 0; i--) {
      list[i](arg);
    }
  }
}
