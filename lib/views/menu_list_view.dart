import 'package:allwork/controllers/menu_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuListView extends StatelessWidget {
  MenuListView({super.key});
  final MenuListController controller = Get.put(MenuListController());

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Menu List"),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: controller.menuList.value.items.length,
              itemBuilder: (context, index) {
                final items = controller.menuList.value.items[index];
                final endpoint = controller.itemEndpoints[items] ?? '';
                return ListTile(
                  title: Text(items),
                  onTap: () {
                    Get.toNamed(
                      '/menuDetail',
                      arguments: {
                        'title': items,
                        'endpoint': endpoint,
                      },
                    );
                  },
                );
              },
            );
          }
        }),
      ),
    );
  }
}
