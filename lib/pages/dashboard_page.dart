import 'package:cafe_yoga/config.dart';
import 'package:cafe_yoga/widgets/widget_home_categories.dart';
import 'package:cafe_yoga/widgets/widget_home_products.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            imageCarousel(context),
            WidgetCategories(),
            WidgetHomeProducts(
              labelName: "Top Rated",
              tagId: Config.toprated,
            ),
            WidgetHomeProducts(
              labelName: "Subscription Based ",
              tagId: Config.subscriptionbased,
            ),
          ],
        ),
      ),
    );
  }

  Widget imageCarousel(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3 < 300
          ? MediaQuery.of(context).size.height / 3
          : 350,
      child: new Carousel(
        overlayShadow: false,
        borderRadius: true,
        boxFit: BoxFit.none,
        autoplay: true,
        dotSize: 5,
        images: [
          AspectRatio(
              aspectRatio: 16 / 9,
              child: Image(
                image: NetworkImage(
                    "https://cafe-yoga.com/wp-content/uploads/5f5d99dec2bcb-1.jpg"),
                fit: BoxFit.fill,
              )),
          AspectRatio(
              aspectRatio: 16 / 9,
              child: Image(
                image: NetworkImage(
                    "https://cafe-yoga.com/wp-content/uploads/istockphoto-1082589280-612x612-2.jpg"),
                fit: BoxFit.fill,
              )),
          AspectRatio(
              aspectRatio: 16 / 9,
              child: Image(
                image: NetworkImage(
                    "https://cafe-yoga.com/wp-content/uploads/5f5d9af7949db-1.jpg"),
                fit: BoxFit.fill,
              )),
          AspectRatio(
              aspectRatio: 16 / 9,
              child: Image(
                image: NetworkImage(
                    "https://cafe-yoga.com/wp-content/uploads/letsgo.png"),
                fit: BoxFit.fill,
              )),
        ],
      ),
    );
  }
}
