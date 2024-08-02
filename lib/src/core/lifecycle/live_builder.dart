import 'package:flutter/widgets.dart';

import 'live_data.dart';

typedef LiveDataWidgetBuilder = Widget Function(
    BuildContext context, Widget? child);

typedef SingleLiveDataWidgetBuilder<T> = Widget Function(
    BuildContext context, T value, Widget? child);

typedef LiveValueWidgetBuilder<T> = Widget Function(T liveData);

typedef LiveValuesWidgetBuilder<T> = Widget Function();

class MultiLiveDataBuilder extends ListenableBuilder {
  MultiLiveDataBuilder({
    super.key,
    required List<LiveData> observe,
    required super.builder,
    super.child,
  }) : super(listenable: Listenable.merge(observe));
}

class LiveDataBuilder<T> extends ValueListenableBuilder<T> {
  const LiveDataBuilder({
    super.key,
    required LiveData<T> observe,
    required super.builder,
    super.child,
  }) : super(valueListenable: observe);
}

extension LiveDataListExt on List<LiveData> {
  Widget watch(LiveValuesWidgetBuilder<LiveData> builder, {Key? key}) {
    return MultiLiveDataBuilder(
      key: key,
      observe: this,
      builder: (context, _) => builder(),
    );
  }
}

extension LiveDataExt<T> on LiveData<T> {
  Widget watch(LiveValueWidgetBuilder<T> builder, {Key? key}) {
    return LiveDataBuilder(
      key: key,
      observe: this,
      builder: (context, value, _) {
        return builder(value);
      },
    );
  }
}
