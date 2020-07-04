import 'package:flutter/material.dart';
import 'package:flutteronline/models/room.dart';
//import 'package:flutteronline/models/product.dart';
import 'package:flutteronline/widgets/menu.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class RoomPage extends StatefulWidget {
  RoomPage({Key key}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  List<Room> room = [];
  bool isLoading = true;

  _getData() async {
    var url = 'https://codingthailand.com/api/get_rooms.php';
    var res = await http.get(url);
    if (res.statusCode == 200) {
      final Hotel hotel = Hotel.fromJson(convert.jsonDecode(res.body));
      setState(() {
        room = hotel.room;
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
              itemCount: room.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(room[index].name),
                  subtitle: Text(room[index].status),
                );
              },
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
