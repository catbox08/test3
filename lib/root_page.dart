import 'package:flutter/material.dart';
import 'package:logregist/auth.dart';
import 'package:logregist/login_page.dart';
import 'package:logregist/home_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({required Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  initState() {
    super.initState();

    setState(() {
      authStatus = Auth().currentUser()?.uid != null
          ? AuthStatus.signedIn
          : AuthStatus.notSignedIn;
    });
  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(
          title: 'Flutter Login',
          onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
        );
      case AuthStatus.signedIn:
        return new HomePage(
            onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn));
    }
  }
}
