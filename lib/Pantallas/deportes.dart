import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../LocalStorage.dart';
import 'dart:convert';

class Deportes extends StatefulWidget {
  const Deportes({Key? key}) : super(key: key);

  @override
  _DeportesState createState() => _DeportesState();
}

class _DeportesState extends State<Deportes> {
  List<Map<String, dynamic>> deportes = [
  ]; // Lista para almacenar los datos de los deportes
  bool isLoading = true; // Variable para controlar la carga de datos

  @override
  void initState() {
    fetchDeportesData().then((List<Map<String, dynamic>> data) {
      if (mounted) {
        setState(() {
          deportes = data;
        });
      }
    }).catchError((error) {
      // Manejar el error en caso de que ocurra
      print('Error: $error');
    });
  }

  Future<List<Map<String, dynamic>>> fetchDeportesData() async {
    final _localStorage = LocalStorage();
    final response = await http.get(
      Uri.parse('http://192.168.0.99:8000/api/deportes'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_localStorage.authToken}'
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      final List<dynamic> jsonList = json.decode(response.body);
      final List<Map<String, dynamic>> deportesData =
      jsonList.map((dynamic json) => json as Map<String, dynamic>).toList();
      return deportesData;
    } else {
      throw Exception('Failed to fetch sensors data');
    }
  }

  Map<String, IconData> deportesIconos = {
    'Baloncesto': Icons.sports_basketball,
    'Fútbol': Icons.sports_soccer,
    'Atletismo': Icons.sports_gymnastics,
    'Tenis': Icons.sports_tennis_outlined,
    'VolleyBall': Icons.sports_volleyball,
  };

  Map<String, Color> deportesColores = {
    'Baloncesto': Colors.orange,
    'Fútbol': Colors.green,
    'Atletismo': Colors.blue,
    'Tenis': Colors.brown,
    'VolleyBall': Colors.deepPurpleAccent,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20), // Espacio en blanco para separar el label "Deportes" del ListView.builder
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Deportes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : deportes.isEmpty
                ? Center(
              child: Text('Aún no hay deportes.'),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: deportes.length,
              itemBuilder: (BuildContext context, int index) {
                final deporte = deportes[index];
                final deporteNombre = deporte['name'];
                final deporteIcono = deportesIconos[deporteNombre];
                final deporteColor = deportesColores[deporteNombre];

                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(deporteNombre),
                      ),
                      subtitle: Text(deporte['description']),
                      trailing: Icon(
                        deporteIcono ?? Icons.sports_basketball,
                        size: 100,
                        color: deporteColor ?? Colors.orange,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}