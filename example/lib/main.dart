import 'package:example/event_bus_page.dart';
import 'package:example/hint_toast_loading_page.dart';
import 'package:example/http_view_model_page.dart';
import 'package:example/invoke_controller_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boot/kits.dart';

import 'base_http_page.dart';
import 'live_view_model_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    systemEnabledUiMode(
        mode: SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.top]).then((value) {
      SystemUiOverlayStyle style = SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        //状态栏颜色
        systemNavigationBarColor: Colors.transparent,
        //导航栏颜色
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      );
      systemUIOverlayStyle(style);
    });

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class ItemAction {
  String title;
  Widget page;
  String des;

  ItemAction(this.title, this.des, this.page);
}

class _MainPageState extends State<MainPage> {
  var items = [
    ItemAction("基础网络请求", "基于Dio封装的基础网络请求。", const BaseHttpPage(title: "网络请求")),
    ItemAction("LiveData", "观察多个状态变化，主动最小单位刷新",
        const LiveViewModelPage(title: "LiveViewModel")),
    ItemAction("Model-View-Intent", "使用ViewModel实现MVI架构及对组件生命周期感知的网络请求。",
        const HttpViewModelPage(title: "Model-View-Intent")),
    ItemAction(
        "TimeOverlayTier",
        "For Toast & Loading",
        const HintToastDialogPage(
          title: "TimeOverlayTier",
        )),
    ItemAction(
        "EventBus",
        "event bus",
        EventBusPage(
          title: "EventBus",
        )),
    ItemAction(
        "InvokeController",
        "跨组件调用、状态提升",
        const StateControllerPage(
          title: "Invoke Controller",
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue,
      appBar: AppBar(
        // backgroundColor: Colors.blue,
        title: const Text("FLUTTER_BOOT"),
      ),
      body: ListView.separated(
          itemCount: items.length,
          separatorBuilder: (context, index) {
            return const Divider(
              height: 1,
            );
          },
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return items[index].page;
                }));
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          items[index].title,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        const Spacer(),
                        const Icon(Icons.chevron_right)
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(items[index].des,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54)),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
