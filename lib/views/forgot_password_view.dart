import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:allwork/widgets/labeled_input_field_widget.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatelessWidget {
  ForgotPasswordView({super.key});
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
        child: Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundBlue,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Forgot Password',
          style: AppTextStyles.whiteBoldTitleText,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            LabeledInputField(
              label: "Email",
              hintText: "enter your email..",
              controller: _textEditingController,
              isNotEditable: false,
            ),
            SizedBox(
              height: 10,
            ),
            LabeledInputField(
              label: "OTP",
              hintText: "enter your otp",
              controller: _textEditingController,
              isNotEditable: false,
            ),
            LabeledInputField(
              label: "New Password",
              hintText: "Enter New Password",
              controller: _textEditingController,
              isNotEditable: false,
            ),
          ],
        ),
      ),
    ));
  }
}
