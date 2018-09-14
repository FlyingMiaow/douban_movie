import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:douban_movie/movie/list/movie_list.dart';
import 'package:douban_movie/movie/detail/movie_detail.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  MovieDetailPage({
    this.movie,
  });

  @override
  _MovieDetailPageState createState() => new _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  MovieDetail movieDetail;

  @override
  void initState() {
    super.initState();
    _getMovieDetailData();
  }

  _getMovieDetailData() async {
    var httpClient = new HttpClient();
    String api = '?apikey=0b2bdeda43b5688921839c8ecb20399b';
    var url = 'https://api.douban.com/v2/movie/subject/' + widget.movie.id + api;
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var movieDetailData = await response.transform(utf8.decoder).join();
      setState(() {
        movieDetail = MovieDetail.getDetailData(movieDetailData);
      });
    }
  }

  _buildMovieDetail() {
    return new Row(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.only(right: 10.0),
          child: new Image.network(
            widget.movie.smallImage,
            scale: 1.75,
          ),
        ),
        new Expanded(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                widget.movie.title,
                style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              new Text('上映日期：' + movieDetail.pubdates),
              new Text('时长：' + movieDetail.durations),
              new Text('类型：' + widget.movie.genres),
              new Text('国籍：' + movieDetail.countries),
              new Text('语言：' + movieDetail.languages),
              new Text('评分：' + widget.movie.averageRating),
            ],
          ),
        ),
      ],
    );
  }

  _buildMovieSummary() {
    return new Card(
      child: new Container(
        padding: new EdgeInsets.all(7.5),
        child: new Text(movieDetail.summary),
      ),
    );
  }

  _buildCastItems() {
    List<Widget> castItems = [];
    for (int i = 0; i < movieDetail.casts.length; i++) {
      CastDetail cast = movieDetail.casts[i];
      var castItem = new Card(
        child: new Row(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.only(right: 10.0),
              child: new Image.network(
                cast.smallAvatar,
                width: 100.0,
                height: 100.0,
              ),
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    cast.name,
                    style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                  new Text(cast.nameEng),
                ],
              ),
            ),
          ],
        ),
      );
      castItems.add(castItem);
    }
    return castItems;
  }

  _buildDirectorItems() {
    List<Widget> directorItems = [];
    for (int i = 0; i < movieDetail.directors.length; i++) {
      DirectorDetail director = movieDetail.directors[i];
      var directorItem = new Card(
        child: new Row(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.only(right: 10.0),
              child: new Image.network(
                director.smallAvatar,
                width: 100.0,
                height: 100.0,
              ),
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    director.name,
                    style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                  new Text(director.nameEng),
                ],
              ),
            ),
          ],
        ),
      );
      directorItems.add(directorItem);
    }
    return directorItems;
  }

  @override
  Widget build(BuildContext context) {
    var content;
    if (movieDetail == null) {
      content = new Center(
        child: new Text('正在获取数据'),
      );
    } else {
      content = new Scrollbar(
        child: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Container(
                padding: new EdgeInsets.all(10.0),
                child: _buildMovieDetail(),
              ),
              new Padding(
                padding: new EdgeInsets.only(top: 5.0),
                child: new Text(
                  '剧情简介',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.blue,
                  ),
                ),
              ),
              new Padding(
                padding: new EdgeInsets.only(right: 10.0, bottom: 10.0, left: 10.0),
                child: _buildMovieSummary(),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: new Text(
                  '导演详情',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.blue,
                  ),
                ),
              ),
              new Padding(
                padding: new EdgeInsets.only(right: 10.0, bottom: 10.0, left: 10.0),
                child: new Column(children: _buildDirectorItems()),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: new Text(
                  '演员详情',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.blue,
                  ),
                ),
              ),
              new Padding(
                padding: new EdgeInsets.only(right: 10.0, bottom: 10.0, left: 10.0),
                child: new Column(children: _buildCastItems()),
              ),
            ],
          ),
        ),
      );
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('电影详情'),
      ),
      body: content,
    );
  }
}
