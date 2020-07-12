import 'package:flutter/material.dart';
//import 'package:flutteronline/models/product.dart';
import 'package:flutteronline/widgets/menu.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  ProductPage({Key key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<dynamic> course = [];
  bool isLoading = true;

  _getData() async {
    var url = 'https://api.codingthailand.com/api/course';
    var res = await http.get(url);
    if (res.statusCode == 200) {
      final Map<String, dynamic> product = convert.jsonDecode(res.body);
      setState(() {
        course = product['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('error from backend ${res.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        title: Text("สินค้า"),
        centerTitle: true,
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: course.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('productstack/detail',
                        arguments: {
                          'id': course[index]['id'],
                          'title': course[index]['title']
                        });
                  },
                  title: Text(course[index]['title']),
                  subtitle: Text(course[index]['detail']),
                  trailing: Icon(Icons.arrow_right),
                  leading: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: NetworkImage(course[index]['picture']),
                          fit: BoxFit.cover,
                        )),
                  ),
                );
              },
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
