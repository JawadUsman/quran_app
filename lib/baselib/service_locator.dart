class ServiceLocator {
  final _providers = <String?, Map<Type, _ServiceLocatorProvider<Object>>>{};

  void registerLazySingleton<T extends Object>(
    T Function() instanceBuilder, {
    String? name,
  }) {
    _setProvider<T>(
      name: name,
      provider: _ServiceLocatorProvider.singleton(instanceBuilder),
    );
  }

  void registerBuilder<T extends Object>(
    T Function() instanceBuilder, {
    String? name,
  }) {
    _setProvider<T>(
      name: name,
      provider: _ServiceLocatorProvider.builder(instanceBuilder),
    );
  }

  T? get<T extends Object>({
    String? name,
  }) {
    var namedProvider = _providers[name];
    if (namedProvider?.containsKey(T) == true) {
      var provider = namedProvider![T];
      return provider?.get() as T?;
    } else {
      return null;
    }
  }

  void unregiser<T>({
    String? name,
  }) {
    _providers[name]?.remove(T);
  }

  void clear() {
    _providers.clear();
  }

  void _setProvider<T extends Object>({
    required _ServiceLocatorProvider<T> provider,
    String? name,
  }) {
    var map = _providers.putIfAbsent(name, () {
      return <Type, _ServiceLocatorProvider<Object>>{};
    });
    map[T] = provider;
  }
}

class _ServiceLocatorProvider<T extends Object> {
  _ServiceLocatorProvider.builder(
    this.instanceBuilder,
  );

  _ServiceLocatorProvider.singleton(this.instanceBuilder) : onetime = true;

  final T Function() instanceBuilder;
  var onetime = false;
  T? object;

  T? get() {
    if (object != null) {
      return object;
    }
    if (onetime && object == null) {
      object = instanceBuilder();
      return object;
    }

    return instanceBuilder();
  }
}
