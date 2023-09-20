
Flutter MVI 快速开发实现库。

## 功能
* MVI
* 网络请求，基于Dio 封装，生命周期感知。
* LiveViewModel、HttpViewModel 等
* 常用工具 ，便捷方法拓展。
* 组件
  * LayoutOnCreated ：首次渲染完成回调
  * OverlayTier : 基于OverlayEntry的弹出层，可设置超时时间。可制作toast 与 弹框。 


<br><br><br><br> 
<img src="https://raw.githubusercontent.com/ymex/flutter_boot/main/example/assets/demo_home.png" width="360px">


## 开始

```shell
flutter pub add flutter_boot
```
## ViewModel
配合ViewModelStateBuilder用于观察多个状态变化。

```dart

ViewModelStateBuilder(
    //状态，要观察的 view model 的状态
    state: [viewModel.stateCounter],
    builder: (context, child) {
      var counterValue = viewModel.stateCounter.value;

      return Text(
        // 计数
        '${counterValue.num}',
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(color: counterValue.color),
      );
    })
```

## 基础网络请求
基于Dio封装的网络请求，简化请求参数。

```dart
import 'dart:convert';

import 'package:example/model/base_model.dart';
import 'package:example/model/bili_bili.dart';
import 'package:example/model/words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boot/http.dart';

class BaseHttpPage extends StatefulWidget {
  const BaseHttpPage({super.key, required this.title});

  final String title;

  @override
  State<BaseHttpPage> createState() => _BaseHttpPageState();
}

class _BaseHttpPageState extends State<BaseHttpPage> {
  var textController = TextEditingController(text: "厚德载物");
  var wordsTip = "";
  var recordCount = 0;
  var isLoading = false;

  void showLoadingDialog(BuildContext context) {
    if (isLoading) {
      return;
    }
    this.isLoading = true;
    showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            child: SizedBox(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        });
  }

  void dismissLoadingDialog(BuildContext context) {
    if (this.isLoading) {
      this.isLoading = false;
      Navigator.pop(context);
    }
  }

  void _searchWords() async {
    showLoadingDialog(context);

    var words = textController.text;
    //词语查询
    var wardsParam = Param.url("https://v.api.aa1.cn/api/api-chengyu/index.php")
        .tie("msg", words, type: ParamType.query);

    AnHttp.anHttpJson<Words>(wardsParam,
        convertor: (value) => Words.fromJson(value)).then((value) {
      if (value.code == "1") {
        setState(() {
          wordsTip = value.cyjs ?? "";
        });
      } else {
        setState(() {
          wordsTip = value.error ?? "";
        });
      }
      dismissLoadingDialog(context);
    });
  }

  void _clickRequest() async {
    showLoadingDialog(context);
    //哔哩哔哩每周必看
    var param = Param.url("https://tenapi.cn/v2/{id}")
        .tie("num", 120, type: ParamType.query) // query 参数
        .tie("id", "weekly", type: ParamType.path); //path 参数

    //网络请求
    AnHttp.anHttp<String>(param, method: HttpMethodType.get).then((value) {
      var jsonMap = jsonDecode(value.data!);
      var bili = BaseModel<BiliBili>.fromJson(
          jsonMap, (json) => BiliBili.fromJson(json));

      if (bili.data != null) {
        setState(() {
          recordCount = bili.data?.list.length ?? 0;
        });
      }
      dismissLoadingDialog(context);
    }).catchError((err) {
      print("------err:${err}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: textController,
                      decoration: InputDecoration(labelText: "词语查询"),
                    )),
                    OutlinedButton(onPressed: _searchWords, child: Text("查询"))
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Container(
                  color: Colors.blueGrey,
                  child: Text(wordsTip),
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                ),
              ),
              Center(
                  child: OutlinedButton(
                      onPressed: _clickRequest, child: Text("哔哩哔哩每周必看"))),
              Text("记录数量：${recordCount}")
            ],
          ),
        ),
      ),
    );
  }
}

```

## MVI
LiveViewModel与AnHttpViewModelScope来请求接口。实现关闭页面自动断开请求。

```dart
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/http_view_model.dart';
import 'package:example/model/bili_bili_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boot/lifecycle.dart';

class HttpViewModelPage extends StatefulWidget {
  final String title;

  const HttpViewModelPage({super.key, required this.title});

  @override
  State<HttpViewModelPage> createState() => _HttpViewModelPageState();
}

class _HttpViewModelPageState extends State<HttpViewModelPage>
    with AnHttpViewModelScope<HttpViewModelPage> {
  //自定义 RefreshIndicatorState 类型的 Key
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();

  //ViewModel 初始化
  late var viewModel = HttpPageViewModel(this);
  var scrollerController = ScrollController();

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
    if(what==10){
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
          child: ViewModelStateBuilder(
              state: [viewModel.recordState],
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

```
