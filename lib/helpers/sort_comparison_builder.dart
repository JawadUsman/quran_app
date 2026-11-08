import 'package:quiver/collection.dart';

enum SortDirection {
  Ascending,
  Descending
}

class SortExpression<T> {
  late SortDirection sortDirection;
  late Comparable Function(T) expression;
}

class SortComparisonBuilder<T> extends DelegatingList<SortExpression<T>> {
  final List<SortExpression<T>> _list = [];

  void ascending(Comparable Function(T) expression) {
    _list.add(
      SortExpression()
        ..sortDirection = SortDirection.Ascending
        ..expression = (t) {
          var tt = expression(t);
          return tt;
        },
    );
  }

  void thenByAscending(Comparable Function(T) expression) {
    _list.add(
      SortExpression()
        ..sortDirection = SortDirection.Ascending
        ..expression = (t) {
          var tt = expression(t);
          return tt;
        },
    );
  }

  void descending(Comparable Function(T) expression) {
    _list.add(
      SortExpression()
        ..sortDirection = SortDirection.Descending
        ..expression = (t) {
          var tt = expression(t);
          return tt;
        },
    );
  }

  void thenByDescending(Comparable Function(T) expression) {
    _list.add(
      SortExpression()
        ..sortDirection = SortDirection.Descending
        ..expression = (t) {
          var tt = expression(t);
          return tt;
        },
    );
  }

  int getCompareTo(T? x, T? y) {
    for (var item in _list) {
      if (x == null && y == null) {
        continue;
      }

      if (x == null) {
        return -1;
      }

      if (y == null) {
        return 1;
      }

      var xItem = item.expression(x);
      var yItem = item.expression(y);

      var result = xItem.compareTo(yItem);
      if (result == 0) {
        continue;
      }

      return item.sortDirection == SortDirection.Descending ? -result : result;
    }

    return 0;
  }

  @override
  List<SortExpression<T>> get delegate => _list;
}
