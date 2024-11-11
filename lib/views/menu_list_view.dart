import 'dart:developer';

import 'package:allwork/views/menu_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/menu_list_controller.dart';

class MenuListView extends StatelessWidget {
  const MenuListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MenuListController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu List"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.menuList.value.items.isEmpty) {
          return const Center(child: Text("No menu items available"));
        } else {
          return ListView.builder(
            itemCount: controller.menuList.value.items.length,
            itemBuilder: (context, index) {
              final menuItem = controller.menuList.value.items[index];
              return ListTile(
                title: Text(menuItem),
                onTap: () {
                  log("selected ----> $menuItem");

                  Get.to(() => MenuDetailView(
                        menuItem: menuItem,
                      ));
                },
              );
            },
          );
        }
      }),
    );
  }
}
