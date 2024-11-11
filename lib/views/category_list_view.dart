import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/modals/category.dart';

class CategoryListView extends StatelessWidget {
  final List<Category> categoryItems;

  CategoryListView({required this.categoryItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: categoryItems.length,
        itemBuilder: (context, index) {
          final item = categoryItems[index];
          return ListTile(
            title: Text(item.title),
            onTap: () {
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
