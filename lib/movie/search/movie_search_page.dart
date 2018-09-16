import 'package:flutter/material.dart';

class MovieSearchPage extends StatefulWidget {
  final movieItem;

  MovieSearchPage({
    this.movieItem,
  });

  @override
  _MovieSearchPageState createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  var content;

  @override
  Widget build(BuildContext context) {
    if (widget.movieItem == null) {
      content = new Center(child: new Text('没有搜到相关影片'));
    } else {
      content = new Scrollbar(
        child: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              widget.movieItem,
            ],
          ),
        ),
      );
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('搜索结果'),
      ),
      body: content,
    );
  }
}
