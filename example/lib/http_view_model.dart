import 'package:example/model/bili_bili_record.dart';
import 'package:flutter_boot/core.dart';
import 'package:flutter_boot/http.dart';
import 'package:flutter_boot/widget.dart';

import 'model/base_model.dart';
import 'model/bili_bili.dart';

class HttpPageViewModel extends HttpViewModel with OverlayActionMixin {
  HttpPageViewModel({super.key});

  /// 需要监听的状态
  late var recordState = useLiveState(<BiliBiliRecord>[], false);

  var currentPage = 1;

  void loadBiliBili({Param? query}) async {
    showLoading();
    //哔哩哔哩每周必看
    var param = Param.url("https://tenapi.cn/v2/{id}")
        .merge(query)
        .tie("num", currentPage, type: ParamType.query) // query 参数
        .tie("id", "weekly", type: ParamType.path); //path 参数

    //网络请求
    return anHttpJson(param,
            convertor: (dj) =>
                BaseModel<BiliBili>.fromJson(dj, (dj) => BiliBili.fromJson(dj)))
        .then((result) {
      var len = (result.data?.list.length) ?? 0;
      if (len > 0) {
        currentPage++;
      }

      /// 发起更新通知 ，显式的调用setState 去通知更新。
      setState<List<BiliBiliRecord>>(recordState, (value) {
        if (currentPage == 1) {
          recordState.value = result.data?.list ?? [];
        } else {
          recordState.value.addAll(result.data?.list ?? []);
        }
      });

      /// 若要对视图层进行操作，又不愿使用ViewModelState 进行通知，如何处理？
      /// 原则上不建议直接操作视图层的方法或数据。LiveViewModel 已经对视图层做了限制。
      /// 但是，
      /// 你可以使用sendNotify()向视图层发送通知，在视图层重载onNotify()方法处理通知。
      sendNotify("网络请求成功", what: 10, data: result);
      dismissLoading();
    });
  }
}
