import 'dart:developer';

import 'package:allwork/utils/constants.dart';
import 'package:dio/dio.dart';

class InstallProvider {
  final Dio _dio;
  final String token;
  final String baseurl = ApiConstants.baseUrl;
  final String endpoint = 'install-app';

  InstallProvider(this.token):_dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
        );


        Future<void> sendFCMToken(String fcmToken) async {
        try{
          String url = '$baseurl$endpoint';

          final response = await _dio.post(url, queryParameters: {'fcm_token': fcmToken} );
        
        if(response.statusCode == 200){
          log(response.data.toString());
          log("Token sent successfully");
        }}
        catch(e){
          throw Exception('Error sending FCM token: $e');
        }
}
}