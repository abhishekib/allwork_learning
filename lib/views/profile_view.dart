import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/profile_view_change_password.dart';
import 'package:allwork/widgets/background_wrapper.dart';
import 'package:allwork/widgets/labeled_input_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/user_info_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  final UserInfoController _userInfoController = Get.put(UserInfoController());

  bool isNotEditable = true; // Default to be non-editable

  @override
  void initState() {
    super.initState();
    _userInfoController.fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: AppColors.backgroundBlue,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundBlue,
          title: const Text(
            "Profile",
            style: AppTextStyles.whiteBoldTitleText,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        body: Obx(
          () {
            if (_userInfoController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (_userInfoController.errorMessage.isNotEmpty) {
              return Center(
                  child: Text(_userInfoController.errorMessage.value));
            } else {
              final userInfo = _userInfoController.userInfo.value;
              if (userInfo == null) {
                return Center(
                    child: Text(
                  "No user info available",
                  style: AppTextStyles.whiteBoldText,
                ));
              } else {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Text(
                            "${userInfo.firstName.isNotEmpty ? userInfo.firstName[0] : ''}${userInfo.lastName.isNotEmpty ? userInfo.lastName[0] : ''}"
                                .toUpperCase(),
                            style: TextStyle(
                              color: AppColors.backgroundBlue,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      LabeledInputField(
                        label: "First Name",
                        hintText: "Enter First Name",
                        controller: _userInfoController.firstNameController,
                        isNotEditable: isNotEditable,
                      ),
                      const SizedBox(height: 10),
                      LabeledInputField(
                        label: "Last Name",
                        hintText: "Enter Last Name",
                        controller: _userInfoController.lastNameController,
                        isNotEditable: isNotEditable,
                      ),
                      const SizedBox(height: 10),
                      LabeledInputField(
                        label: "Gender",
                        hintText: "Enter Gender",
                        controller: _userInfoController.genderController,
                        isNotEditable: isNotEditable,
                      ),
                      const SizedBox(height: 10),
                      LabeledInputField(
                        label: "Phone",
                        hintText: "Enter Phone Number",
                        controller: _userInfoController.phoneController,
                        isNotEditable: isNotEditable,
                      ),
                      const SizedBox(height: 10),
                      LabeledInputField(
                        label: "Email",
                        hintText: "Enter Email",
                        controller: _userInfoController.emailController,
                        isNotEditable: true, // Email should not be editable
                      ),
                      Center(
                          child: ElevatedButton(
                              onPressed: () {
                                Get.to(() => ChangePassword());
                              },
                              child: Text("Update Password"))),
                      const SizedBox(height: 30),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (isNotEditable) {
                                  // Enable editing mode
                                  setState(() {
                                    isNotEditable = false;
                                  });
                                } else {
                                  // Save updated data
                                  _userInfoController.updateUserInfo();
                                  setState(() {
                                    isNotEditable = true;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                              ),
                              child: Text(
                                isNotEditable ? "Update" : "Save",
                                style: TextStyle(
                                  color: AppColors.backgroundBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (!isNotEditable) {
                                  // Cancel editing mode
                                  setState(() {
                                    isNotEditable = true;
                                  });
                                  _userInfoController.resetFields();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
