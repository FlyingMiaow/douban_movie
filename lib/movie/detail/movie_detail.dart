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

class MovieDetail {
  final String pubdates;
  final String durations;
  List<CastDetail> casts;
  final String countries;
  final String summary;

  MovieDetail({
    this.pubdates,
    this.durations,
    this.casts,
    this.countries,
    this.summary,
  });

  static MovieDetail getDetailData(String movieDetailData) {
    var jsonData = json.decode(movieDetailData);
    List pubdatesData = jsonData['pubdates'];
    List durationsData = jsonData['durations'];
    List countriesData = jsonData['countries'];
    List castsData = jsonData['casts'];

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

    return new MovieDetail(
      pubdates: pubdates,
      durations: durations,
      casts: casts,
      countries: countries,
      summary: jsonData['summary'],
    );
  }
}