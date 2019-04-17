class SingleEvent<T> {
  final T _value;
  var _didGet = false;

  SingleEvent(this._value);

  @override
  bool operator ==(Object other) {
    if (other is SingleEvent<T>) {
      return _didGet == other._didGet && !_didGet;
    }
    return false;
  }

  get value {
    if (_didGet) {
      return null;
    }
    _didGet = true;
    return _value;
  }
}
