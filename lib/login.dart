import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:movie_db/create_movie.dart';
import 'package:movie_db/home_page.dart';
import 'dart:convert';

import 'package:movie_db/login_data.dart';

final storage = FlutterSecureStorage();

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  void dialog(BuildContext context) {
    showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text('SUCCESS'),
          content: new Text('Successfully Logged in '),
        ));
  }

  Future<String> logIn(String username, BuildContext context) async {
    var res = await http.post('http://192.168.1.15:8080/api/v1/login',
        body: {"username": username});
    if (res.statusCode == 200) {
      dialog(context);
      return res.body;
    }
    ;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie DB',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Center(child: Text('Movie DB')),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  RaisedButton(
                      onPressed: () async {
                        var username = _usernameController.text;

                        var jwt = await logIn(username, context);
                        // var token = json.decode(utf8.decode(base64.decode(base64.normalize(jwt[1]))));
                        var future = new Future.delayed(
                            const Duration(milliseconds: 20000), () => {});
                        Map<String, dynamic> map = jsonDecode(jwt);
                        String token = map['token'];
                        print(token);

                        if (jwt != null) {
                          // displayDialog(context, "success", "Login successful");

                          storage.write(key: "jwt", value: jwt);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomePage(username: username, jwt: token)
                                  //CreateMovie.fromBase64(token)
                                  ));
                        } else {
                          displayDialog(
                              context, "An Error Occurred", "login again");
                        }
                      },
                      child: Text("Log In")),
                ],
              ),
            )));
  }
}
