import 'package:flutter/material.dart';
import 'package:footwear_client/controller/home_controller.dart';
import 'package:footwear_client/pages/login_page.dart';
import 'package:footwear_client/widgets/drop_down_btn.dart';
import 'package:footwear_client/widgets/multi_select_drop_down.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../widgets/product_card.dart';
import 'product_description_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: ()async{
          ctrl.fetchProducts();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                'Footware Store',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            actions: [
              IconButton(onPressed: () {
                GetStorage box = GetStorage();
                box.erase();
                Get.offAll(LoginPage());
              }, icon: Icon(Icons.logout)),
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ctrl.productCategories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          ctrl.filterByCategory(ctrl.productCategories[index].name ?? '');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Chip(label: Text(ctrl.productCategories[index].name ?? 'Error' )),
                        ),
                      );
                    }),
              ),
              Row(
                children: [
                  Flexible(
                    child: DropDownBtn(
                      items: ['Rs: low to high', 'Rs:High to low'],
                      selectedItemText: 'Sort',
                      onSelected: (selected) {
                        ctrl.sortByPrice(ascending:  selected == 'Rs: low to high' ? true : false);
                      },
                    ),
                  ),
                  Flexible(
                      child: MultiSelectDropDown(
                        items: ['Sketchers', 'Adidas', 'Puma', 'Nike'],
                        onSelectionChanged: (selectedItems) {
                          ctrl.filterByBrand(selectedItems);
                        },
                      ))
                ],
              ),
              Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8
                    ),
                    itemCount: ctrl.products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        name: ctrl.productShowInUi[index].name ?? 'No name',
                        imageurl: ctrl.productShowInUi[index].image ?? 'url',
                        price: ctrl.productShowInUi[index].price ?? 00,
                        offerTag: '30 % off',
                        onTap: () {
                          Get.to(ProductDescriptionPage(),arguments: {'data': ctrl.productShowInUi[index]});
                        },
                      );
                    }),
              )
        
            ],
          ),
        ),
      );
    });
  }
}