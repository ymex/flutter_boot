import 'package:flutter/material.dart';
import 'package:flutter_boot/core.dart';

mixin LiveDataScope<T extends StatefulWidget> on State<T> {
  final List<LiveData> _liveDataList = [];

  /// 创建 ViewModelState
  /// notify 创建时是否更新状态
  LiveData<M> useState<M>(M value, {bool notify = false}) {
    var valueNotifier = LiveData.useState(value, notify: notify);
    _liveDataList.add(valueNotifier);
    return valueNotifier;
  }

  @override
  void dispose() {
    for (var liveDataItem in _liveDataList) {
      liveDataItem.hostDispose = true;
      liveDataItem.dispose();
    }
    super.dispose();
  }
}
