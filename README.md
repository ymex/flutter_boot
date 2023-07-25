
助力Flutter快速开发的库、目前实现ViewModel框架层、生命周期感知的网络请求封装及常用便捷方法。

## 功能
* 网络请求，基于Dio 封装，生命周期感知。
* ViewModel 。
* 常用工具 ，便捷方法拓展。
* 功能性组件
  * LayoutOnCreated ：首次渲染完成回调
* 外观组件
  * Dot 小圆点

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
    }),
```

## 网络请求
基于Dio封装，需要配合ViewModel与AnHttpViewModelScope来请求接口。实现关闭页面自动断开请求。

```dart
class LoginViewModel extends HttpViewModel {
  late ViewModelState<AuthToken?> authToken = createState(null);
  
  LoginViewModel(super.scope);
  void login(String account, String password, String code) {
    
    var param = Param.url("http://xxx.com")
            .tie("username", account)
            .tie("password", password)
            .tie("code", code);
    
    anValueHttp<BaseModel<AuthToken>>(param,
            convertor: (data) =>
                BaseModel.fromJson(data, (it) => AuthToken.fromJson(it)))
        .then((value) {
              sendNotify("登录成功：${value.data?.realName}", what: 10086);
    });
  }

}
```