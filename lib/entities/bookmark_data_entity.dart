import 'package:realm/realm.dart';
part 'bookmark_data_entity.realm.dart';

@RealmModel()
class _BookmarkDataEntity{
  late String title;
  _CategoryEntity? category;

}

@RealmModel()
class _CategoryEntity {
  late String category;
  late int id;
  late String title;
  late String isFav;
  late List<_ContentDataEntity> contentData; 
}

@RealmModel()
class _ContentDataEntity {
  late String type;
  late String audiourl;
  late String offlineAudioPath;
  late List<_LyricsEntity> lyrics;
}

@RealmModel()
class _LyricsEntity {
  late String time;
  late String arabic;
  late String translitration;
  late String translation;
}