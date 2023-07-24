import 'package:flutter/material.dart';
import 'package:trackfit/localstorage.dart';
import 'package:trackfit/Pantallas/login_screen.dart';
import 'package:trackfit/Pantallas/my_home_page.dart';
import 'package:trackfit/Pantallas/registros.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar LocalStorage
  LocalStorage localStorage = LocalStorage();
  await localStorage.init();
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













