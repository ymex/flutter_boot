import 'package:flutter/widgets.dart';
import 'package:flutter_boot/core.dart';

typedef LiveDataWidgetBuilder = Widget Function(
    BuildContext context, Widget? child);

typedef SingleLiveDataWidgetBuilder<T> = Widget Function(
    BuildContext context, T value, Widget? child);

class LiveDataBuilder extends ListenableBuilder {
  LiveDataBuilder({
    super.key,
    required List<LiveData> observe,
    required LiveDataWidgetBuilder builder,
    Widget? child,
  }) : super(
            listenable: Listenable.merge(observe),
            builder: builder,
            child: child);
}

class SingleLiveDataBuilder<T> extends ValueListenableBuilder<T> {
  const SingleLiveDataBuilder({
    super.key,
    required LiveData<T> observe,
    required SingleLiveDataWidgetBuilder<T> builder,
    Widget? child,
  }) : super(valueListenable: observe, builder: builder, child: child);
}
