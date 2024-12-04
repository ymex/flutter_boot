import 'package:flutter/foundation.dart';
import 'package:flutter_boot/core.dart';
import 'package:flutter_boot/http.dart';

/// ViewModel

class ViewModel with Live {
  final List<LiveData> _liveDataList = [];

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

  @override
  void destroy() {
    super.destroy();
    for (var liveDataItem in _liveDataList) {
      liveDataItem.hostDispose = true;
      liveDataItem.dispose();
    }
    _liveDataList.clear();
  }

  /// 创建 ViewModelState
  /// notify 创建时是否更新状态
  @Deprecated("replace with useLiveState")
  LiveData<T> useState<T>(T value, [bool notify = false]) {
    return useLiveState(value, notify);
  }

  /// 创建 ViewModelState
  /// notify 创建时是否更新状态
  LiveData<T> useLiveState<T>(T value, [bool notify = false]) {
    var liveData = LiveData.useState(value, notify);
    if (!_liveDataList.contains(liveData)) {
      liveData.create();
      _liveDataList.add(liveData);
    }
    return liveData;
  }
}

class HttpViewModel extends ViewModel with AnHttpMixin {
  HttpViewModel({super.key});
}
