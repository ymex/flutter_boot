# CHANGELOG

## 0.2.4

- 优化ViewModelScope

## 0.2.3

- ViewModel setState 添加开关参数

## 0.2.2

- StatefulInvokerWidget 添加泛型

## 0.2.1

- StateInvokerMinix -> InvokeStateMinix

## 0.2.0

- 增加 InvokeController 实现组件状态提升
- architecture package -> core

## 0.1.9

- log 打印调用信息

## 0.1.8

- ViewModel 增加 key 字段
- BuildContent 扩展

## 0.1.7

- anHttp 非map入参处理

## 0.1.6

- add EventBusStateMinix
- update example

## 0.1.5

- EventBus
- lifecycle package -> architecture

## 0.1.4

- 修复FadeEffect组件取消点击状态不消失问题
- 重命名ViewModelScope -> ViewModelStateScope
- 优化代码格式符合Dart Format

## 0.1.3

主要重构lifecycle 模块、类型命名更合理化。

- 1、ViewModel 不再持用Flutter State 需要修改 引用 ViewModel的地方。
- 2、ViewModelStateBuilder 更名为 LiveDataBuilder ， state 修改为 observe
- 3、SingleViewModelStateBuilder 更名为 SingleLiveDataBuilder ， state 修改为 observe
- 4、删除了HttpViewModelScope、ActionViewModelScope ，可使用ViewModelScope 替换，且需要实现initViewModel方法。
- 5、ViewModelState 变更为 LiveData 。 ViewModelState 现在为Flutter State的抽象子类、方便自定拓展。

## 0.1.2

- 增加DateTime拓展时间格式化
- fix let方法

## 0.1.1

- 增加点击淡出效果组件

## 0.1.0

- 增加BuildContext 拓展方法
- 优化anHttp日志打印

## 0.0.9

- 优化结构及增加example代码。
- 增加ActionViewModel
- 增加组件OverlayTier

## 0.0.8

- 增加toast 和 loading dialog
- 删除Dot组件

## 0.0.7

- 优化

## 0.0.6

- Param 方法优化及优化
- 修复 AnHttp 响应数据类型转换错误
- LiveViewModel 方法调整

## 0.0.5

- Rename the anHttp's method name

## 0.0.4

- fix Pass static analysis WARNING

## 0.0.3

- 监听多状态
- 更新README.md

## 0.0.2

- 更新README.md

## 0.0.1

- 网络请求，基于Dio 封装，生命周期感知。
- ViewModel 。
- 常用工具 ，便捷方法拓展。
- 功能性组件
    - LayoutOnCreated ：首次渲染完成回调
- 外观组件
    - Dot 小圆点

