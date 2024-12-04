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
          return const Dialog(
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
