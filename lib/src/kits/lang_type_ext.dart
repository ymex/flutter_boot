
extension LangBoolExt on bool {
  T truth<T>(T tv, T fv) {
    if (this) {
      return tv;
    }
    return fv;
  }
}

extension LangObjectExt on Object {
  T let<T>(T Function(T v) block) {
    return block(this as T);
  }
}
