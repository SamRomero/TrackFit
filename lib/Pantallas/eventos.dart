import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../localstorage.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class Eventos extends StatefulWidget {
  const Eventos({Key? key}) : super(key: key);

  @override
  _EventosState createState() => _EventosState();
}

class _EventosState extends State<Eventos> {
  List<Map<String, dynamic>> eventos = []; // Lista para almacenar los datos de los eventos
  bool isLoading = true; // Variable para controlar la carga de datos

  @override
  void initState() {
    fetchEventosData().then((List<Map<String, dynamic>> data) {
      if (mounted) {
        setState(() {
          eventos = data;
        });
      }
    }).catchError((error) {
      // Manejar el error en caso de que ocurra
      print('Error: $error');
    });
  }

  Future<List<Map<String, dynamic>>> fetchEventosData() async {
    final _localStorage = LocalStorage();
    final response = await http.get(
      Uri.parse('http://192.168.0.99:8000/api/eventos'),
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
      final List<Map<String, dynamic>> eventosData =
      jsonList.map((dynamic json) => json as Map<String, dynamic>).toList();
      return eventosData;
    } else {
      throw Exception('Failed to fetch sensors data');
    }
  }

  // Mapa de asociación entre nombres de eventos y colores
  Map<String, Color> eventosColores = {
    'Torneo de Baloncesto': Colors.orange,
    'Torneo de Fútbol': Colors.green,
    'Torneo de Natación': Colors.blue,
  };

// Mapa de asociación entre nombres de eventos y iconos
  Map<String, IconData> eventosIconos = {
    'Torneo de Baloncesto': Icons.sports_basketball,
    'Torneo de Fútbol': Icons.sports_soccer,
    'Torneo de Natación': Icons.water_outlined,
  };

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(
        children: [
        SizedBox(height: 20), // Espacio en blanco para separar el label "Registros" del ListView.builder
        Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
        'Eventos',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ),
        Expanded(
        child: isLoading
        ? Center(
        child: CircularProgressIndicator(),
        )
            : eventos.isEmpty
        ? Center(
        child: Text('Aún no hay eventos.'),
        )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: eventos.length,
        itemBuilder: (BuildContext context, int index) {
          final evento = eventos[index];
          final eventoNombre = evento['name'];
          final eventoIcono = eventosIconos[eventoNombre];
          final eventoColor = eventosColores[eventoNombre];
          final ubicacion = evento['ubicacion'];
          final nameUbicacion = ubicacion['name'];
          final eventoStartDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(evento['start_date']));

          return Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(eventoNombre),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(evento['description']),
                    SizedBox(height: 8),
                    Text('Ubicación: $nameUbicacion'),
                    Text('Fecha de inicio: $eventoStartDate'), // Mostrar la fecha de inicio del evento
                  ],
                ),
                trailing: Icon(
                  eventoIcono ?? Icons.sports_basketball,
                  size: 100,
                  color: eventoColor ?? Colors.orange,
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