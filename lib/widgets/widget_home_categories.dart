import 'package:cafe_yoga/api_services.dart';
import 'package:cafe_yoga/pages/product_page.dart';
import 'package:flutter/material.dart';
import 'package:cafe_yoga/Models/category.dart' as categoryModel;

class WidgetCategories extends StatefulWidget {
  @override
  _WidgetCategoriesState createState() => _WidgetCategoriesState();
}

class _WidgetCategoriesState extends State<WidgetCategories> {
  APIService apiService;

  @override
  void initState() {
    // TODO: implement initState
    apiService = new APIService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 16, right: 14),
                child: Text(
                  "All Categories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 16, right: 14),
                child: Text(
                  "View all",
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
          _categoriesList(),
        ],
      ),
    );
  }

  Widget _categoriesList() {
    return new FutureBuilder(
      future: apiService.getCategories(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<categoryModel.Category>> model, //ignore xare
      ) {
        if (model.hasData) {
          return _buildCategoryList(model.data);
        }
        return Center(
          heightFactor: 4,
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildCategoryList(List<categoryModel.Category> categories) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      height: 150,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            var data = categories[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductPage(
                      categoryId: data.categoryId,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      width: 80,
                      height: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 5),
                                blurRadius: 15),
                          ],
                          image: DecorationImage(
                              image: NetworkImage(
                                data.image.url,
                              ),
                              fit: BoxFit.cover)),
                    ),
                    Row(
                      children: [
                        Text(data.categoryName.toString()),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 10,
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
