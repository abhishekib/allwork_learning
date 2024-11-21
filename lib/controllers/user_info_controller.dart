import 'package:allwork/modals/user_info.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:allwork/providers/user_info_provider.dart';

class UserInfoController extends GetxController {
  final isLoading = false.obs;
  final userInfo = Rx<UserInfo?>(null);
  final UserInfoProvider _userInfoProvider = UserInfoProvider();

  Future<void> fetchUserInfo(String userId) async {
    try {
      isLoading(true);
      UserInfo fetchedInfo = await _userInfoProvider.fetchUserInfo(userId);
      userInfo.value = fetchedInfo;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user info: $e');
      }
    } finally {
      isLoading(false);
    }
  }
}
