import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/http_view_model.dart';
import 'package:example/model/bili_bili_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boot/boot.dart';

class HttpViewModelPage extends StatefulWidget {
  final String title;

  const HttpViewModelPage({super.key, required this.title});

  @override
  State<HttpViewModelPage> createState() => _HttpViewModelPageState();
}

/// 亦可继承 ViewModelState
class _HttpViewModelPageState extends State<HttpViewModelPage>
    with ViewModelStateScope {
  //自定义 RefreshIndicatorState 类型的 Key
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();

  //ViewModel 初始化
  late var viewModel = HttpPageViewModel();
  var scrollerController = ScrollController();

  @override
  List<ViewModel> useViewModels() {
    return [viewModel];
  }

  @override
  void initState() {
    super.initState();
    scrollerController.addListener(() {
      if (scrollerController.position.pixels ==
          scrollerController.position.maxScrollExtent) {
        viewModel.loadBiliBili();
      }
    });
  }

  @override
  FutureOr<void> onRendered(BuildContext context) {
    _refreshKey.currentState?.show();
  }

  /// 处理接收到的通知
  @override
  void onNotify(String message, {int? what, Object? data}) {
    if (what == 10) {
      print('收到通知：${message}  标识：${what}  数据：${data}');
    }
  }

  Future _onRefresh() async {
    viewModel.currentPage = 1;
    return viewModel.loadBiliBili();
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
          child: LiveDataBuilder(
              observe: [viewModel.recordState],
              builder: (context, child) {
                var records = viewModel.recordState.value;
                return ListView.separated(
                    controller: scrollerController,
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 1,
                      );
                    },
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      var item = records[index];
                      return itemWidget(
                          context, item, index == records.length - 1);
                    });
              })),
    );
  }

  Widget itemWidget(BuildContext context, BiliBiliRecord item, bool last) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            leading: CachedNetworkImage(
              imageUrl: item.cover,
              placeholder: (context, url) => Icon(Icons.downloading),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            title: Text(item.title),
            subtitle: Text(item.reason),
          ),
          if (last)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text("加载更多")
                ],
              ),
            )
        ],
      ),
    );
  }
}
