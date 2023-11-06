import 'package:flutter/widgets.dart';

/// 二次贝塞尔曲线
/// https://juejin.cn/post/6857418437254512654
/// http://blogs.sitepointstatic.com/examples/tech/canvas-curves/quadratic-curve.html
// PopupMenuButton(
//       color: Colors.black54,
//       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
//       constraints: BoxConstraints(maxWidth: 130),
//       surfaceTintColor: Colors.transparent,
//       shape: const TipRRectShape(triangleOffsetX: 86),
//       offset: Offset(0, 36),
//       itemBuilder: (context) {
//         return [
//           PopupMenuItem(
//             child: Text(
//               "扫码",
//               style: AppTextStyles.normalWhiteTextStyle,
//             ),
//             height: 36,
//           ),
//           PopupMenuItem(child: Text("收款"), height: 36),
//           PopupMenuItem(
//               child: Row(
//                 children: [
//                   Text("账单"),
//                   SizedBox(
//                     width: 12,
//                   ),
//                   Icon(Icons.expand_more)
//                 ],
//               ),
//               height: 36),
//         ];
//       },
//       child: const Padding(
//         padding: EdgeInsets.only(right: 12.0, left: 12),
//         child: Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//       ),
//     )

class TipRRectShape extends ShapeBorder {
  final BorderSide _side = BorderSide.none;
  final BorderRadiusGeometry _borderRadius = BorderRadius.zero;

  final double radius, triangleOffsetX, triangleWidth, triangleHeight;

  const TipRRectShape({
    this.radius = 10,
    this.triangleOffsetX = 20,
    this.triangleWidth = 20,
    this.triangleHeight = 10,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(_side.width);

  @override
  Path getInnerPath(
    Rect rect, {
    TextDirection? textDirection,
  }) {
    final Path path = Path();

    path.addRRect(
      _borderRadius.resolve(textDirection).toRRect(rect).deflate(_side.width),
    );

    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();
    final RRect rrect = _borderRadius.resolve(textDirection).toRRect(rect);

    path.moveTo(0, radius);
    // double x1, double y1, 控制点
    // double x2, double y2  终点
    path.quadraticBezierTo(0, 0, radius, 0);

    path.lineTo(triangleOffsetX, 0);
    path.lineTo(triangleOffsetX + triangleWidth / 2, -triangleHeight);
    path.lineTo(triangleOffsetX + triangleWidth, 0); //第三个点

    path.lineTo(rrect.width - radius, 0); //第三个点

    path.quadraticBezierTo(rrect.width, 0, rrect.width, radius);

    path.lineTo(rrect.width, rrect.height - radius);

    path.quadraticBezierTo(
        rrect.width, rrect.height, rrect.width - radius, rrect.height);

    path.lineTo(radius, rrect.height);

    path.quadraticBezierTo(0, rrect.height, 0, rrect.height - radius);

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => RoundedRectangleBorder(
        side: _side.scale(t),
        borderRadius: _borderRadius * t,
      );
}
