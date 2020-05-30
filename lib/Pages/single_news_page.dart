import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_khabar/models/news.dart';

class SingleNewsPage extends StatelessWidget {
  final News news;

  SingleNewsPage({this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffa549eb),
        centerTitle: true,
        title: Text(
          news.source,
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ListTile(
                title: Center(
                  child: Text(
                    news.newsTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
              ),
              Divider(),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 7, 10, 10),
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: news != null
                              ? CachedNetworkImageProvider(news.imageUrl)
                              : CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 7, 10, 20),
                      child: Text(
                        news.newsContent,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 17.5),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
