import 'package:flutter/widgets.dart';
import 'package:flutter_boot/src/lifecycle/view_model.dart';


typedef ViewModelValueWidgetBuilder<T> = Widget Function(
    BuildContext context, T value, Widget? child);


/// 仅继承ValueListenableBuilder
/// 关于多数据源是否需要还有待思考 。目前情况，若遇多数据源可以把源合并。
class ViewModelBuilder<T> extends ValueListenableBuilder<T> {
  const ViewModelBuilder({
    super.key,
    required ModelValueNotifier<T> source,
    required ViewModelValueWidgetBuilder<T> builder,
    Widget? child,
  }) : super(valueListenable: source, builder: builder, child: child);
}
