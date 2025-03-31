import 'dart:developer';
import 'dart:io';

import 'package:allwork/controllers/audio_controller.dart';
import 'package:allwork/entities/audio_download_mapping_entity.dart';
import 'package:allwork/services/db_services.dart';
import 'package:get/get.dart';

class AudioFileController extends GetxController {
  RxList<AudioDownloadMapping> audioDownloadMappings =
      <AudioDownloadMapping>[].obs;

  List<AudioController> audioControllers = [];

  @override
  void onInit() {
    log("on init called");
    _loadDownloadedAudio();
    super.onInit();
  }

  Future<void> _loadDownloadedAudio() async {
    try {
      final mappings = DbServices.instance.getAudioDownloadMappings();
      audioDownloadMappings.assignAll(mappings);
      // Create new controllers for each mapping
      audioControllers.clear();
      audioControllers.addAll(mappings.map((_) => AudioController()).toList());
    } catch (e) {
      log('Error loading audio mappings: $e');
    }
  }

  /* void deleteAudioFile(String audioDownloadpath) {
    log(audioDownloadpath);

    log("audio controllers initial length ${audioControllers.length.toString()}");
    //get audio download path
    AudioDownloadMapping audioDownloadMapping = audioDownloadMappings
        .firstWhere((AudioDownloadMapping audioDownloadMapping) =>
            audioDownloadMapping.audioDownloadPath == audioDownloadpath);

    ///get index of audio download path
    int index = audioDownloadMappings.indexOf(audioDownloadMapping);

    log(index.toString());

    //if audio is running stop it
    AudioController controller = audioControllers[index];

    controller.onClose();

    audioControllers = [];

    log("audio controllers length after removal ${audioControllers.length.toString()}");

    audioDownloadMappings.remove(audioDownloadMapping);

    DbServices.instance.deleteAudioDownloadPath(audioDownloadpath);

    log("audio download mappings getting reset ${audioDownloadMappings.length.toString()}");

    final file = File(audioDownloadpath);
    file.delete();
  } */

  Future<void> deleteAudioFile(String audioDownloadPath) async {
    try {
      final index = audioDownloadMappings.indexWhere(
        (m) => m.audioDownloadPath == audioDownloadPath,
      );

      if (index != -1) {
        // Stop and dispose the controller
        audioControllers[index].onClose();
        audioControllers.removeAt(index);

        // Delete from database
        await DbServices.instance.deleteAudioDownloadPath(audioDownloadPath);

        // Delete physical file
        await File(audioDownloadPath).delete();

        // Refresh the list
        await _loadDownloadedAudio();
      }
    } catch (e) {
      log('Error deleting audio: $e');
      Get.snackbar('Error', 'Failed to delete audio file');
    }
  }

  // String extractAudioName(String audioDownloadpath) {
  //   return audioDownloadpath.split('/').last;
  // }

/*   @override
  InternalFinalCallback<void> get onDelete {
    log("On delete called");
    for (var controller in audioControllers) {
      controller.onClose();
    }
    return super.onDelete;
  } */

  @override
  void onClose() {
    for (final controller in audioControllers) {
      controller.onClose();
    }
    super.onClose();
  }
}
