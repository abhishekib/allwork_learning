import 'package:realm/realm.dart';

part 'menu_detail_entity.realm.dart';

@RealmModel()
class _MenuDetailEntityNested {
  @PrimaryKey()
  late String endpoint;
  late List<_MenuDetailEntity> menuDetailEntity; //for ziyarat 14 masoomeen
  late _MenuDetailEntity? others; //for other ziyarat
}

@RealmModel()
class _MenuDetailEntity {
  @PrimaryKey()
  late String endpoint;
  late List<_CategoryGroupEntity> categoryGroups; // List of category groups
}

@RealmModel()
class _CategoryGroupEntity {
  //@PrimaryKey()
  late String groupName; // Each group has a unique name
  late List<_CategoryEntity>
      categoryEntities; // List of categories under this group
}

@RealmModel()
class _CategoryEntity {
  //@PrimaryKey()
  late int id; // Unique ID for the category
  late String category;
  late String title;
  late String? isFav;
  late List<_ContentDataEntity> cdataEntities;
}

@RealmModel()
class _ContentDataEntity {
  late String type;
  late String audiourl;
  late List<_LyricsEntity> lyricsEntities;
}

@RealmModel()
class _LyricsEntity {
  late String time;
  late String arabic;
  late String transliteration;
  late String translation;
}
