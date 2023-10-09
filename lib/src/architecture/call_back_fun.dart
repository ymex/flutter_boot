typedef VoidValueCallback = void Function(dynamic data);

class MethodPair<T> {
  Object key;
  T value;

  MethodPair(this.key, this.value);
}