import 'package:flutter/widgets.dart';

import 'package:flutter_boot/src/lifecycle/view_model.dart';

typedef ViewModelStateWidgetBuilder = Widget Function(
    BuildContext context, Widget? child);

typedef ViewModelSingleStateWidgetBuilder<T> = Widget Function(
    BuildContext context, T value, Widget? child);

class ViewModelStateBuilder extends ListenableBuilder {
  ViewModelStateBuilder(
      {super.key,
      required List<ViewModelState> state,
      required ViewModelStateWidgetBuilder builder,
      Widget? child})
      : super(
            listenable: Listenable.merge(state),
            builder: builder,
            child: child);
}

class ViewModelSingleStateBuilder<T> extends ValueListenableBuilder<T> {
  const ViewModelSingleStateBuilder({
    super.key,
    required ViewModelState<T> state,
    required ViewModelSingleStateWidgetBuilder<T> builder,
    Widget? child,
  }) : super(valueListenable: state, builder: builder, child: child);
}
