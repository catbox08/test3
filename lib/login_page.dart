import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logregist/primary_button.dart';
import 'auth.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({required this.title, required this.onSignIn});

  final String title;

  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  static final formKey = new GlobalKey<FormState>();

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  FormType _formType = FormType.login;
  String _authHint = '';

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        bool signin =
            await Auth().signIn(emailcontroller.text, passwordcontroller.text);
        print(signin);
        if (signin)
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        onSignOut: () {},
                      )));
      } catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  void moveToRegister() {
    formKey.currentState!.reset();
    setState(() {
      _formType = FormType.register;
      _authHint = '';
    });
  }

  void moveToLogin() {
    formKey.currentState!.reset();
    setState(() {
      _formType = FormType.login;
      _authHint = '';
    });
  }

  List<Widget> usernameAndPassword() {
    return [
      padded(
          child: new TextFormField(
        controller: emailcontroller,
        key: new Key('email'),
        decoration: new InputDecoration(labelText: 'Email'),
        autocorrect: false,
        validator: (val) => val!.isEmpty ? 'Email can\'t be empty.' : null,
        onSaved: (val) => emailcontroller.text = val!,
      )),
      padded(
          child: new TextFormField(
        controller: passwordcontroller,
        key: new Key('password'),
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,
        autocorrect: false,
        validator: (val) => val!.isEmpty ? 'Password can\'t be empty.' : null,
        onSaved: (val) => passwordcontroller.text = val!,
      )),
    ];
  }

  List<Widget> submitWidgets() {
    switch (_formType) {
      case FormType.login:
        return [
          new PrimaryButton(
              key: new Key('login'),
              text: 'Login',
              height: 44.0,
              onPressed: validateAndSubmit),
          new TextButton(
              key: new Key('need-account'),
              child: new Text("Need an account? Register"),
              onPressed: moveToRegister),
        ];
      case FormType.register:
        return [
          new PrimaryButton(
              key: new Key('register'),
              text: 'Create an account',
              height: 44.0,
              onPressed: () => Auth()
                  .createUser(emailcontroller.text, passwordcontroller.text)),
          new TextButton(
              key: new Key('need-login'),
              child: new Text("Have an account? Login"),
              onPressed: moveToLogin),
        ];
    }
  }

  Widget hintText() {
    return new Container(
        //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: new Text(_authHint,
            key: new Key('hint'),
            style: new TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        backgroundColor: Colors.grey[300],
        body: new SingleChildScrollView(
            child: new Container(
                padding: const EdgeInsets.all(16.0),
                child: new Column(children: [
                  new Card(
                      child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                        new Container(
                            padding: const EdgeInsets.all(16.0),
                            child: new Form(
                                key: formKey,
                                child: new Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children:
                                      usernameAndPassword() + submitWidgets(),
                                ))),
                      ])),
                  hintText()
                ]))));
  }

  Widget padded({required Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
