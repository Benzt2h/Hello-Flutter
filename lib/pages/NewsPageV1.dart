import 'package:flutter/material.dart';
import 'package:flutteronline/widgets/menu.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class NewsPage extends StatefulWidget {
  NewsPage({Key key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<dynamic> articles = [];
  int totalResults = 0;
  bool isLoading = true;
  _getData() async {
    try {
      var url =
          'https://newsapi.org/v2/top-headlines?country=th&apiKey=c871ffc5aa514d4dbc884ff7119ac268';
      var res = await http.get(url);
      if (res.statusCode == 200) {
        final Map<String, dynamic> news = convert.jsonDecode(res.body);
        setState(() {
          totalResults = news['totalResults'];
          articles = news['articles'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('error from backend ${res.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
        title: totalResults > 0 ? Text("ข่าว $totalResults ข่าว") : null,
        centerTitle: true,
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: articles.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, 'newsstack/webview',
                            arguments: {
                              'url': articles[index]['url'],
                              'name': articles[index]["source"]["name"]
                            });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 200,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                    child: articles[index]['urlToImage'] != null
                                        ? Ink.image(
                                            image: NetworkImage(
                                                articles[index]['urlToImage']),
                                            fit: BoxFit.cover,
                                          )
                                        : Ink.image(
                                            image: NetworkImage(
                                                'https://picsum.photos/500/200'),
                                            fit: BoxFit.cover,
                                          )),
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                  top: 16,
                                  child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        articles[index]["source"]["name"],
                                        style: TextStyle(color: Colors.white70),
                                      )),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(articles[index]['title']),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                    ),
                                    articles[index]['author'] != null
                                        ? Chip(
                                            avatar: Icon(Icons.person_pin),
                                            label: articles[index]['author']
                                                        .length <
                                                    20
                                                ? Text(
                                                    articles[index]['author'])
                                                : Text(articles[index]['author']
                                                    .substring(0, 20)),
                                          )
                                        : Text(''),
                                    Text(DateFormat.yMMMd().add_Hms().format(
                                        DateTime.parse(
                                            articles[index]["publishedAt"]))),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                );
              },
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
