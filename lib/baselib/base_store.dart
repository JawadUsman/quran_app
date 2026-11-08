import 'dart:collection';
import 'disposable.dart';

class BaseStore extends Disposable {
  final Queue<Disposable> _disposables = Queue();
  Queue<Disposable> get disposables => _disposables;

  void registerDispose(void Function() function) {
    disposables.add(
      DisposableBuilder(disposeFunction: function),
    );
  }

  @override
  void dispose() {
    for (var v in disposables) {
      v.dispose();
    }
    disposables.clear();
  }
}
