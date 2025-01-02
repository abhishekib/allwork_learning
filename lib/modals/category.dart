import 'package:allwork/modals/content_data.dart';

class Category {
  final String category;
  final int id;
  final String title;
  final String? isFav;
  final List<ContentData>? cdata;
  final String? data;

  Category(
      {required this.category,
      required this.id,
      required this.title,
      required this.isFav,
      this.cdata,
      this.data});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        category: json['cat'] ?? '',
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        isFav: json['isfav'] ?? 'No',
        cdata: json['cdata'] != null
            ? (json['cdata'] as List)
                .map((data) => ContentData.fromJson(data))
                .toList()
            : [], // Return an empty list if "cdata" is null
        data: json['data'] ?? '');
  }

  @override
  String toString() {
    return "cat: $category, id $id, title $title, isFav $isFav, cData $cdata";
  }
}
