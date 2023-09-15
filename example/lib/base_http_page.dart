import 'dart:convert';

import 'package:example/model/base_model.dart';
import 'package:example/model/bili_bili.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boot/http.dart';
import 'package:dio/dio.dart';

class BaseHttpPage extends StatefulWidget {
  const BaseHttpPage({super.key, required this.title});

  final String title;

  @override
  State<BaseHttpPage> createState() => _BaseHttpPageState();
}

class _BaseHttpPageState extends State<BaseHttpPage> {
  void _clickRequest() async {
    var param = Param.url("https://tenapi.cn/v2/weekly")
        .tie("num", "120", type: ParamType.query);
    AnHttp.instance.dio().interceptors.removeWhere((element) => element is LogInterceptor);
    AnHttp.anHttpRaw<String>(param, method: HttpMethodType.get).then((value) {
      var jsonMap =  jsonDecode(value.data!);
      print('---------${jsonMap}');
      var bili = BaseModel<BiliBili>.fromJson(jsonMap, (json) => BiliBili.fromJson(json));
      print('------------bili len:${bili.data?.list[0].title}');
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
              Center(
                  child: OutlinedButton(
                      onPressed: _clickRequest, child: Text("哔哩哔哩每周必看")))
            ],
          ),
        ),
      ),
    );
  }
}
