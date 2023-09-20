import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boot/src/lifecycle/view_model.dart';
import 'package:flutter_boot/src/http/an_http.dart';
import 'package:flutter_boot/src/http/an_param.dart';
import 'package:flutter_boot/widget.dart';

/////////////////////////////////////////ViewModelScope//////////////////////////////
mixin ViewModelScope<T extends StatefulWidget> on State<T> {
  late List<ViewModelState> _notifiers;

  @override
  void initState() {
    _viewModelScopeInitState();
    super.initState();
  }

  /// 关闭页面后，请求取消。
  @override
  void dispose() {
    _viewModelScopeDispose();
    super.dispose();
  }

  /// 通知事件 用于 view model 主动调用。
  /// message 消息说明,相当于注释吧。
  /// what 可自定义消息标记
  /// data 携带的数据
  void onNotify(String message, {int? what, Object? data}) {}

  FutureOr<void> onRendered(BuildContext context) {}
}

extension ViewModelScopeExtension on ViewModelScope {
  void _viewModelScopeInitState() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) onRendered(context);
      },
    );
    _notifiers = [];
  }

  void _viewModelScopeDispose() {
    for (var element in _notifiers) {
      element.hostDispose = true;
    }
    _notifiers.clear();
  }

  //管理
  void putViewModelStateNotifier(ViewModelState valueNotifier) {
    _notifiers.add(valueNotifier);
  }
}

/////////////////////////////////////////ActionViewModelScope//////////////////////////////
/// UI 状态管理
mixin ActionViewModelScope<T extends StatefulWidget> on State<T>
    implements ViewModelScope<T> {
  @override
  late List<ViewModelState> _notifiers;
  OverlayTier? _toastTier;

  OverlayTier? _loadingTier;

  @override
  void initState() {
    _viewModelScopeInitState();
    _actionScopeInitState();
    super.initState();
  }

  /// 关闭页面后，请求取消。
  @override
  void dispose() {
    _viewModelScopeDispose();
    _actionScopeDispose();
    super.dispose();
  }

  @override
  void onNotify(String message, {int? what, Object? data}) {}

  @override
  FutureOr<void> onRendered(BuildContext context) {}

  void toast(
    String message, {
    int duration = 2,
    ToastAlignment alignment = ToastAlignment.bottom,
    Widget? widget,
  }) {
    _toast(
        message: message,
        duration: duration,
        alignment: alignment,
        widget: widget);
  }

  void showLoading({Widget? widget}) {
    _showLoading(widget);
  }

  void dismissLoading() {
    _dismissLoading();
  }
}

extension ActionViewModelScopeExtension on ActionViewModelScope {
  void _actionScopeInitState() {
    _toastTier = OverlayTier();
    _loadingTier = OverlayTier();
  }

  void _actionScopeDispose() {
    _toastTier?.dismiss();
    _loadingTier?.dismiss();
    _toastTier = null;
    _loadingTier = null;
  }

  void _showLoading(Widget? widget) {
    _loadingTier?.show(context, widget ?? buildDefLoadingOverlay(context),
        replace: false);
  }

  /// toast
  /// [message] 提醒的文字
  /// [duration] 显示的时长，单位秒
  /// [alignment] 显示的位置
  /// [margin] 边距
  void _toast(
      {Widget? widget,
      String? message,
      int duration = 2,
      ToastAlignment alignment = ToastAlignment.bottom}) {
    if (widget == null) {
      var tw = buildDefToastOverlay(context,
          message: message, duration: duration, alignment: alignment);
      _toastWidget(tw, duration: duration);
      return;
    }
    _toastWidget(widget, duration: duration);
  }

  void _toastWidget(Widget widget, {int duration = 2}) {
    _toastTier?.show(context, widget,
        duration: Duration(seconds: duration), opaque: false);
  }

  void _dismissLoading() {
    _loadingTier?.dismiss();
  }
}

/////////////////////////////////////////HttpViewModelScope//////////////////////////////

/// 用于请求管理，当页面关闭时结束 请求
mixin HttpViewModelScope<T extends StatefulWidget> on State<T>
    implements ActionViewModelScope<T> {
  @override
  late List<ViewModelState> _notifiers;
  @override
  OverlayTier? _toastTier;
  @override
  OverlayTier? _loadingTier;
  late List<CancelToken> _httpRequestTokens;

  @override
  void initState() {
    _viewModelScopeInitState();
    _actionScopeInitState();
    _anHttpScopeInitState();
    super.initState();
  }

  /// 关闭页面后，请求取消。
  @override
  void dispose() {
    _viewModelScopeDispose();
    _actionScopeDispose();
    _anHttpScopeDispose();
    super.dispose();
  }

  @override
  void onNotify(String message, {int? what, Object? data}) {}

  @override
  FutureOr<void> onRendered(BuildContext context) {}

  //--------action
  @override
  void toast(
    String message, {
    int duration = 2,
    ToastAlignment alignment = ToastAlignment.bottom,
    Widget? widget,
  }) {
    _toast(
        message: message,
        duration: duration,
        alignment: alignment,
        widget: widget);
  }

  @override
  void showLoading({Widget? widget}) {
    _showLoading(widget);
  }

  @override
  void dismissLoading() {
    _dismissLoading();
  }
}

/////////////////////////////////////////extension//////////////////////////////

extension HttpViewModelScopeExtension on HttpViewModelScope {
  void _anHttpScopeInitState() {
    _httpRequestTokens = [];
  }

  void _anHttpScopeDispose() {
    for (var element in _httpRequestTokens) {
      if (!element.isCancelled) {
        element.cancel();
      }
    }
    _httpRequestTokens.clear();
  }

  void putHttpRequestToken(CancelToken cancelToken) {
    _httpRequestTokens.add(cancelToken);
  }

  /// dio 原始返回类型 请求
  Future<Response<T>> anHttp<T>(Param param,
      {HttpMethodType method = HttpMethodType.post,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) {
    var cancelToken = HttpRequestToken();
    putHttpRequestToken(cancelToken);

    return AnHttp.anHttp<T>(param,
        method: method,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);

    // return AnHttp.instance
    //     .request<T>(param, method: method, cancelToken: cancelToken);
  }

  /// http请求， 用于返回值是Object的请求。
  /// convert 数据类型转换器。
  Future<T> anHttpJson<T>(Param param,
      {required JsonObjectConvertor<T> convertor,
      HttpMethodType method = HttpMethodType.post,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    var cancelToken = HttpRequestToken();
    putHttpRequestToken(cancelToken);

    // var response = await AnHttp.anHttp<Map<String, dynamic>>(param,
    //     method: method,
    //     cancelToken: cancelToken,
    //     onSendProgress: onSendProgress,
    //     onReceiveProgress: onReceiveProgress);

    // var response = await AnHttp.instance.request<Map<String, dynamic>>(param,
    //     method: method, cancelToken: cancelToken);

    // return convertor(response.data!);
    var response = await AnHttp.anHttpJson<T>(param,
        convertor: convertor,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
    return response;
  }

  /// http请求， 用于返回值是数组的请求。
  /// convert 数据类型转换器。
  Future<List<T>> anHttpArray<T>(
    Param param, {
    required JsonArrayConvertor<T> convertor,
    HttpMethodType method = HttpMethodType.post,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    var cancelToken = HttpRequestToken();
    putHttpRequestToken(cancelToken);
    // var response = await AnHttp.instance.request<List<dynamic>>(param,
    //     method: method, cancelToken: cancelToken);

    // var response = await AnHttp.anHttp<List<dynamic>>(param,
    //     method: method,
    //     cancelToken: cancelToken,
    //     onSendProgress: onSendProgress,
    //     onReceiveProgress: onReceiveProgress);
    // return convertor(response.data!);

    var response = await AnHttp.anHttpArray<T>(param,
        convertor: convertor,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
    return response;
  }
}
