import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Movie {
  final String name;
  final num rating;

  Movie({this.name, this.rating});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      name: json['name'] as String,
      rating: json['rating'] as num,
    );
  }
}

class DisplayMovies extends StatefulWidget {
  DisplayMovies({Key key}) : super(key: key);

  @override
  _DisplayMoviesState createState() => _DisplayMoviesState();
}

Future<List<Movie>> fetchMovie() async {
  final response = await http.get('http://192.168.1.15:8080/api/v1/films');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<dynamic> body = jsonDecode(response.body);
    List<Movie> movies =
        body.map((dynamic item) => Movie.fromJson(item)).toList();
    return movies;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to display movies');
  }
}

class _DisplayMoviesState extends State<DisplayMovies> {
  Future<List<Movie>> futureMovie;

  @override
  void initState() {
    super.initState();
    futureMovie = fetchMovie();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie DB',
      home: Scaffold(
        body: FutureBuilder(
          future: futureMovie,
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            if (snapshot.hasData) {
              List<Movie> movies = snapshot.data;

              return ListView(
                children: movies
                    .map(
                      (Movie movie) => ListTile(
                        title: Text(movie.name),
                        subtitle: Text(movie.rating.toString()),
                      ),
                    )
                    .toList(),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
