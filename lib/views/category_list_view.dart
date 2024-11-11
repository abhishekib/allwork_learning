import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/modals/category.dart';

class CategoryListView extends StatelessWidget {
  final List<Category> categoryItems;

  const CategoryListView({super.key, required this.categoryItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: categoryItems.length,
        itemBuilder: (context, index) {
          final item = categoryItems[index];
          return ListTile(
            title: Text(item.title),
            onTap: () {
              log(item.title);
              Get.toNamed(
                '/category-detail',
                arguments: item,
              );
            },
          );
        },
      ),
    );
  }
}
