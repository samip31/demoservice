import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsewa/views/user_screen/drawer%20screen/map_Screen.dart';

import '../../network/services/categories&services/service_controller.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final searchController = TextEditingController();
  final cat = Get.put(ServicesController());
  List services = ServicesController().products;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, top: 18, right: 18, left: 18),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _searchBar(),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: searchController.text.isEmpty
                  ? const Center(child: Text('Type your search here.'))
                  : ListView.builder(
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Get.to(() => MapScreen(
                                work: services[index].category.categoryTitle,
                                name: services[index].name));
                          },
                          child: Container(
                            padding: const EdgeInsetsDirectional.all(18),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.blue.shade50,
                            ),
                            child: Text(
                              services[index].name.toString(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  searchbook(String query) {
    final suggestions = cat.products.where((item) {
      final name = item.name?.toLowerCase();
      final input = query.toLowerCase();
      return name?.contains(input) ?? false;
    }).toList();
    setState(() {
      services = suggestions;
    });
  }

  _searchBar() {
    return TextField(
      onChanged: searchbook,
      controller: searchController,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              searchController.clear();
            });
          },
          icon: const Icon(Icons.clear),
        ),
        prefixIcon: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}
