import 'dart:convert';

class Movie {
  final String averageRating;
  final String genres;
  final String title;
  final String casts;
  final String collectCount;
  final String directors;
  final String smallImage;
  final String id;

  Movie ({
    this.averageRating,
    this.genres,
    this.title,
    this.casts,
    this.collectCount,
    this.directors,
    this.smallImage,
    this.id,
  });

  static List<Movie> getData(String movieListData, List<Movie> movies, int start, int end) {
    var jsonData = json.decode(movieListData);
    jsonData = jsonData['subjects'];
    if (start > jsonData.length) {
      return movies;
    }
    if (end == 0) {
      if (jsonData.length > 5) {
        end = 5;
      } else {
        end = jsonData.length;
      }
    } else {
      if (end > jsonData.length) {
        end = jsonData.length;
      }
    }
    for (int i = start; i < end; i++) {
      movies.add(_decodeJsonData(jsonData[i]));
    }
    return movies;
  }

  static List<Movie> updateData(String movieListData, int start, int end) {
    List<Movie> movies = new List<Movie>();
    var jsonData = json.decode(movieListData);
    jsonData = jsonData['subjects'];
    for (int i = start; i < end; i++) {
      movies.add(_decodeJsonData(jsonData[i]));
    }
    return movies;
  }

  static Movie _decodeJsonData(Map jsonData) {
    List genresData = jsonData['genres'];
    List castsData = jsonData['casts'];
    List directorsData = jsonData['directors'];

    var genres = '';
    for (int i = 0; i < genresData.length; i++) {
      if (i == 0) {
        genres = genres + genresData[i];
      } else {
        genres = genres + '/' + genresData[i];
      }
    }

    var casts = '';
    for (int i = 0; i < castsData.length; i++) {
      if (i == 0) {
        casts = casts + castsData[i]['name'];
      } else {
        casts = casts + '/' + castsData[i]['name'];
      }
    }

    var directors = '';
    for (int i = 0; i < directorsData.length; i++) {
      if (i == 0) {
        directors = directors + directorsData[i]['name'];
      } else {
        directors = directors + '/' + directorsData[i]['name'];
      }
    }

    return new Movie(
      averageRating: jsonData['rating']['average'].toString(),
      genres: genres,
      title: jsonData['title'],
      casts: casts,
      collectCount: jsonData['collect_count'].toString(),
      directors: directors,
      smallImage: jsonData['images']['small'],
      id: jsonData['id'],
    );
  }
}
