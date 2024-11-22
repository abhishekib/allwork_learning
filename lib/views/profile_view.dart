import 'package:allwork/controllers/login_controller.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/profile_view_change_password.dart';
import 'package:allwork/views/signup_view.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final LoginController loginController = Get.put(LoginController());

  // Define Rx variables to observe the email and password
  final RxString userEmail = ''.obs;
  final RxString userPassword = ''.obs;

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userEmail.value = prefs.getString('userEmail') ?? '';
    userPassword.value = prefs.getString('userPass') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    // Load user data when the widget is built
    _loadUserData();

    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: AppColors.backgroundBlue,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.backgroundBlue,
          title: Text(
            "Profile",
            style: AppTextStyles.whiteBoldText,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50.0,
                  child: Text(
                    loginController
                        .loginResponse.value?.message.data.displayName[0] ?? '',
                    style: TextStyle(
                      fontSize: 30.0,
                      color: AppColors.backgroundBlue,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Name field (readonly)
                TextField(
                  enabled: false,
                  controller: TextEditingController(text:
                  loginController.loginResponse.value?.message.data.displayName ?? ''),
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: TextStyle(color: Colors.white70),
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),  // White underline color
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                // Email field (reactively updated)
                Obx(() => TextField(
                  enabled: false,
                  controller: TextEditingController(text: userEmail.value),
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.white70),
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),  // White underline color
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                )),
                SizedBox(height: 20.0),
                // Password field (reactively updated)
                Obx(() => TextField(
                  enabled: false,
                  controller: TextEditingController(text: userPassword.value),
                  obscureText: true,  // Hide the password text
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    suffixIcon: Icon(CupertinoIcons.eye_slash,color: Colors.white,),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white70),
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),  // White underline color
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                )),
                SizedBox(height: 20.0),

                GestureDetector(
                  onTap: ()=> Get.to(ChangePassword()),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                      child: Text("Forget Password ?",style: AppTextStyles.whiteText,)

                  ),
                ),
                SizedBox(height: 80.0),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(  // Wrap the button in Expanded to take available space
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),  // Add some space between buttons
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your save logic here
                          },
                          child: Text("Update"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.backgroundBlue,
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
                            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Expanded(  // Wrap the second button in Expanded to take available space
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),  // Add space to the left of this button
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);  // Go back to the previous screen
                          },
                          child: Text("Cancel"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.backgroundBlue,
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
                            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
