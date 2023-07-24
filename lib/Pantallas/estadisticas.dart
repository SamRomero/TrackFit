import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../LocalStorage.dart';

class Estadisticas extends StatefulWidget {
  const Estadisticas({Key? key}) : super(key: key);

  @override
  _EstadisticasState createState() => _EstadisticasState();
}

class _EstadisticasState extends State<Estadisticas> {
  Map<String, dynamic> user = {};
  final _localStorage = LocalStorage();
  List<dynamic> deportes = [];
  List<dynamic> categorias = [];
  List<Map<String, dynamic>> registros = []; // Lista para almacenar los registros filtrados
  List<Map<String, dynamic>> registrosSemanal = []; // Lista para almacenar los registros semanales
  String? selectedDeporte;
  String? selectedCategoria;
  int selectedTipo = 0;

  @override
  void initState() {
    _localStorage.init();
    user = _localStorage.userData;
    super.initState();
    fetchDeportes();
    fetchData(); // Llamamos a la función fetchData para obtener los datos iniciales.

    // Llamamos a fetchDataSemanal para obtener los datos del gráfico de líneas.
    fetchDataSemanal(user['id']).then((data) {
      setState(() {
        // Actualizamos los datos del gráfico con los datos obtenidos.
        registrosSemanal = data;
      });
    }).catchError((error) {
      // Manejar el error, por ejemplo, mostrando un diálogo de error.
    });
  }

  Future<void> fetchDeportes() async {
    final response = await http.get(
      Uri.parse('http://192.168.0.99:8000/api/deportes'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_localStorage.authToken}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        deportes = data;
        selectedDeporte = deportes.isNotEmpty ? deportes[0]['id'].toString() : null;
        fetchCategorias(selectedDeporte);
      });
    } else {
      throw Exception('Failed to fetch deportes');
    }
  }

  Future<void> fetchCategorias(String? idDeporte) async {
    if (idDeporte != null) {
      final response = await http.post(
        Uri.parse('http://192.168.0.99:8000/api/catbydep'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_localStorage.authToken}',
        },
        body: jsonEncode({'id_deporte': int.parse(idDeporte)}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          categorias = data;
          selectedCategoria = categorias.isNotEmpty ? categorias[0]['id'].toString() : null;
          fetchData(); // Llamamos a fetchData para obtener los datos filtrados cada vez que cambie la categoría seleccionada.
        });
      } else {
        throw Exception('Failed to fetch categorias');
      }
    }
  }

  Future<void> fetchData() async {
    print(user);
    final response = await http.post(
      Uri.parse('http://192.168.0.99:8000/api/estadisticas'), // Coloca la URL correcta para la petición de filtrado.
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_localStorage.authToken}',
      },
      body: jsonEncode({
        'id_user': user['id'],
        'categoria': selectedCategoria, // Aquí asumimos que selectedCategoria nunca será nulo debido al valor inicial que le has asignado.
        'is_personal': selectedTipo,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final List<Map<String, dynamic>> registrosData =
      jsonList.map((dynamic json) => json as Map<String, dynamic>).toList();
      setState(() {
        registros = registrosData; // Actualizamos la lista de registros con los datos obtenidos.
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchDataSemanal(int idUser) async {
    final response = await http.post(
      Uri.parse('http://192.168.0.99:8000/api/estasemanales'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_localStorage.authToken}',
      },
      body: jsonEncode({
        'id_user': idUser,
      }),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  List<charts.Series<LinearSales, DateTime>> _createSampleData() {
    final List<LinearSales> data = registrosSemanal.map((registro) {
      return LinearSales(DateTime.parse(registro['date']), int.parse(registro['total_seconds']));
    }).toList();

    return [
      charts.Series<LinearSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.date,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  List<IconData> iconos = [
    Icons.looks_one_rounded,
    Icons.looks_two_rounded,
    Icons.looks_3_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: ListView(
            children: [
              SizedBox(height: 16),
              const Center(
                child: Text(
                  'Mejores tiempos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    value: selectedDeporte,
                    onChanged: (value) {
                      setState(() {
                        selectedDeporte = value;
                        fetchCategorias(selectedDeporte);
                      });
                    },
                    items: deportes.map((deporte) {
                      return DropdownMenuItem<String>(
                        value: deporte['id'].toString(),
                        child: Text(deporte['name']),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: selectedCategoria,
                    onChanged: (value) {
                      setState(() {
                        selectedCategoria = value;
                        fetchData(); // Llamamos a fetchData cada vez que cambie la categoría seleccionada.
                      });
                    },
                    items: categorias.map((categoria) {
                      return DropdownMenuItem<String>(
                        value: categoria['id'].toString(),
                        child: Text(categoria['name']),
                      );
                    }).toList(),
                  ),
                  DropdownButton<int>(
                    value: selectedTipo,
                    onChanged: (value) {
                      setState(() {
                        selectedTipo = value!;
                        fetchData(); // Llamamos a fetchData cada vez que cambie el tipo seleccionado.
                      });
                    },
                    items: [
                      DropdownMenuItem<int>(
                        value: 0,
                        child: Text('Global'),
                      ),
                      DropdownMenuItem<int>(
                        value: 1,
                        child: Text('Registro Personal'),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: registros.length > 3 ? 3 : registros.length,
                itemBuilder: (context, index) {
                  final registro = registros[index];
                  final deporteName = registro['deporte']['name'];
                  final nombreAtleta = registro['user']['first_name'];
                  final emailAtleta = registro['user']['email'];
                  final categoriaName = registro['categoria']['name'];
                  final duracion = registro['duracion'];

                  return Card(
                    child: ListTile(
                      leading: Icon(iconos[index % iconos.length], size: 50), // Obtiene el ícono correspondiente según el índice del ListView
                      title: Text(nombreAtleta ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(emailAtleta ?? ''),
                          Text(deporteName ?? ''),
                          Text(categoriaName ?? ''),
                          Text('Duración: $duracion segundos'),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              const Center(
                child: Text(
                  'Tiempo de entreno últimos 7 días',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 200,
                child: charts.TimeSeriesChart(
                  _createSampleData(),
                  animate: true,
                  dateTimeFactory: const charts.LocalDateTimeFactory(), // Agrega esta línea para especificar el tipo de dato del eje X.
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LinearSales {
  final DateTime date;
  final int sales;

  LinearSales(this.date, this.sales);
}





