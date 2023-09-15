import 'dart:async';

import 'package:flutter/material.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
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
    ItemAction("LiveViewModel", "观察多个状态变化，主动最小单位刷新",
        const LiveViewModelPage(title: "LiveViewModel")),
    ItemAction("HttpViewModel", "http+LiveViewModel感知组件生命周期。页面销毁时结束组件内的网络请求。",
        const LiveViewModelPage(title: "HttpViewModel")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              onTap: () {
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
