extension IterableExtensions<E> on Iterable<E> {
  List<T> mapToList<T>(T Function(E e) toElement, {bool growable = false}) {
    return map(toElement).toList(growable: growable);
  }

  List<T> flatMap<T>(List<T> Function(E e) toElement) {
    List<T> list = [];
    for (E e in this) {
      for (T t in toElement(e)) {
        list.add(t);
      }
    }
    return list;
  }

  List<T> flatMapIndexed<T>(List<T> Function(E e, int index) toElement) {
    List<T> list = [];
    final startingList = this is List ? this as List : toList();
    for (int i = 0; i < length; i++) {
      final e = startingList[i];
      for (T t in toElement(e, i)) {
        list.add(t);
      }
    }
    return list;
  }

  bool all(bool Function(E element) test) {
    for (E element in this) {
      if (!test(element)) return false;
    }
    return true;
  }

  E? firstWhereOrNull(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  List<E> filter(bool Function(E element) test) {
    List<E> newList = [];
    for (E e in this) {
      if (test(e)) {
        newList.add(e);
      }
    }
    return newList;
  }

  List<E> sortedBy(Comparable Function(E element) comparer) {
    var list = toList();
    list.sort((a, b) => comparer(a).compareTo(comparer(b)));
    return list;
  }

  List<T> castToList<T>() {
    return cast<T>().toList();
  }
}

extension IntIterableExtension on Iterable<int> {
  int? max() {
    if (length == 0) return null;
    return reduce((a, b) => a > b ? a : b);
  }
}

extension ListExtensions<E> on List<E> {
  List<T> mapIndexed<T>(T Function(E e, int index) toElement) {
    List<T> list = [];
    for (int i = 0; i < length; i++) {
      list.add(toElement(this[i], i));
    }
    return list;
  }
}
