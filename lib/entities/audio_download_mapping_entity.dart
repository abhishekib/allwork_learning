import 'package:realm/realm.dart';
part 'audio_download_mapping_entity.realm.dart';
@RealmModel()

class _AudioDownloadMapping {
  @PrimaryKey()
  late String audioUrl;

  late String audioDownloadPath;
}