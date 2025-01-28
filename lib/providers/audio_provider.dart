import 'dart:developer';

import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class AudioProvider {
  final String token;
  final Dio _dio = Dio();
  final String baseurl = ApiConstants.baseUrl;

  AudioProvider(this.token);

  Future<String?> downloadAudio(String url, int contentDataId) async {
    try {
      final directory = await getTemporaryDirectory();
      final filePath = Uri.parse(url).path;
      final savePath = '${directory.path}/$filePath';

      await _dio.download(url, savePath, onReceiveProgress: (received, total) {
        if (total != -1) {
          double progress = (received / total) * 100;
          log("Download progress: ${progress.toStringAsFixed(0)}%");
        }
      });

//      DbServices.instance.saveOfflineCategoryDataAudio(savePath, contentDataId);

      return savePath;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
