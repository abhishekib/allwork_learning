import 'package:allwork/controllers/audio_controller.dart';
import 'package:allwork/controllers/audio_file_controller.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/audio_player_widget.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioFileView extends StatelessWidget {
  AudioFileView({super.key});

  final AudioFileController controller = Get.put(AudioFileController());

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Audio Files",
                style: AppTextStyles.whiteBoldTitleText,
              ),
            ),
            body: Obx(()=>
               controller.audioFiles.isEmpty
                  ? Center(
                      child: Text(
                        "No audio files found",
                        style: AppTextStyles.whiteBoldText,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                            itemCount: controller.audioFiles.length,
                            itemBuilder: (context, index) {
                              AudioController audioController = AudioController();
                              return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FittedBox(fit: BoxFit.scaleDown,
                                          child: Text(
                                              controller.extractAudioName(
                                                  controller.audioFiles[index]),
                                              style: AppTextStyles.whiteText),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            controller.deleteAudioFile(
                                                controller.audioFiles[index]);
                                          },
                                          child: Icon(Icons.delete,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                    subtitle: AudioPlayerWidget(
                                        audioUrl: controller.audioFiles[index],
                                        onPositionChanged: (currentPosition) {
                                          audioController.currentTime.value =
                                              currentPosition;
                                        },
                                        controller: audioController),
                                  ));
                            }),
                      
                    ),
            )));
  }
}
