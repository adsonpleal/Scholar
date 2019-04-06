class SingleEvent<T> {
  final T _value;
  var _didGet = false;

  SingleEvent(this._value);

  T get value {
    if (_didGet) {
      return null;
    }
    _didGet = true;
    return _value;
  }
}
