import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../localstorage.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class Registros extends StatefulWidget {
  const Registros({Key? key}) : super(key: key);

  @override
  _RegistrosState createState() => _RegistrosState();
}


class _RegistrosState extends State<Registros> {
  List<Map<String, dynamic>> registros = [];
  bool isLoading = true;
  final _localStorage = LocalStorage();

  @override
  void initState() {
    _localStorage.init();
    fetchRegistrosData().then((List<Map<String, dynamic>> data) {
      if (mounted) {
        setState(() {
          registros = data;
          isLoading = false;
        });
      }
    }).catchError((error) {
      print('Error: $error');
      isLoading = false;
    });
  }

  Future<List<Map<String, dynamic>>> fetchRegistrosData() async {
    final user = _localStorage.userData;
    final body = jsonEncode({
      "id_user": user['id']
    });

    print(body);
    print(_localStorage.authToken);

    final response = await http.post(
      Uri.parse('http://192.168.0.99:8000/api/regbyuser'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_localStorage.authToken}',
      },
      body:body
    );

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      final List<dynamic> jsonList = json.decode(response.body);
      final List<Map<String, dynamic>> registrosData =
      jsonList.map((dynamic json) => json as Map<String, dynamic>).toList();
      return registrosData;
    } else {
      print('Failed to fetch registros data');
      throw Exception('Failed to fetch registros data');
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
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Registros',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : registros.isEmpty
                ? Center(
              child: Text('  Aún no hay registros.'),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: registros.length,
              itemBuilder: (BuildContext context, int index) {
                final registro = registros[index];
                final nombre = registro['name'];
                final categoria = registro['categoria']['name'];
                final duracion = registro['duracion'];
                final isActividad = registro['is_actividad'];
                final ubicacion = registro['location']['name'];
                final fecha = DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(registro['created_at']));
                final deporteNombre = registro['deporte']['name'];
                final deporteIcono = deportesIconos[deporteNombre];
                final deporteColor = deportesColores[deporteNombre];

                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(nombre),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Categoría: ${categoria}'),
                          Text('Duración: ${duracion} segundos'),
                          Text('Actividad: ${isActividad == 0 ? 'Entrenamiento' : 'Competencia oficial'}'),
                          Text('Ubicación: ${ubicacion}'),
                          Text('Fecha: ${fecha}'),
                        ],
                      ),
                      leading: Icon(
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
