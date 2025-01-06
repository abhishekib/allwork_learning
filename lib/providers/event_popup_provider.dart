import 'dart:developer';

import 'package:allwork/modals/amal_namaz_popup_model.dart';
import 'package:allwork/modals/event_popup_model.dart';
import 'package:dio/dio.dart';
import 'package:allwork/utils/constants.dart';

class EventPopupProvider {
  final Dio _dio;
  final String token;

  EventPopupProvider(this.token)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
        );

  Future<AmalNamazPopupModel?> getEventPopup() async {
    try {
      final String completeUrl =
          '${ApiConstants.baseUrl}${ApiConstants.amalNamazPopupEndpoint}';

      log('Complete URL: $completeUrl');

      final response = await _dio.post(
        ApiConstants.amalNamazPopupEndpoint,
      );

      if (response.statusCode == 200) {
        return AmalNamazPopupModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch event popup');
      }
    } catch (e) {
      throw Exception('Error fetching event popup: $e');
    }
  }
}
