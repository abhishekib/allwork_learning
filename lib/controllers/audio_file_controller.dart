import 'dart:io';

import 'package:allwork/services/db_services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AudioFileController extends GetxController {
  RxList<String> audioFiles = <String>[].obs;

  @override
  void onInit() {
    audioFiles.value = DbServices.instance.getAudioDownloadPaths();
    super.onInit();
  }

  void deleteAudioFile(String audioDownloadpath) {
    audioFiles.remove(audioDownloadpath);
    DbServices.instance.deleteAudioDownloadPath(audioDownloadpath);
    final file = File(audioDownloadpath);
    file.delete();
  }

  String extractAudioName(String audioDownloadpath) {
    return audioDownloadpath.split('/').last;
  }
}
