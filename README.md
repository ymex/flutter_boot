
快速开发Flutter App 的MVI框架、封装Dio网络请求及便捷工具。

## 功能
* 对生命周期感知的网络请求，基于Dio 封装。
* LiveData、ViewModel等实现 MVI
* Screen_Util及方法拓展(屏幕适配代码来自：flutter_screenutil )。
* EventBus
* InvokeController 组件间状态提升
* 组件
  * LayoutOnCreated ：首帧渲染完成回调
  * OverlayTier : 基于OverlayEntry的弹出层，可设置超时时间。可制作toast 与 弹框。 
  * FadeEffect: 点击组件时有变淡效果。
* 组件链式调用

<br><br><br><br> 
<img src="https://raw.githubusercontent.com/ymex/flutter_boot/main/example/assets/demo_home.png" width="360px">


## 开始

```shell
flutter pub add flutter_boot
```

## LiveData
可观察状态变动
```dart
  //定义待观察的状态
  var liveCounter = LiveData.useState(0);
  //使用
  liveCounter.watch((count) => Text('$count'))
  //更新状态 
  liveCounter.setState((v) {
      liveCounter.value = v + 1;
  });
```



## ViewModel
配合LiveData用于观察多个状态变化。

```dart
     // 可观察多个状态变化 ， 如果仅观察一个，可使用 LiveDataBuilder
[viewModel.stateCounter].watch((){
    var counterValue = viewModel.stateCounter.value;
    return Column(
      children: [
        Text(
        // 计数
        '${counterValue.num}',
        style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: counterValue.color),
        ),
      ],
    );
}),
```
## widget链式调用
链式调用，可减少嵌套。原理是使用拓展方法，用组件包裹当前组件、组件方法命名一般是组件类名的小写。 

```dart
  Expanded(
    flex: 1,
    child: GestureDetector(
      onTap: () => logI("----点击"),
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Text("假如我是文本按钮"),
      ),
    ),
  ),

  24.verticalSpace, // 等同 SizedBox(height: 24,),

  //链式调用，减少嵌套。
  "假如我是文本按钮"
      .text()
      .padding(const EdgeInsets.all(8))
      .gestureDetector(onTap: () => logI("----点击"))
      .expanded(1),
```


## 基础网络请求
基于Dio封装的网络请求，简化请求参数。

```dart
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

```

## MVI实现
参考样例.

```dart

//class _HttpViewModelPageState extends ViewModelState<HttpViewModelPage> { 
//或
class _HttpViewModelPageState extends State<HttpViewModelPage>
    with BootStateScope {

  late var viewModel = useViewModel(HttpPageViewModel());
  var scrollerController = ScrollController();

 
  Future _onRefresh() async {
    viewModel.currentPage = 1;
    return viewModel.loadBiliBili();
  }
  // ...
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
          key: _refreshKey,
          onRefresh: _onRefresh,
          child: LiveDataBuilder(
              observe: viewModel.recordState,// 监听状态
              builder: (context,value, child) {
                var records = viewModel.recordState.value;
                return ListView.separated(...);
              })),
    );
  }

  Widget itemWidget(BuildContext context, BiliBiliRecord item, bool last) {
    return Container(...);
  }
}

```
