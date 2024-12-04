import 'live_data.dart';

mixin LiveDataScope {
  final List<LiveData> _liveDataList = [];

  void join(LiveData liveData) {
    if (!_liveDataList.contains(liveData)) {
      _liveDataList.add(liveData);
    }
  }

  /// 创建 ViewModelState
  /// notify 创建时是否更新状态
  @Deprecated("replace with useLiveData")
  LiveData<T> useState<T>(T value, [bool notify = false]) {
    var liveData = LiveData.useState(value, this, notify);
    return liveData;
  }

  /// 创建 ViewModelState
  /// notify 创建时是否更新状态
  LiveData<T> useLiveData<T>(T value, [bool notify = false]) {
    var liveData = LiveData.useState(value, this, notify);
    return liveData;
  }

  void destroyLiveData() {
    for (var liveDataItem in _liveDataList) {
      liveDataItem.hostDispose = true;
      liveDataItem.dispose();
    }
    _liveDataList.clear();
  }
}
