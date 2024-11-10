import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allwork/controllers/menu_list_controller.dart';

class MenuListView extends StatelessWidget {
  final MenuListController _controller = Get.put(MenuListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu List'),
      ),
      body: Obx(
        () {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: _controller.menuList.value.items.length,
              itemBuilder: (context, index) {
                var menuItem = _controller.menuList.value.items[index];
                return ListTile(
                  title: Text(menuItem),
                  onTap: () {
                    // Handle the navigation to category details for the selected menu item
                    Get.toNamed('/categoryDetail', arguments: menuItem);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
