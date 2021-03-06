import 'package:flutter/material.dart';
//import 'package:flutteronline/models/detail.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic> course;
  List<dynamic> chapter = [];
  bool isLoading = true;
  final fNumber = NumberFormat('#,###');

  _getData(int id) async {
    var url = 'https://api.codingthailand.com/api/course/$id';
    var res = await http.get(url);
    if (res.statusCode == 200) {
      final Map<String, dynamic> detail = convert.jsonDecode(res.body);
      setState(() {
        chapter = detail['data'];
        isLoading = false;
      });
    } else {
      print('error from backend ${res.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getData(course['id']);
    });
  }

  @override
  Widget build(BuildContext context) {
    course = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('${course['title']}'),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: chapter.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(chapter[index]['ch_title']),
                  subtitle: Text(chapter[index]['ch_dateadd']),
                  trailing: Chip(
                    label: Text('${fNumber.format(chapter[index]['ch_view'])}'),
                    backgroundColor: Colors.purpleAccent,
                  ),
                );
              },
            ),
    );
  }
}
