import 'package:flutter/material.dart';
import 'package:allwork/utils/colors.dart';

class SearchBarWidget extends StatelessWidget {
  // final TextEditingController searchController;
  // final ValueChanged<String> onSearch;

  const SearchBarWidget({
    super.key,
    // required this.searchController,
    // required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        // controller: searchController,
        // onChanged: onSearch,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          hintText: 'Search...',
          fillColor: Colors.white,
          filled: true,
          enabled: false,
          
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
      ),
    );
  }
}
