import 'package:flutter/widgets.dart';
import 'package:flutter_boot/core.dart';

typedef LiveDataWidgetBuilder = Widget Function(
    BuildContext context, Widget? child);

typedef SingleLiveDataWidgetBuilder<T> = Widget Function(
    BuildContext context, T value, Widget? child);

class MultiLiveDataBuilder extends ListenableBuilder {
  MultiLiveDataBuilder({
    super.key,
    required List<LiveData> observe,
    required super.builder,
    super.child,
  }) : super(
            listenable: Listenable.merge(observe));
}

class LiveDataBuilder<T> extends ValueListenableBuilder<T> {
  const LiveDataBuilder({
    super.key,
    required LiveData<T> observe,
    required super.builder,
    super.child,
  }) : super(valueListenable: observe);
}
