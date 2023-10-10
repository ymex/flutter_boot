import 'package:flutter_boot/core.dart';
import 'package:flutter_boot/kits.dart';

class EventBusViewModel extends ActionViewModel with EventBusVmMixin {
  static String messageId = "message_id";

  late LiveData<String> liveMessage = useState("");

  /// 注册事件回调
  @override
  List<MethodPair<VoidValueCallback>>? useEvents() {
    return [
      MethodPair(messageId, onMessageEvent),
    ];
  }

  void onMessageEvent(data) {
    // 收到的消息
    logI("-----收到的消息：$data");

    // 更新到页面
    setState(liveMessage, (ov) {
      liveMessage.value = "$data";
    });
  }
}
