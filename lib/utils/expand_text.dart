import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class ExpandText extends StatefulWidget {
  String labelHeader;
  String desc;
  String shortDesc;

  ExpandText({
    Key key,
    this.labelHeader,
    this.desc,
    this.shortDesc,
  }) : super(key: key);

  @override
  _ExpandTextState createState() => _ExpandTextState();
}

class _ExpandTextState extends State<ExpandText> {
  bool descTextShowFlag = false;

  @override
  void initState() {
    // TODO: implement initState
    print(this.widget.shortDesc);
    super.initState();
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            this.widget.labelHeader,
            style: TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Html(
            data: descTextShowFlag ? this.widget.desc : this.widget.shortDesc,
            style: {
              "div": Style(
                  padding: EdgeInsets.only(top: 5), fontSize: FontSize.medium)
            },
          ),
          Align(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  descTextShowFlag = !descTextShowFlag;
                });
              },
              child: Text(
                descTextShowFlag ? "Show Less" : "Show More",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
