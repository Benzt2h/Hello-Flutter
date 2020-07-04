import 'package:flutter/material.dart';
import 'package:flutteronline/models/detail.dart';
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
  List<Chapter> chapter = [];
  bool isLoading = true;
  final fNumber = NumberFormat('#,###');

  _getData(int id) async {
    var url = 'https://api.codingthailand.com/api/course/$id';
    var res = await http.get(url);
    if (res.statusCode == 200) {
      final Detail detail = Detail.fromJson(convert.jsonDecode(res.body));
      setState(() {
        chapter = detail.chapter;
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
                  title: Text(chapter[index].chTitle),
                  subtitle: Text(chapter[index].chDateadd),
                  trailing: Chip(
                    label: Text('${fNumber.format(chapter[index].chView)}'),
                    backgroundColor: Colors.purpleAccent,
                  ),
                );
              },
            ),
    );
  }
}
