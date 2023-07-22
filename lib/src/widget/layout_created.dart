import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

///页面首次渲染完成后调用
/// 使用
/// class _MainPageState extends State<MainPage> with LayoutOnCreatedMixin {
///   @override
///   void initState() {
///     super.initState();
///   }
///   @override
///   FutureOr<void> onCreated(BuildContext context) {
///     print('-------------------------onCreated');
///   }
///   参考：https://github.com/fluttercommunity/flutter_after_layout

mixin LayoutOnCreatedMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();

    /// SchedulerBinding addPostFrameCallback 比 WidgetsBinding endOfFrame更早执行
    /// 理论上两个方法可平替

    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   //当前对象在树中时
    //   if(mounted)  onCreated(context);
    // });

    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) onRendered(context);
      },
    );
  }

  FutureOr<void> onRendered(BuildContext context);
}

/// 组件首次渲染完成
///   LayoutOnCreated(onCreated: (value){
///         print('----LayoutCreated:${value.rect}');
///     },
///     child: Text("计数：${count}")
///   )
///
/// 参考：https://book.flutterchina.club/chapter4/layoutbuilder.html#_4-8-2-afterlayout
class LayoutOnCreated extends SingleChildRenderObjectWidget {
  const LayoutOnCreated({
    Key? key,
    required this.onRendered,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderLayoutOnCreated(onRendered);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderLayoutOnCreated renderObject) {
    renderObject.callback = onRendered;
  }

  /// [onCreated] 组件布局完成
  final ValueSetter<RenderLayoutOnCreated> onRendered;
}

class RenderLayoutOnCreated extends RenderProxyBox {
  RenderLayoutOnCreated(this.callback);

  ValueSetter<RenderLayoutOnCreated> callback;

  @override
  void performLayout() {
    super.performLayout();
    // 不能直接回调callback，原因是当前组件布局完成后可能还有其它组件未完成布局
    // 如果callback中又触发了UI更新（比如调用了 setState）则会报错。因此，我们
    // 在 frame 结束的时候再去触发回调。
    // callback(this);
    SchedulerBinding.instance
        .addPostFrameCallback((timeStamp) => callback(this));
  }

  /// 子组件在屏幕中坐标
  /// 组件在在屏幕坐标中的起始偏移坐标
  Offset get offset => localToGlobal(Offset.zero);

  /// 子组件的大小
  /// 组件在屏幕上占有的矩形空间区域
  Rect get rect => offset & size;
}

//from : https://github.com/wendux/flutter_in_action_2
