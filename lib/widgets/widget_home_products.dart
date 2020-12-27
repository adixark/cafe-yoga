import 'package:cafe_yoga/Models/product.dart';
import 'package:cafe_yoga/utils/api_services.dart';
import 'package:flutter/material.dart';
import 'package:cafe_yoga/pages/product_details.dart';

class WidgetHomeProducts extends StatefulWidget {
  @override
  _WidgetHomeProductsState createState() => _WidgetHomeProductsState();

  String labelName;
  String tagId;

  WidgetHomeProducts({Key key, this.labelName, this.tagId});
}

class _WidgetHomeProductsState extends State<WidgetHomeProducts> {
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
      color: const Color(0xffF4F7FA),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, top: 4),
                child: Text(
                  this.widget.labelName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, top: 4),
                child: FlatButton(
                  onPressed: () {},
                  child: Text(
                    "View all",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          _productslist(),
        ],
      ),
    );
  }

  Widget _productslist() {
    return new FutureBuilder(
      future: apiService.getProducts(tagName: this.widget.tagId),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Product>> model, //ignore xare
      ) {
        if (model.hasData) {
          return _buildlist(model.data);
        }
        return Center(
          heightFactor: 4,
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildlist(List<Product> items) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(),
          ),
        );
      },
      child: Container(
        height: 210,
        alignment: Alignment.centerLeft,
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              var data = items[index];
              return Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      width: 120,
                      height: 120,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 5),
                                blurRadius: 15),
                          ],
                          image: DecorationImage(
                              image: NetworkImage(
                                data.images[0].src,
                              ),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      width: 130,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        data.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                        width: 130,
                        margin: EdgeInsets.only(top: 4, left: 4),
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Text(
                                "₹ ${data.regularPrice}",
                                style: TextStyle(
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "₹ ${data.salePrice}",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
