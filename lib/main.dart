import 'package:flutter/material.dart';
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
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => MyHomePage(
          title: 'TrackFit',
          onTabSelected: (index) {
            // Aquí puedes realizar cualquier acción relacionada con la selección de pestañas en MyHomePage
          },
        ),
      },
    );
  }
}













