import 'package:flutter/material.dart';
import 'package:flutter_boot/architecture.dart';
import 'package:flutter_boot/kits.dart';

class InvokeController {
  final Map<Object, VoidValueCallback> _mFun = {};

  void _bind(Object funName, VoidValueCallback call) {
    _mFun[funName] = call;
  }

  void _clear() {
    _mFun.clear();
  }

  void invoke(Object funName, [dynamic data]) {
    if (_mFun.containsKey(funName)) {
      _mFun[funName]!(data);
    } else {
      logI("not find $funName method!}");
    }
  }
}

abstract class StatefulInvokerWidget extends StatefulWidget {
  final InvokeController controller;

  const StatefulInvokerWidget({super.key, required this.controller});
}

mixin StateInvokerMinix<S extends StatefulInvokerWidget> on State<S> {
  @override
  void initState() {
    super.initState();
    useInvokes().forEach((item) {
      widget.controller._bind(item.key, item.value);
    });
  }

  List<MethodPair<VoidValueCallback>> useInvokes() {
    return [];
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller._clear();
  }
}
