import 'package:flutter/cupertino.dart';
import 'package:flutter_boot/widget.dart';

class BootScope extends StatefulWidget {
  final Widget child;

  const BootScope({super.key, required this.child});

  @override
  State<BootScope> createState() => _BootScopeState();
}

class _BootScopeState extends State<BootScope> with BootScopeMixin<BootScope> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

mixin BootScopeMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    OverlayAction.init(context);
  }
}
