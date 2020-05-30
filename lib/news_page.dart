import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:online_khabar/Pages/single_news_page.dart';
import 'package:online_khabar/home.dart';

import 'models/news.dart';

class NewsPage extends StatefulWidget {
  final Function func;

  NewsPage({this.func});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  QuerySnapshot newsDataFuture;

  @override
  void initState() {
    super.initState();
    getNews();
  }

  Future<QuerySnapshot> getNews() async {
    var snapshot =
        await Firestore.instance.collection("collection").getDocuments();
    return snapshot;
  }

  buildNewsTiles() {
    return StreamBuilder(
      stream: newsRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SpinKitFadingCircle(
            color: Color(0xffa549eb),
          );
        }
        List<NewsTile> newsTiles = [];
        snapshot.data.documents.forEach((doc) {
          News news = News.fromDocuments(doc);
          print(news);
          NewsTile newsTile = NewsTile(
            news: news,
          );
          newsTiles.add(newsTile);
        });
        return ListView(
          shrinkWrap: true,
          reverse: true,
          children: newsTiles,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffa549eb),
        centerTitle: true,
        title: Text('समाचार'),
      ),
      body: buildNewsTiles(),
    );
  }
}

class NewsTile extends StatelessWidget {
  final News news;
  NewsTile({this.news});

  configureMediaPreview(String imageUrl) {
    return Container(
      height: 55.0,
      width: 55.0,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(imageUrl),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(news.imageUrl);
    return Container(
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SingleNewsPage(
                      news: news,
                    );
                  }));
                },
                child: ListTile(
                  contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 2),
                  leading: configureMediaPreview(news.iconUrl),
                  title: Text(
                    news.newsTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: configureMediaPreview(news.imageUrl),
                  subtitle: Text(
                    news.source,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Divider(),
            ],
          )
        ],
      ),
    );
  }
}

// Container(
//         alignment: Alignment.center,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Text('News Page'),
//             RaisedButton(
//               color: Colors.purple,
//               onPressed: widget.func,
//               child: Text('Logout'),
//             )
//           ],
//         ),
//       ),
