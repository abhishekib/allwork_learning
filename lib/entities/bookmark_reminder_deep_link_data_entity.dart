import 'package:realm/realm.dart';
part 'bookmark_reminder_deep_link_data_entity.realm.dart';

@RealmModel()
class _BookmarkDataEntity {
  @PrimaryKey()
  late String title;
  _CategoryEntity? category;
  late int lyricsType;
  late int lyricsIndex;
}

@RealmModel()
class _ReminderDataEntity {
  @PrimaryKey()
  late String title;
  _CategoryEntity? category;
}

@RealmModel()
class _DeepLinkDataEntity{
  @PrimaryKey()
  late String endpoint;
  _CategoryEntity? category;
}

@RealmModel()
class _CategoryEntity {
  late String category;
  late String postType;
  late int id;
  late String title;
  late String link;
  late String isFav;
  late List<_ContentDataEntity> cData;
  late String data;
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
  late String english;
}
