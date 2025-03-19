
import 'package:allwork/controllers/search_custom_controller.dart';
import 'package:allwork/modals/category.dart';
import 'package:allwork/services/TextCleanerService.dart';
import 'package:allwork/utils/colors.dart';
import 'package:allwork/utils/styles.dart';
import 'package:allwork/views/category_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatelessWidget {
  final SearchCustomController searchController =
      Get.put(SearchCustomController());

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchControllerInput = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final keywords = searchControllerInput.text.trim();
              if (keywords.isNotEmpty) {
                searchController.fetchSearchResults(
                  keywords: keywords,
                  page: 1,
                );
              } else {
                Get.snackbar(
                  'Error',
                  'Please enter a search term.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: searchControllerInput,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: 'Search...',
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: AppColors.backgroundBlue),
                ),
              ),
              style: const TextStyle(fontSize: 16.0, color: Colors.black),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  searchController.fetchSearchResults(
                    keywords: value.trim(),
                    page: 1,
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    'Please enter a search term.',
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Colors.white,
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            // Results Section
            Expanded(
              child: Obx(() {
                if (searchController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }

                if (!searchController.hasSearched.value) {
                  // First visit state
                  return const Center(
                    child: Text(
                      "Start searching by entering a keyword above.",
                      style: AppTextStyles.whiteBoldText,
                    ),
                  );
                }

                final results = searchController.apiResponse.value.posts;
                if (results == null || results.isEmpty) {
                  return Center(
                    child: Text(
                      "No results found.",
                      style: AppTextStyles.whiteBoldText,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final post = results[index];
                    final title = post.title ?? 'Untitled';
                    final postType = post.postType ?? 'Unknown Type';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(TextCleanerService.cleanText(title)),
                        subtitle: Text(TextCleanerService.cleanText(postType)),
                        onTap: () {
                          // Navigate to CategoryDetailView with required arguments
                          //log("postType in search page ${postType}");
                          Get.to(
                            () => const CategoryDetailView(),
                            arguments: {
                              'category': Category(
                                category: postType,
                                id: post.id,
                                title: post.title,
                                isFav: "No",
                                cdata: post.cdata,
                              ),
                              'language': postType.endsWith('-gujarati')?'ગુજરાતી':'English',
                              'menuItem': postType,
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
