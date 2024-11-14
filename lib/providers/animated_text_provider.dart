import 'dart:developer';

import 'package:allwork/modals/animated_text.dart';
import 'package:dio/dio.dart';
import '../utils/constants.dart';

class AnimatedTextProvider {
  final Dio _dio;

  AnimatedTextProvider(String token)
      : _dio = Dio(
          BaseOptions(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ),
        );

  Future<List<AnimatedText>> fetchTextData() async {
    try {
      // Make the GET request with the complete URL from the constant
      final response = await _dio.get(ApiConstants.animatedText);

      if (response.statusCode == 200) {
        final data = response.data;
        log("----------> Received data: $data");

        // Parse the response into the MessageModel
        MessageModel message = MessageModel.fromJson(data['message']);
        return message.animatedText; // Return the animated text list
      } else {
        log('Failed to fetch text data, status code: ${response.statusCode}');
        throw Exception('Failed to fetch text data');
      }
    } catch (e) {
      log('Error fetching text data: $e');
      throw Exception('Error fetching text data');
    }
  }
}
