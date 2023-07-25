
快速开发 Flutter App库

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
## 基础监听
```dart
// 可观察多个状态变化 ， 如果仅观察一个，可使用 ViewModelSingleStateBuilder
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