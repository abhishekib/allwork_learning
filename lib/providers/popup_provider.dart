import 'dart:developer';

import 'package:allwork/modals/amal_namaz_popup_model.dart';
import 'package:allwork/modals/event_popup_model.dart';
import 'package:dio/dio.dart';
import 'package:allwork/utils/constants.dart';

class PopupProvider {
  final Dio _dio;
  final String token;

  PopupProvider(this.token)
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
    final String date = now.day.toString(); //now.day.toString();
    final String month = now.month.toString(); //now.month.toString();
    try {
      final String completeUrl =
          '${ApiConstants.baseUrl}${ApiConstants.eventPopupEndpoint}';

      log('Complete URL: $completeUrl');

      final response = await _dio.post(
        ApiConstants.eventPopupEndpoint,
        queryParameters: {
          'date': date,
          'month': month,
        },
      );

      if (response.statusCode == 200) {
        log("response from Event Response Popup Endpoint${response.data}");
        return EventPopupModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch event popup');
      }
    } catch (e) {
      throw Exception('Error fetching event popup: $e');
    }
  }

  Future<AmalNamazPopupModel?> getAmalNamazPopup() async {
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
