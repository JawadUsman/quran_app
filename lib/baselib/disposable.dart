abstract class Disposable {
  void dispose();
}

class DisposableBuilder extends Disposable {
  final void Function()? disposeFunction;

  DisposableBuilder({
    required this.disposeFunction,
  });

  @override
  void dispose() {
    if (disposeFunction != null) {
      disposeFunction!();
    }
  }
}
