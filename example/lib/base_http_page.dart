import 'dart:convert';

import 'package:example/model/bing_wallpaper_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boot/http.dart';

import 'model/card_result.dart';

class BaseHttpPage extends StatefulWidget {
  const BaseHttpPage({super.key, required this.title});

  final String title;

  @override
  State<BaseHttpPage> createState() => _BaseHttpPageState();
}

class _BaseHttpPageState extends State<BaseHttpPage> {
  var textController = TextEditingController(text: "440521196412193741");
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
    var wardsParam =
        Param.url("https://tools.mgtv100.com/external/v1/pear/queryIdCard")
            .tie("idCard", words, type: ParamType.query);

    AnHttp.anHttpJson<CardResult>(wardsParam,
        convertor: (value) => CardResult.fromJson(value)).then((value) {
      if (value.code == 200) {
        setState(() {
          wordsTip = value.data?.address ?? "";
        });
      } else {
        setState(() {
          wordsTip = value.status;
        });
      }
      dismissLoadingDialog(context);
    });
  }

  void _clickRequest() async {
    showLoadingDialog(context);
    //Bing 壁纸 [zh-CN] 近8天 JSON API
    var param = Param.url(
            "https://raw.onmicrosoft.cn/Bing-Wallpaper-Action/main/data/zh-CN_update.json")
        .tie("num", 120, type: ParamType.query) // query 参数
        .tie("id", "weekly", type: ParamType.path); //path 参数

    //网络请求
    AnHttp.anHttp<String>(param, method: HttpMethodType.get).then((value) {
      var jsonMap = jsonDecode(value.data!);
      var wallpaperResult = BingWallpaperResult.fromJson(jsonMap);

      setState(() {
        recordCount = wallpaperResult.images.length;
      });
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
                      decoration: InputDecoration(labelText: "身份证查询"),
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
                      onPressed: _clickRequest, child: Text("Bing 壁纸 [zh-CN] 近8天"))),
              Text("记录数量：${recordCount}")
            ],
          ),
        ),
      ),
    );
  }
}
