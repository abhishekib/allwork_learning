import 'dart:developer';

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

  Future<EventPopupModel?> getEventPopup() async {
    final DateTime now = DateTime.now();
    final String date = now.day.toString();
    final String month = now.month.toString();

    try {
      final String completeUrl =
          '${ApiConstants.baseUrl}${ApiConstants.eventPopupEndpoint}?date=$date&month=$month';

      log('Complete URL: $completeUrl');

      final response = await _dio.post(
        ApiConstants.eventPopupEndpoint,
        queryParameters: {
          'date': date,
          'month': month,
        },
      );

      if (response.statusCode == 200) {
        return EventPopupModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch event popup');
      }
    } catch (e) {
      throw Exception('Error fetching event popup: $e');
    }
  }
}
