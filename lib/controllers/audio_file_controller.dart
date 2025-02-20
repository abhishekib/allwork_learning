import 'dart:io';

import 'package:allwork/entities/audio_download_mapping_entity.dart';
import 'package:allwork/services/db_services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AudioFileController extends GetxController {
  RxList<AudioDownloadMapping> audioDownloadMappings =
      <AudioDownloadMapping>[].obs;

  @override
  void onInit() {
    audioDownloadMappings.value =
        DbServices.instance.getAudioDownloadMappings();
    super.onInit();
  }

  void deleteAudioFile(String audioDownloadpath) {
    audioDownloadMappings.removeWhere(
        (AudioDownloadMapping audioDownloadMapping) =>
            audioDownloadMapping.audioDownloadPath == audioDownloadpath);
    DbServices.instance.deleteAudioDownloadPath(audioDownloadpath);
    final file = File(audioDownloadpath);
    file.delete();
  }

  // String extractAudioName(String audioDownloadpath) {
  //   return audioDownloadpath.split('/').last;
  // }
}
