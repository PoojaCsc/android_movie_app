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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rating': rating,
    };
  }
}

class CreateMovie extends StatelessWidget {
  CreateMovie(this.jwt);

  factory CreateMovie.create(String jwt) => CreateMovie(jwt);

  final String jwt;

  // final GlobalKey<ScaffoldState> globalKey = new GlobalKey<ScaffoldState>();
  // void showCreatedMessage() {
  //   globalKey.currentState
  //       .showSnackBar(new SnackBar(content: new Text('Rating Submitted')));
  // }

  void dialog(BuildContext context) {
    showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text('SUCCESS'),
          content: new Text('Successfully Submitted Rating'),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ));
  }

  void failedDialog(BuildContext context, String msg) {
    showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text('FAI:ED'),
          content: new Text(msg),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ));
  }

  Future<String> createMovie(
      BuildContext context, String title, String ratingText) async {
    if (title.length == 0) {
      failedDialog(context, "Movie Name can not be Empty.");
      return "";
    }

    if (ratingText == null || ratingText.length == 0) {
      failedDialog(context, "Invalid rating.It should lie between 0 & 5.");
      return "";
    }

    num rating = -1;
    try {
      rating = num.parse(ratingController.text);
    } on Exception catch (_) {
      failedDialog(context, "Invalid rating.It should lie between 0 & 5.");
      return "";
    }

    if (rating < 0 || rating > 5) {
      failedDialog(context, "Invalid rating.It should lie between 0 & 5.");
      return "";
    }
    Map data = {'name': title, 'rating': rating};
    String body = json.encode(data);

// http.Response response = await http.post(
//   url: 'https://example.com',
//   headers: {"Content-Type": "application/json"},
//   body: body,
// );

    var response = await http.post('http://192.168.1.15:8080/api/v1/films',
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + '$jwt'
        },
        body: body);
    print('Bearer + $jwt');
    print('Bearer' + '$jwt');
    if (response.statusCode == 200) {
      print("Success"); // return something here of Movie type
      print(response.body);
      dialog(context);
      // this.showCreatedMessage();
    } else {
      throw Exception('Failed to create movie');
    }
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  Future<Movie> newMovie;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie DB',
      home: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: 'Enter Title'),
                  ),
                  TextField(
                    controller: ratingController,
                    decoration: InputDecoration(
                        hintText: 'Enter rating between 0 to 5'),
                  ),
                  RaisedButton(
                    child: Text('Submit'),
                    onPressed: () {
                      createMovie(
                          context, titleController.text, ratingController.text);
                    },
                  ),
                ],
              ))),
    );
  }
}
