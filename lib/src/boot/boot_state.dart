import "package:flutter/widgets.dart";
import "package:flutter_boot/core.dart";

class BootState<T extends StatefulWidget> extends State<T>
    with
        ViewModelStateScope,
        LiveDataScope,
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin {
  @override
  void dispose() {
    destroyLiveData();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => false;
}
