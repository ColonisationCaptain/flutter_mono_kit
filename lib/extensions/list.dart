extension ListEx<T> on List<T> {
  List<E> mapWithIndex<E>(E Function(T item, int index) f) => asMap()
      .entries
      .map((entry) => f(
            entry.value,
            entry.key,
          ))
      .toList();
}
