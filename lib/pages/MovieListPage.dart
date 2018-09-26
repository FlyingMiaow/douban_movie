import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../classes/MovieListClass.dart';
import 'MovieDetailPage.dart';
import 'MovieSearchPage.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => new _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final TextEditingController _textEditingController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  List<Movie> movies = [];
  int start = 0;
  int end = 0;
  int totalNumberOfMovies = 0;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        start = end;
        if (start >= totalNumberOfMovies) {
          _scaffoldKey.currentState.showSnackBar(_buildSnackBar('没有更多电影'));
          return;
        }
        end += 5;
        if (end >= totalNumberOfMovies) {
          end = totalNumberOfMovies;
        }
        _getMovieData('get');
        _scaffoldKey.currentState.showSnackBar(_buildSnackBar('加载更多电影成功'));
      }
    });
    _getMovieData('get');
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  _getMovieData(String flag) async {
    if (!isRunning) {
      setState(() {
        isRunning = true;
      });
      var httpClient = new HttpClient();
      const String api = '?apikey=0b2bdeda43b5688921839c8ecb20399b';
      final url = 'https://api.douban.com/v2/movie/in_theaters' + api;
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var movieListData = await response.transform(utf8.decoder).join();
        var jsonData = json.decode(movieListData);
        jsonData = jsonData['subjects'];
        totalNumberOfMovies = jsonData.length;
        if (end == 0) {
          if (totalNumberOfMovies > 5) {
            end = 5;
          } else {
            end = totalNumberOfMovies;
          }
        }
        setState(() {
          if (flag == 'get') {
            movies = Movie.getData(jsonData, movies, start, end);
            end = movies.length;
          } else if (flag == 'update') {
            movies = Movie.updateData(jsonData, 0, end);
          }
          isRunning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var content;
    if (movies.isEmpty) {
      content = new Center(child: new CircularProgressIndicator());
    } else {
      content = new Scrollbar(
        child: new SingleChildScrollView(
          controller: _scrollController,
          child: new Column(
            children: <Widget>[
              _buildSearchBar(),
              new Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: new Column(children: _buildMovieList()),
              )
            ],
          ),
        ),
      );
    }
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('正在热映'),
      ),
      body: RefreshIndicator(child: content, onRefresh: _refreshMovieList),
    );
  }

  _buildSearchBar() {
    return new Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: _textEditingController,
              onSubmitted: _searchMovie,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(5.0),
                hintText: '点击搜索影片',
                hintStyle: TextStyle(fontSize: 12.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
          new IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _searchMovie(_textEditingController.text),
          ),
        ],
      ),
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
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 10.0, 0.0),
      child: new FadeInImage(
        placeholder: new MemoryImage(kTransparentImage),
        image: new NetworkImage(movie.smallImage, scale: 3.0),
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
        new Text('导演：${movie.directors}'),
        new Text('主演：${movie.casts}'),
        new Text('类型：${movie.genres}'),
        new Text('评分：${movie.averageRating}'),
        new Text(
          '${movie.collectCount}人看过',
          style: new TextStyle(fontSize: 12.0, color: Colors.redAccent),
        ),
      ],
    );

    var movieItem = new InkWell(
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
    _getMovieData('update');
    _scaffoldKey.currentState.showSnackBar(_buildSnackBar('刷新成功'));
  }

  _buildSnackBar(String text) {
    final snackBar = new SnackBar(
      content: new Text(text),
      duration: new Duration(seconds: 1),
      backgroundColor: Colors.black12,
    );
    return snackBar;
  }
}
