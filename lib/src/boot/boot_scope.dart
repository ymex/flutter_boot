import 'package:flutter/widgets.dart';
import 'package:flutter_boot/kits.dart';
import 'package:flutter_boot/widget.dart';

class Boot {
  static BuildContext? scopeContext;
  static double? screenWidth;
  static double? screenHeight;
}

class BootScope extends StatefulWidget {
  final Widget child;

  const BootScope({super.key, required this.child});

  @override
  State<BootScope> createState() => _BootScopeState();
}

class _BootScopeState extends State<BootScope> with BootScopeMixin<BootScope> {
  @override
  Widget build(BuildContext context) {
    setScreenSize();
    return widget.child;
  }
}

mixin BootScopeMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    Boot.scopeContext = context;
    OverlayAction.init(context);
  }

  ///需要在build 中主动调用
  void setScreenSize() {
    if (context.sw != Boot.screenWidth) {
      Boot.screenWidth = context.sw;
    }
    if (context.sh != Boot.screenHeight) {
      Boot.screenHeight = context.sh;
    }
  }
}
