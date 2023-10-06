part of "view_model_state.dart";

mixin ActionVmMixin on ViewModel {
  Function(
    String message, {
    int duration,
    ToastAlignment alignment,
    Widget? widget,
  })? _toastCall;

  Function({Widget? widget})? _showLoadingCall;

  VoidCallback? _dismissLoadingCall;

  void toast(
    String message, {
    int duration = 2,
    ToastAlignment alignment = ToastAlignment.bottom,
    Widget? widget,
  }) {
    if (_toastCall != null) {
      _toastCall!(message,
          duration: duration, alignment: alignment, widget: widget);
    }
  }

  void showLoading({Widget? widget}) {
    if (_showLoadingCall != null) {
      _showLoadingCall!(widget: widget);
    }
  }

  void dismissLoading() {
    if (_dismissLoadingCall != null) {
      _dismissLoadingCall!();
    }
  }
}

class ActionViewModel extends ViewModel with ActionVmMixin {}
