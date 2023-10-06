import 'package:flutter/foundation.dart';

part 'lifecycle/live_data.dart';

/// ViewModel

class ViewModel {
  final List<LiveData> _liveDataList = [];
  Function(VoidCallback)? _stateCall;
  Function(String message, {int? what, Object? data})? _notifyCall;

  List<LiveData> get liveDataList => _liveDataList;

  set stateCall(value) => _stateCall = value;

  set notifyCall(value) => _notifyCall = value;

  //管理
  void _putViewModelStateNotifier(LiveData liveData) {
    _liveDataList.add(liveData);
  }

  /// 创建 ViewModelState
  /// notify 创建时是否更新状态
  LiveData<T> useState<T>(T value, {bool notify = false}) {
    var valueNotifier = LiveData._(value, notify: notify);
    _putViewModelStateNotifier(valueNotifier);
    return valueNotifier;
  }

  void setScopeState(VoidCallback fn) {
    if (_stateCall != null) _stateCall!(fn);
  }

  void setState<T>(LiveData liveData, LiveDataCallBack<T> fn) {
    liveData._setState<T>(fn);
  }

  void sendNotify(String message, {int? what, Object? data}) {
    if (_notifyCall != null) _notifyCall!(message, what: what, data: data);
  }
}
