import 'package:example/event_bus_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boot/core.dart';
import 'package:flutter_boot/widget.dart';

class EventBusNextPage extends StatefulWidget {
  String title;

  EventBusNextPage({super.key, required this.title});

  @override
  State<EventBusNextPage> createState() => _EventBusNextPageState();
}

class _EventBusNextPageState extends State<EventBusNextPage>
    with ViewModelStateScope, OverlayActionMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            FilledButton(
                onPressed: () {
                  globalBus.emit(EventBusViewModel.messageId,
                      "在任意位置发送消息、ViewModel接收并更新到视图上");
                  toast("发送成功");
                },
                child: Text("发送给ViewModel并更新视图")),
            FilledButton(
                onPressed: () {
                  globalBus.emit("log_message", "可在任意位置接收");
                  toast("发送成功");
                },
                child: Text("发送消息")),
          ],
        ),
      ),
    );
  }
}
