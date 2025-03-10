import 'package:realm/realm.dart';
part 'audio_download_mapping_entity.realm.dart';

@RealmModel()
class _AudioDownloadMapping {
  @PrimaryKey()
  late String audioName;
  late String audioUrl;

  late String audioDownloadPath;

  late String categoryName;
  late String categoryType;
}
