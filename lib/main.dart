import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Login> createLogin(String email, String password) async {
  final http.Response response = await http.post(
    'http://3.130.146.97/webservices/api/login',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 201) {
    return Login.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to login.');
  }
}

class Login {
  final String email;
  final String password;

  Login({this.email, this.password});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      email: json['email'],
      password: json['password'],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerOne = TextEditingController();
  Future<Login> _futureLogin;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureLogin == null)
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Enter Title'),
              ),
              TextField(
                controller: _controllerOne,
                decoration: InputDecoration(hintText: 'Enter Password'),
              ),
              RaisedButton(
                child: Text('Submit'),
                onPressed: () {
                  setState(() {
                    _futureLogin = createLogin(_controller.text,_controllerOne.text);
                  });
                },
              ),
            ],
          )
              : FutureBuilder<Login>(
            future: _futureLogin,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
              //here we have to return text snapshot but cant figure it how to return email and password both
                Text(snapshot.data.email);
                Text(snapshot.data.password);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
