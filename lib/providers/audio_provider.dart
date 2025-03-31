import 'dart:developer';

import 'package:allwork/services/db_services.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class AudioProvider {
  final Dio _dio = Dio();

  Future<String?> downloadAudio({
    required String url,
    required String categoryName,
    required String categoryType,
    required Function(double) onProgress,
    required CancelToken cancelToken,
  }) async {
    try {
      final directory = await getTemporaryDirectory();
      final fileName = url.split('/').last;
      final savePath = '${directory.path}/$fileName';

      await _dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            onProgress(progress);
          }
        },
      );

      await DbServices.instance
          .writeAudioDownloadPath(url, savePath, categoryName, categoryType);

      return savePath;
    } catch (e) {
      log('Download error: $e');
      return null;
    }
  }
}
