import 'package:flutter/material.dart';
import 'package:logregist/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({required this.onSignOut});

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    void _signOut() async {
      try {
        Auth().signOut();
        onSignOut();
      } catch (e) {
        print(e);
      }
    }

    return new Scaffold(
        appBar: new AppBar(
          actions: <Widget>[
            new TextButton(
                onPressed: _signOut,
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)))
          ],
        ),
        body: new Center(
          child: new Text(
            'Welcome',
            style: new TextStyle(fontSize: 32.0),
          ),
        ));
  }
}
