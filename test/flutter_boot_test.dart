import 'package:flutter_boot/lifecycle.dart';
import 'package:flutter_test/flutter_test.dart';

mixin Am on Object{
  @override
  String toString() {
    print('-----${super.toString()}');
    return "am ----";
  }
}

mixin Bx on Object{
  @override
  String toString() {
    print('-----${super.toString()}');
    return "bm ----";
  }
}

class Userm with Am,Bx{}

void main() {
  var u = Userm();
  print(' '+u.toString());
  // test('adds one to input values', () {
  // });
}
