import 'dart:convert';

class CastDetail {
  final String smallAvatar;
  final String nameEng;
  final String name;

  CastDetail({
    this.smallAvatar,
    this.nameEng,
    this.name,
  });
}

class DirectorDetail {
  final String smallAvatar;
  final String nameEng;
  final String name;

  DirectorDetail({
    this.smallAvatar,
    this.nameEng,
    this.name,
  });
}

class MovieDetail {
  final String pubdates;
  final String durations;
  final String languages;
  List<CastDetail> casts;
  final String countries;
  final String summary;
  List<DirectorDetail> directors;

  MovieDetail({
    this.pubdates,
    this.durations,
    this.languages,
    this.casts,
    this.countries,
    this.summary,
    this.directors,
  });

  static MovieDetail getDetailData(String movieDetailData) {
    var jsonData = json.decode(movieDetailData);
    List pubdatesData = jsonData['pubdates'];
    List durationsData = jsonData['durations'];
    List languagesData = jsonData['languages'];
    List countriesData = jsonData['countries'];
    List castsData = jsonData['casts'];
    List directorsData = jsonData['directors'];

    var pubdates = '';
    for (int i = 0; i < pubdatesData.length; i++) {
      if (i == 0) {
        pubdates = pubdates + pubdatesData[i];
      } else {
        pubdates = pubdates + '/' + pubdatesData[i];
      }
    }

    var durations = '';
    for (int i = 0; i < durationsData.length; i++) {
      if (i == 0) {
        durations = durations + durationsData[i];
      } else {
        durations = durations + '/' + durationsData[i];
      }
    }

    var languages = '';
    for (int i = 0; i < languagesData.length; i++) {
      if (i == 0) {
        languages = languages + languagesData[i];
      } else {
        languages = languages + '/' + languagesData[i];
      }
    }

    var countries = '';
    for (int i = 0; i < countriesData.length; i++) {
      if (i == 0) {
        countries = countries + countriesData[i];
      } else {
        countries = countries + '/' + countriesData[i];
      }
    }

    List<CastDetail> casts = [];
    for (int i = 0; i < castsData.length; i++) {
      CastDetail singleCast = new CastDetail(
        smallAvatar: castsData[i]['avatars']['small'],
        nameEng: castsData[i]['name_en'],
        name: castsData[i]['name'],
      );
      casts.add(singleCast);
    }

    List<DirectorDetail> directors = [];
    for (int i = 0; i < directorsData.length; i++) {
      DirectorDetail singleDirector = new DirectorDetail(
        smallAvatar: directorsData[i]['avatars']['small'],
        nameEng: directorsData[i]['name_en'],
        name: directorsData[i]['name'],
      );
      directors.add(singleDirector);
    }

    return new MovieDetail(
      pubdates: pubdates,
      durations: durations,
      languages: languages,
      casts: casts,
      countries: countries,
      summary: jsonData['summary'],
      directors: directors,
    );
  }
}