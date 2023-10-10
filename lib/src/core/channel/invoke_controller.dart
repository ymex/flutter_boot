import 'package:flutter/material.dart';
import 'package:flutter_boot/core.dart';
import 'package:flutter_boot/kits.dart';

class InvokeController {
  final Map<Object, List<VoidValueCallback>> _mFun = {};

  void _bind(Object funName, VoidValueCallback call) {
    if (!_mFun.containsKey(funName)) {
      _mFun[funName] = [];
    }
    _mFun[funName]?.add(call);
  }

  void invoke(Object funName, [dynamic data]) {
    if (_mFun.containsKey(funName)) {
      _mFun[funName]?.forEach((item) {
        item(data);
      });
    } else {
      logI("not find $funName method!}");
    }
  }

  void unInvoke(Object key, [VoidValueCallback? callback]) {
    if (callback != null) {
      _mFun[key]?.remove(callback);
      return;
    }
    _mFun.remove(key);
  }

  void dispose() {
    _mFun.clear();
  }
}

abstract class StatefulInvokerWidget extends StatefulWidget {
  final InvokeController controller;

  const StatefulInvokerWidget({super.key, required this.controller});
}

mixin InvokeStateMinix<S extends StatefulInvokerWidget> on State<S> {
  late List<MethodPair<VoidValueCallback>> _invokes;

  @override
  void initState() {
    super.initState();
    _invokes = useInvokes();
    for (var item in _invokes) {
      widget.controller._bind(item.key, item.value);
    }
  }

  List<MethodPair<VoidValueCallback>> useInvokes() {
    return [];
  }

  @override
  void dispose() {
    super.dispose();
    for (var item in _invokes) {
      var map = widget.controller._mFun;
      if (map.containsKey(item.key)) {
        map[item.key]?.remove(item.value);
      }
    }
  }
}
