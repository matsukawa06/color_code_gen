class FavoritStore {
  late final int? id;
  final int? colorCode;
  final String title;
  final int? sortNo;

  FavoritStore({
    this.id,
    this.colorCode,
    required this.title,
    this.sortNo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'colorCode': colorCode,
      'title': title,
      'sortNo': sortNo,
    };
  }
}
