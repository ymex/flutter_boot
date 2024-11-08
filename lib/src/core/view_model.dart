import 'package:flutter/foundation.dart';
import 'package:flutter_boot/core.dart';
import 'package:flutter_boot/http.dart';
import 'package:flutter_boot/widget.dart';

/// ViewModel

class ViewModel with LiveDataScope {
  Function(VoidCallback)? _stateCall;
  Function(String message, {int? what, Object? data})? _notifyCall;

  /// 创建时传入
  /// 用于区分由谁实例化了ViewModel。
  final Object? key;

  ViewModel({this.key});

  void setInvokingFun({
    Function(VoidCallback)? stateCall,
    Function(String message, {int? what, Object? data})? notifyCall,
  }) {
    _stateCall = stateCall;
    _notifyCall = notifyCall;
  }

  /// 通知所持有ViewModel的State组件更新。
  /// notify 参数表示可关闭通知更新，只执行fn。
  void setScopeState(VoidCallback fn, {bool notify = true}) {
    if (!notify) {
      fn();
      return;
    }
    if (_stateCall != null) _stateCall!(fn);
  }

  /// 通知订阅LiveData的组件更新。
  /// notify 参数表示可关闭通知更新，只执行fn。
  void setState<T>(LiveData liveData, LiveDataCallBack<T> fn,
      {bool notify = true}) {
    liveData.setState((cv) {
      fn(cv);
    }, notify: notify);
  }

  void sendNotify(String message, {int? what, Object? data}) {
    if (_notifyCall != null) _notifyCall!(message, what: what, data: data);
  }

  //结束持有ViewModel的页面
  void finish([Object? data]) {
    sendNotify("_finish_current_page", data: data);
  }
}

class ActionViewModel extends ViewModel with OverlayActionMixin {
  ActionViewModel({super.key});
}

class HttpViewModel extends ViewModel with OverlayActionMixin, AnHttpMixin {
  HttpViewModel({super.key});
}
