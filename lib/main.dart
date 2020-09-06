import 'package:flutter/material.dart';


import 'package:movie_db/display_movies.dart';
import 'package:movie_db/login.dart';
import 'package:movie_db/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie DB',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        //  home: LoginPage());
        home: HomePage());
  }
}
