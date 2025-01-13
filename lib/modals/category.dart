import 'package:allwork/modals/content_data.dart';

class Category {
  final String category;
  final String? postType;
  final int id;
  final String title;
  final String? link;
  final String? isFav;
  final List<ContentData>? cdata;
  final String? data;

  Category({
    required this.category,
    required this.id,
    required this.title,
    required this.isFav,
    this.link,
    this.postType,
    this.cdata,
    this.data,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        category: json['cat'] ?? '',
        postType: json['posttype'] ?? '',
        id: _parseId(json['id']),
        title: json['title'] ?? '',
        link: json['link'] ?? '',
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

  static int _parseId(dynamic id) {
    if (id is int) {
      return id;
    } else if (id is String) {
      return int.tryParse(id) ?? 0;
    } else {
      return 0;
    }
  }
}
