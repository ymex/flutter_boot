import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/http_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boot/boot.dart';
import 'package:flutter_boot/chain.dart';
import 'package:flutter_boot/core.dart';
import 'package:flutter_boot/kits.dart';

import 'model/bing_wallpaper_result.dart';

class HttpViewModelPage extends StatefulWidget {
  final String title;

  const HttpViewModelPage({super.key, required this.title});

  @override
  State<HttpViewModelPage> createState() => _HttpViewModelPageState();
}

/// 亦可继承 ViewModelState
class _HttpViewModelPageState extends State<HttpViewModelPage>
    with BootStateScope {
  //自定义 RefreshIndicatorState 类型的 Key
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();

  //ViewModel 初始化
  late var viewModel = useViewModel(HttpPageViewModel());
  var scrollerController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollerController.addListener(() {
      if (scrollerController.position.pixels ==
          scrollerController.position.maxScrollExtent) {
        viewModel.loadBing();
      }
    });
  }

  @override
  Future onRendered(BuildContext context) async {
    viewModel.loadBing();
  }

  /// 处理接收到的通知
  @override
  void onNotify(String message, {int? what, Object? data}) {
    if (what == 10) {
      print('收到通知：${message}  标识：${what}  数据：${data}');
    }
  }

  Future _onRefresh() async {
    logI("--------------------------------refresh");
    viewModel.currentPage = 1;
    return viewModel.loadBing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _onRefresh,
        // ViewModelStateBuilder 监听状态
        child: viewModel.recordState.watch((images) {
          return ListView.separated(
              controller: scrollerController,
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 1,
                );
              },
              itemCount: images.length,
              itemBuilder: (context, index) {
                var item = images[index];
                return itemWidget(context, item, index == images.length - 1);
              });
        }),
      ),
    );
  }

  Widget itemWidget(BuildContext context, Images item, bool last) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              CachedNetworkImage(
                height: 100,
                imageUrl: "https://www.bing.com/" + item.url,
                placeholder: (context, url) => const Icon(Icons.downloading),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ).padding(const EdgeInsets.symmetric(vertical: 24, horizontal: 8)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: 16.textStyle(fontWeight: FontWeight.bold),
                  ),
                  8.verticalSpace,
                  Text(item.copyright)
                ],
              ).expanded(1)
            ],
          )

          // if (last)
          //   Container(
          //     padding: const EdgeInsets.symmetric(vertical: 12),
          //     child: const Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         SizedBox(
          //           width: 16,
          //           height: 16,
          //           child: CircularProgressIndicator(),
          //         ),
          //         SizedBox(
          //           width: 12,
          //         ),
          //         Text("加载更多")
          //       ],
          //     ),
          //   )
        ],
      ),
    );
  }
}
