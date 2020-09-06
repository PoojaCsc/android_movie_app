import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movie_db/login.dart';
import 'package:movie_db/display_movies.dart';
import 'package:movie_db/create_movie.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String jwt;
  const HomePage({this.username, this.jwt});

  @override
  _HomePage createState() => new _HomePage();
}

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController tabController;
  //final loginData = LoginData(username: 'NOT LOGGED IN', logged_in: false);
  void initState() {
    tabController = new TabController(length: 2, vsync: this);
  }

  Widget build(BuildContext bc) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text('Movie DB'),
            // title: Center(child: Text('Movies DB')),
            //  leading: new Icon(Icons.menu),
            bottom: new TabBar(controller: tabController, tabs: <Widget>[
              new Tab(text: 'GET MOVIES'),
              new Tab(text: 'SUBMIT RATING')
            ])),
        drawer: new Drawer(
          child: new ListView(children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text(widget.username == null
                    ? 'NOT LOGGED IN'
                    : widget.username),
                accountEmail: null,
                currentAccountPicture: new CircleAvatar(
                    backgroundColor: Colors.black38,
                    child: new Text(
                        widget.username != null && widget.username.length > 0
                            ? ('${widget.username[0]}').toUpperCase()
                            : 'NA')),
                decoration: new BoxDecoration(color: Colors.cyan)),
            new ListTile(
                title: new Text("Login"),
                trailing: new Icon(Icons.account_circle),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (bc) => LoginPage(),
                    ),
                  );
                }),
            new ListTile(
              title: new Text('Close'),
              trailing: new Icon(Icons.close),
              onTap: () {
                Navigator.pop(bc);
              },
            )
          ]),
        ),
        body: new TabBarView(controller: tabController, children: <Widget>[
          DisplayMovies(),
          widget.username == null
              ? new Center(
                  child: new Text('Please login first to submit ratings'),
                )
              : CreateMovie.create(widget.jwt),
        ]));
  }
}
