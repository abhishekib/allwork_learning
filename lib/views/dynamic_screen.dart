import 'dart:developer';

import 'package:allwork/views/category_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class DynamicScreen extends StatelessWidget {
  final String menuItem;
  final String selectedLanguage;
  final String title;
  final Map<String, dynamic> data;

  const DynamicScreen({super.key, required this.menuItem, required this.selectedLanguage, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: data.keys.length,
        itemBuilder: (context, index) {
          final key = data.keys.elementAt(index);
          final value = data[key];

          return ListTile(
            title: Text(key),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              log("Screen Tapped $key");
              if (value is Map<String, dynamic>) {
                // If the next level is a map, navigate to the same screen
                log("first level map");
                Get.to(
                    preventDuplicates: false,
                    () => DynamicScreen(title: key, data: value, menuItem: menuItem, selectedLanguage: selectedLanguage));
                // Navigator.push(context,MaterialPageRoute(
                //     builder: (context) =>
                //         DynamicScreen(title: key, data: value)));
              } else if (value is List<dynamic>) {
                log("first level list");
                // If it's a list, navigate to a content-specific screen
                Get.to(() => CategoryListView(argument: key, categoryItems: value, menuItem: menuItem, selectedLanguage: selectedLanguage));
              }
            },
          );
        },
      ),
    );
  }
}