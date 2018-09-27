import 'package:flutter/material.dart';
import 'MovieListPage.dart';
import 'MovieComingSoonPage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _tableIndex = 0;
  var _bottomBarTitles = ['正在热映', '即将上映'];
  var _bodies = [
    new MovieListPage(),
    new MovieComingSoonPage(),
  ];
  var _icons = [
    Icons.movie,
    Icons.local_movies,
  ];

  _getTableIcon(int index) {
    if (index == _tableIndex) {
      return new Icon(_icons[index], color: Colors.blue);
    } else {
      return new Icon(_icons[index], color: Colors.grey);
    }
  }

  _getTableTitle(int index) {
    if (index == _tableIndex) {
      return new Text(_bottomBarTitles[index], style: new TextStyle(color: Colors.blue, fontSize: 12.0));
    } else {
      return new Text(_bottomBarTitles[index], style: new TextStyle(color: Colors.grey, fontSize: 12.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(_bottomBarTitles[_tableIndex]),
      ),
      body: _bodies[_tableIndex],
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(icon: _getTableIcon(0), title: _getTableTitle(0)),
          new BottomNavigationBarItem(icon: _getTableIcon(1), title: _getTableTitle(1)),
        ],
        currentIndex: _tableIndex,
        onTap: (index) {
          setState(() {
            _tableIndex = index;
          });
        },
      ),
      drawer: new Drawer(
        child: new Center(child: new Text('This is a drawer')),
      ),
    );
  }
}
