import 'dart:developer';
import 'dart:io';

import 'package:allwork/services/local_notifications.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/views/main_menu_view.dart';
import 'package:allwork/views/menu_detail_view.dart';
import 'package:allwork/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'views/category_detail_view.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  await Firebase.initializeApp();

  //  handle in terminated state
  var initialNotification =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (initialNotification?.didNotificationLaunchApp == true) {
    // LocalNotifications.onClickNotification.stream.listen((event) {
    Future.delayed(Duration(seconds: 1), () {
      log("Message incoming");
    });
  }

  runApp(const MyApp());
  if (Platform.isAndroid || Platform.isIOS) {
    KeepScreenOn.turnOn();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Menu App',
      initialRoute: '/splash',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundBlue,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundBlue,
          iconTheme: IconThemeData(color: Colors.white, size: 24),
          elevation: 0,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: AppColors.backgroundBlue,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            // Set the predictive back transitions for Android.
            TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          },
        ),
      ),
      getPages: [
        GetPage(name: '/', page: () => const MainMenuView()),
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(
            name: '/menu-detail',
            page: () => MenuDetailView(
                  menuItem: '',
                  selectedLanguage: '',
                )),
        GetPage(
            name: '/category-detail', page: () => const CategoryDetailView()),
      ],
    );
  }
}
