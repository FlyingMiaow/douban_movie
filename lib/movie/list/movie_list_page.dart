import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:douban_movie/movie/list/movie_list.dart';
import 'package:douban_movie/movie/detail/movie_detail_page.dart';
import 'package:douban_movie/movie/search/movie_search_page.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => new _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final TextEditingController _textEditingController = new TextEditingController();
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    _getMovieData();
  }

  _getMovieData() async {
    var httpClient = new HttpClient();
    const String api = '?apikey=0b2bdeda43b5688921839c8ecb20399b';
    final url = 'https://api.douban.com/v2/movie/in_theaters' + api;
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var movieListData = await response.transform(utf8.decoder).join();
      setState(() {
        movies = Movie.getData(movieListData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var movieItems;
    if (movies.isEmpty) {
      movieItems = new Center(child: new Text('正在获取数据'));
    } else {
      movieItems = new ListView(children: _buildMovieList()
      );
    }
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('热映电影'),
      ),
      body: RefreshIndicator(child: movieItems, onRefresh: _refreshMovieList),
    );
  }

  _buildSearchBar() {
    return new Container(
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: _textEditingController,
              onSubmitted: _searchMovie,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: '点击搜索影片',
                hintStyle: TextStyle(fontSize: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                )
              ),
            ),
          ),
          new IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _searchMovie(_textEditingController.text),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 5.0),
    );
  }

  _searchMovie(String text) {
    var movieItem;
    for (int i = 0; i < movies.length; i++) {
      if (movies[i].title.contains(text)) {
        movieItem = _buildMovieItem(movies[i]);
      }
    }

    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new MovieSearchPage(movieItem: movieItem);
    }));
  }

  _buildMovieList() {
    List<Widget> movieItems = [];
    for (int i = 0; i < movies.length; i++) {
      Movie movie = movies[i];
      movieItems.add(_buildMovieItem(movie));
    }
    return movieItems;
  }

  _buildMovieItem(Movie movie) {
    var movieImage = new Padding(
        padding: const EdgeInsets.only(top: 5.0, right: 10.0, bottom: 5.0, left: 5.0),
        child: new FadeInImage(
          placeholder: new MemoryImage(kTransparentImage),
          image: new NetworkImage(
            movie.smallImage,
            scale: 3.0,
          ),
        )
    );

    var movieInformation = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Text(
          movie.title,
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
        ),
        new Text('导演：${movie.directors}'),
        new Text('主演：${movie.casts}'),
        new Text('类型：${movie.genres}'),
        new Text('评分：${movie.averageRating}'),
        new Text(
          '${movie.collectCount}人看过',
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

    return movieItem;
  }

  navigateToMovieDetailPage(Movie movie) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new MovieDetailPage(movie: movie);
    }));
  }

  Future<Null> _refreshMovieList() async {
    _getMovieData();
    final snackBar = new SnackBar(
      content: new Text('刷新成功'),
      duration: new Duration(seconds: 1),
      backgroundColor: Colors.black12,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
