/// State management styles Thunder can generate code for.
enum StateManagement {
  /// GetX: controllers, `Get.lazyPut` bindings, `GetPage` routes.
  getx('GetX'),

  /// BLoC (flutter_bloc): bloc + events + state, get_it, go_router.
  bloc('BLoC'),

  /// Cubit (flutter_bloc): cubit + state, get_it, go_router.
  cubit('Cubit');

  const StateManagement(this.label);

  /// Name shown to users.
  final String label;

  /// `true` for BLoC and Cubit (flutter_bloc + get_it + go_router).
  bool get usesFlutterBloc => this != getx;

  /// Parses `getx`, `BLoC`, `cubit` ... Returns `null` for unknown values.
  static StateManagement? tryParse(String? value) {
    for (final style in values) {
      if (style.name == value?.trim().toLowerCase()) return style;
    }
    return null;
  }
}
