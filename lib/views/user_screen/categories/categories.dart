import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsewa/views/user_screen/categories/services.dart';
import '../../../network/services/categories&services/categories_controller.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List images = [
    "assets/category_image/Electician.jpg",
    "assets/category_image/Plumber.jpg",
    "assets/category_image/Masonry.jpg",
    "assets/category_image/Cleaning.jpg",
    "assets/category_image/Catering _ Rent.jpg",
    "assets/category_image/Tuition _ Language classes.jpg",
    "assets/category_image/Music and Dance classes.jpg",
    "assets/category_image/Paint _ Painting.jpg",
    "assets/category_image/Gardener.jpg",
    "assets/category_image/Health medicine _ Pathology.jpg",
    "assets/category_image/Veterinary.jpg",
    "assets/category_image/Fitness, yoga, med.jpg",
    "assets/category_image/Cook, Waiter, Kitchen helper.jpg",
    "assets/category_image/Home care staff.jpg",
    "assets/category_image/Books _ Stationery.jpg",
    "assets/category_image/Printing _ Press.jpg",
    "assets/category_image/waste management.jpg",
    "assets/category_image/Catering _ Rent.jpg",
    "assets/category_image/Furniture, Home decor _ Wallpaper.jpg",
    "assets/category_image/Transportation _ vehicle Rent.jpg",
    "assets/category_image/Travel _ Tour.jpg",
    "assets/category_image/Training _ skill program.jpg",
    "assets/category_image/Event _ Party Planner.jpg",
    "assets/category_image/Engineering.jpg",
    "assets/category_image/Office Staff.jpg",
    "assets/category_image/Advertisement _ Promotion_3.jpg",
    "assets/category_image/Others.jpg",
  ];
  final controller = Get.put(CatController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Obx(
              () {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: controller.products.length,
                    itemBuilder: (context, index) {
                      final product = controller.products[index];
                      return InkWell(
                        onTap: () {
                          Get.to(ServicesScreen(
                            name: product.categoryTitle.toString(),
                            id: product.categoryId.toString(),
                          ));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 18),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                  image: AssetImage(images[index]),
                                  fit: BoxFit.cover)),
                          height: 120,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  "${product.categoryTitle}",
                                  style: const TextStyle(
                                    fontFamily: 'hello',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                )),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
