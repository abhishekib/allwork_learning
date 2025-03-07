import 'dart:io';

import 'package:allwork/firebase_options.dart';
import 'package:allwork/services/location_services.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/views/main_menu_view.dart';
import 'package:allwork/views/menu_detail_view.dart';
import 'package:allwork/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:upgrader/upgrader.dart';
import 'views/category_detail_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
*/
Future<void> main() async {
  bool fromNotification = false;
  WidgetsFlutterBinding.ensureInitialized();
  await LocationService.getUserLocation();
  //await LocalNotificationServices.init();
  OneSignal.initialize("30eecd80-d98f-439a-b5e5-ddf3fe6248ce");
  await OneSignal.Notifications.requestPermission(true);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferences.getInstance();
  await Upgrader.clearSavedSettings();

//Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission

/*
  var initialNotification =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

//if the app starts with click on notification
  if (initialNotification?.didNotificationLaunchApp == true) {
    fromNotification = true;

    Category category = CategoryHelpers.toCategory(DbServices.instance
        .getReminderData(initialNotification!.notificationResponse!.payload!)!
        .category!);

    Future.delayed(Duration(seconds: 1), () {
      Get.to(() => CategoryDetailView(), arguments: {
        'fromBookmark': false,
        'category': category,
        'language': 'English',
        'menuItem': category.category
      });
    });
  }

//listen to the stream of notification click event when the app is running
  
  LocalNotificationServices.onClickNotification.stream.listen((event) {
    log("Notification clicked");
    log(event);
    Category category = CategoryHelpers.toCategory(
        DbServices.instance.getReminderData(event)!.category!);

    Get.to(() => CategoryDetailView(), arguments: {
      'fromBookmark': false,
      'category': category,
      'language': 'English',
      'menuItem': category.category
    });
  });
*/

  runApp(MyApp(fromNotification: fromNotification));

  if (Platform.isAndroid || Platform.isIOS) {
    KeepScreenOn.turnOn();
  }
}

class MyApp extends StatelessWidget {
  bool fromNotification = false;
  MyApp({super.key, required this.fromNotification});

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
        GetPage(
            name: '/splash',
            page: () => SplashScreen(fromNotification: fromNotification)),
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
