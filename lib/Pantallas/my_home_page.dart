import 'package:flutter/material.dart';
import 'package:trackfit/Pantallas/deportes.dart';
import 'package:trackfit/Pantallas/eventos.dart';
import 'package:trackfit/Pantallas/estadisticas.dart';
import 'package:trackfit/Pantallas/mapa.dart';
import 'package:trackfit/Pantallas/registros.dart';
import 'package:trackfit/Pantallas/user_screen.dart';
import 'package:trackfit/Pantallas/login_screen.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.onTabSelected,
    this.initialIndex,
  }) : super(key: key);

  final String title;
  final ValueChanged<int> onTabSelected;
  final int? initialIndex;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 2;
  int _userScreenIndex = 4;

  final List<Widget> _screens = [
    const Estadisticas(),
    const Deportes(),
    const Eventos(),
    const Mapa(),
    const Registros(),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialIndex != null) {
      _currentIndex = widget.initialIndex!;
    }
  }
  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onUserButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserScreen(),
      ),
    );
  }

  void _onLogoutButtonPressed() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: _onUserButtonPressed,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _onLogoutButtonPressed,
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.blue[200],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph),
            label: 'Estadistica',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_gymnastics),
            label: 'Deportes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Registros',
          ),
        ],
      ),
    );
  }
}