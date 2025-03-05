import 'package:allwork/modals/content_data.dart';

class FavouriteModel {
  final String id;
  final String title;
  final List<ContentData> cdata;
  String? menuItem;

  FavouriteModel({
    required this.id,
    required this.title,
    required this.cdata,
    this.menuItem,
  });

  factory FavouriteModel.fromJson(Map<String, dynamic> json) {
    return FavouriteModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      cdata: (json['cdata'] as List)
          .map((item) => ContentData.fromJson(item))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'FavouriteModel{id: $id, title: $title, cdata: $cdata}';
  }
}
