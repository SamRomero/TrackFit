import 'package:flutter/material.dart';
import 'package:trackfit/Pantallas/login_screen.dart';
import 'package:trackfit/Pantallas/my_home_page.dart';
import 'package:trackfit/Pantallas/registros.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackFit',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => LoginScreen(),
      },
    );
  }
}













