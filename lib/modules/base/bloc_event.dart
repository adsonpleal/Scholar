class BlocEvent<T> {
  final T type;
  final dynamic payload;

  BlocEvent(this.type, this.payload);
}
