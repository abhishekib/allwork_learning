import 'dart:io';

import 'package:allwork/utils/colors.dart';
import 'package:allwork/views/main_menu_view.dart';
import 'package:allwork/views/menu_detail_view.dart';
import 'package:allwork/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'views/category_detail_view.dart';
import 'package:timezone/data/latest.dart' as tz;

// Define the instance of the plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure widgets are initialized before running the app
  tz.initializeTimeZones(); // Initialize timezones

  // Initialize notifications
  await initNotifications();

  runApp(const MyApp());
  if (Platform.isAndroid || Platform.isIOS) {
    KeepScreenOn.turnOn();
  }
}

// Initialize the plugin with platform-specific settings
Future<void> initNotifications() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'general_notifications', // Channel ID (used to reference the notification channel)
    'General Notifications', // Channel Name (used to display the channel name in the system)
    channelDescription:
        'Notifications for reminders', // Channel description (helpful for understanding the purpose of this channel)
    importance: Importance
        .high, // Set the importance level of the notification (options: low, default, high)
    priority: Priority
        .high, // Set the priority of the notification (options: low, default, high)
    ticker:
        'ticker', // Optional: Ticker text (this text is shown briefly when the notification is delivered)
    playSound:
        true, // Optional: To play a sound when the notification is triggered
    sound: RawResourceAndroidNotificationSound(
        'notification_sound'), // Optional: Custom sound from the app's raw resources
    largeIcon: DrawableResourceAndroidBitmap(
        'app_icon'), // Optional: Add a large icon to the notification
    // Other customizations (e.g., vibration pattern, lights) can be set here as well
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          'app_icon'); // 'app_icon' is your app's icon file

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    //iOS: IOSInitializationSettings(),
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
