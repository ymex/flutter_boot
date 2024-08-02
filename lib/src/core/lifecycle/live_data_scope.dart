import 'live_data.dart';

mixin LiveDataScope {
  final List<LiveData> _liveDataList = [];

  void addLiveData(LiveData liveData) {
    if (!_liveDataList.contains(liveData)) {
      _liveDataList.add(liveData);
    }
  }

  /// 创建 ViewModelState
  /// notify 创建时是否更新状态
  LiveData<M> useState<M>(M value, {bool notify = false}) {
    var liveData = LiveData.useState(value, notify: notify);
    addLiveData(liveData);
    return liveData;
  }

  void dispose() {
    for (var liveDataItem in _liveDataList) {
      liveDataItem.hostDispose = true;
      liveDataItem.dispose();
    }
    _liveDataList.clear();
  }
}
