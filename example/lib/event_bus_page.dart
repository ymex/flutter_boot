import 'package:example/event_bus_next_page.dart';
import 'package:example/event_bus_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boot/boot.dart';
import 'package:flutter_boot/kits.dart';

class EventBusPage extends StatefulWidget {
  String title;

  EventBusPage({super.key, required this.title});

  @override
  State<EventBusPage> createState() => _EventBusPageState();
}

class _EventBusPageState extends State<EventBusPage> with ViewModelStateScope {
  EventBusViewModel viewModel = EventBusViewModel();

  @override
  List<ViewModel> useViewModels() {
    return [viewModel];
  }

  @override
  void initState() {
    super.initState();
    // 方式二
    // 注册事件
    globalBus.register("log_message", (data) {
      logI("------log_message:${data}");
    });
  }

  @override
  void dispose() {
    super.dispose();
    // 销毁事件
    globalBus.unregister("log_message");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("EventBus使用"),
              const SizedBox(
                height: 24,
              ),
              Text("方式一：在ViewModel中混入EventBusVmMixin、自动注册和销毁。"),
              const SizedBox(
                height: 24,
              ),
              Text("方式二：在任意位置使用、需要手动注册和销毁。"),
              const SizedBox(
                height: 24,
              ),
              SingleLiveDataBuilder(
                  observe: viewModel.liveMessage,
                  builder: (context, value, widget) {
                    return Text(
                      "收到的消息：$value",
                      style: TextStyle(color: Colors.red),
                    );
                  }),
              const SizedBox(
                height: 64,
              ),
              FilledButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (builder) {
                      return EventBusNextPage(title: "EventBusNextPage");
                    }));
                  },
                  child: const Text("下一页面"))
            ],
          ),
        ),
      ),
    );
  }
}
