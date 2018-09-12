import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:douban_movie/movie/list/movie_list.dart';
import 'package:douban_movie/movie/detail/movie_detail_page.dart';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => new _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    _getMovieData();
  }

  _getMovieData() async {
    var httpClient = new HttpClient();
    String api = '?apikey=0b2bdeda43b5688921839c8ecb20399b';
    var url = 'https://api.douban.com/v2/movie/in_theaters' + api;
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var movieListData = await response.transform(utf8.decoder).join();
      setState(() {
        movies = Movie.getData(movieListData);
      });
    }
  }
  
  Future<Null> _handleRefresh() async {
    _getMovieData();
  }

  @override
  Widget build(BuildContext context) {
    var movieItems;
    if (movies.isEmpty) {
      movieItems = new Center(
        child: new Text('正在获取数据'),
      );
    } else {
      movieItems = new ListView(children: _buildMovieList());
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('热映电影'),
      ),
      body: RefreshIndicator(child: movieItems, onRefresh: _handleRefresh),
    );
  }

  _buildMovieList() {
    List<Widget> movieItems = [];
    for (int i = 0; i < movies.length; i++) {
      Movie movie = movies[i];

      var movieImage = new Padding(
        padding: new EdgeInsets.only(top: 5.0, right: 10.0, bottom: 5.0, left: 5.0),
        child: new Image.network(
          movie.smallImage,
          scale: 3.0,
        ),
      );

      var movieInformation = new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(
            movie.title,
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
          ),
          new Text('导演：' + movie.directors),
          new Text('主演：' + movie.casts),
          new Text('类型：' + movie.genres),
          new Text('评分：' + movie.averageRating),
          new Text(
            movie.collectCount + '人看过',
            style: new TextStyle(
              fontSize: 12.0,
              color: Colors.redAccent,
            ),
          ),
        ],
      );

      var movieItem = new GestureDetector(
        onTap: () => navigateToMovieDetailPage(movie),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                movieImage,
                new Expanded(child: movieInformation),
                const Icon(Icons.keyboard_arrow_right),
              ],
            ),
            new Divider(),
          ],
        ),
      );

      movieItems.add(movieItem);
    }
    return movieItems;
  }

  navigateToMovieDetailPage(Movie movie) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new MovieDetailPage(movie: movie,);
    }));
  }
}
