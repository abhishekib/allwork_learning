import 'dart:developer';

import 'package:allwork/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/modals/category.dart';

class CategoryListView extends StatelessWidget {
  final List<Category> categoryItems;
  final String argument; // This field will store the menuItem value

  const CategoryListView(
      {super.key, required this.categoryItems, required this.argument});

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(argument), // Display the selected menu title here
        ),
        body: ListView.builder(
          itemCount: categoryItems.length,
          itemBuilder: (context, index) {
            final item = categoryItems[index];
            return ListTile(
              title: Text(item.title),
              onTap: () {
                log("Category List View------>${item.title}");
                Get.toNamed(
                  '/category-detail',
                  arguments: item,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
