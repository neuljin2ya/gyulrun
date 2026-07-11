class FavoriteStore {
  FavoriteStore._();

  static final instance = FavoriteStore._();

  final Set<String> _courseNames = {};

  bool contains(String courseName) => _courseNames.contains(courseName);

  void setFavorite(String courseName, {required bool isFavorite}) {
    if (isFavorite) {
      _courseNames.add(courseName);
    } else {
      _courseNames.remove(courseName);
    }
  }

  void clear() => _courseNames.clear();
}
