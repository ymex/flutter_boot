import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';

class Log {
  static void i(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = '',
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      ///sky_engine 提供
      ///dart:ui 是框架的最底层，它负责处理与 Engine 层的交流沟通。
      ///此部分的核心代码是: flutter 仓库下的flutter package，
      ///以及 sky_engine 仓库下的 io, async,
      ///ui (dart:ui 库提供了 Flutter 框架和引擎之间的接口)等package。
      log(message,
          time: time,
          sequenceNumber: sequenceNumber,
          level: level,
          name: name,
          zone: zone,
          error: error,
          stackTrace: stackTrace);
    }
  }
}
