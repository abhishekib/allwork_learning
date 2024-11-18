import 'package:get/get.dart';
import 'package:allwork/providers/password_update_provider.dart';

class PasswordUpdateController extends GetxController {
  final isLoading = false.obs;
  final passwordUpdateMessage = ''.obs;
  final PasswordUpdateProvider _passwordUpdateProvider =
      PasswordUpdateProvider();

  Future<void> updatePassword(String userId, String oldPassword,
      String newPassword, String confirmPassword) async {
    try {
      isLoading(true);
      String message = await _passwordUpdateProvider.updatePassword(
          userId, oldPassword, newPassword, confirmPassword);
      passwordUpdateMessage.value = message;
    } catch (e) {
      print('Error updating password: $e');
    } finally {
      isLoading(false);
    }
  }
}
