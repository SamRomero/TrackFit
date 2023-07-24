import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trackfit/DatabaseHelper.dart';
import 'package:trackfit/Pantallas/my_home_page.dart';
import 'package:http/http.dart' as http;
import '../format_time.dart';
import '../LocalStorage.dart';
import 'dart:convert';

class Registro extends StatefulWidget {
  const Registro({
    Key? key,
    required this.selectedUbication,
  }) : super(key: key);

  final int? selectedUbication;

  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final LocalStorage _localStorage = LocalStorage();
  late Timer _timer;
  int _secondsPassed = 0;
  bool _isTimerRunning = false;
  bool _isTimerStarted = false;
  int? _selectedUbication;
  int? _selectedDeporte;
  final _nombreController = TextEditingController();
  String? _ubicacionValue;
  String? _tipoDeporteValue;
  String? _tipoActividadValue;
  Map<String, dynamic>? _categoriaValue;
  var formatter = FormatTime();
  List<Map<String, dynamic>> _ubicacionOptions = [];
  List<Map<String, dynamic>> _deporteOptions = [];
  List<Map<String, dynamic>> _categoriaOptions = [];
  Map<String, dynamic> user = {};
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _selectedUbication = widget.selectedUbication;
    _localStorage.init();
    user = _localStorage.userData;
    _databaseHelper = DatabaseHelper();
    fetchUbicaciones();
    fetchDeportes();
  }

  @override
  void dispose() {
    _stopTimer();
    _nombreController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _secondsPassed++;
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  bool _isFormEmpty() {
    return _nombreController.text.isEmpty ||
        _ubicacionValue == null ||
        _tipoDeporteValue == null ||
        _tipoActividadValue == null ||
        _categoriaValue == null;
  }

  void _toggleTimer() {
    if (_isFormEmpty()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Por favor, complete todos los campos del formulario.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      if (_isTimerRunning) {
        _stopTimer();
      } else {
        _startTimer();
      }
      setState(() {
        _isTimerRunning = !_isTimerRunning;
        _isTimerStarted = true;
      });
    }
  }

  Future<void> _guardarRegistro() async {
    final url = Uri.parse('http://192.168.0.99:8000/api/registros');
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_localStorage.authToken}',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'user': user['id'],
      'name': _nombreController.text,
      'location': _selectedUbication,
      'deporte': _selectedDeporte,
      'is_actividad': _tipoActividadValue == 'Entreno' ? 0 : 1,
      'categoria': _categoriaValue?['id'],
      'duracion': _secondsPassed,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        setState(() {
          _secondsPassed = 0;
          _isTimerRunning = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(
              title: 'TrackFit',
              initialIndex: 4,
              onTabSelected: (index) {},
            ),
          ),
        );

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Éxito'),
              icon: Icon(Icons.check),
              content: Text('Registro ${responseData['name']} creado con exito'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to save registro data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  void _detenerYGuardar() {
    _stopTimer();
    // Realizar las operaciones de guardado

    try {
      _guardarRegistro();
    } catch (error) {
      print('Error: $error');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('No se pudo guardar el registro en la base de datos.'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> fetchUbicaciones() async {
    final url = Uri.parse('http://192.168.0.99:8000/api/ubicacions');
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_localStorage.authToken}'
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        setState(() {
          _ubicacionOptions = jsonList
              .map((dynamic json) => json as Map<String, dynamic>)
              .toList();
        });

        if (_selectedUbication != null) {
          _ubicacionValue = _ubicacionOptions
              .firstWhere((option) => option['id'] == _selectedUbication)['name'];
        }
      } else {
        throw Exception('Failed to fetch ubicaciones data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> fetchDeportes() async {
    final url = Uri.parse('http://192.168.0.99:8000/api/deportes');
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_localStorage.authToken}'
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        setState(() {
          _deporteOptions = jsonList
              .map((dynamic json) => json as Map<String, dynamic>)
              .toList();
        });
      } else {
        throw Exception('Failed to fetch deportes data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> fetchCategorias(int idDeporte) async {
    final url = Uri.parse('http://192.168.0.99:8000/api/catbydep');
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_localStorage.authToken}'
    };
    final body = {'id_deporte': idDeporte.toString()};

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        setState(() {
          _categoriaOptions = jsonList
              .map((dynamic json) => json as Map<String, dynamic>)
              .toList();
          _categoriaValue = null; // Reiniciar el valor de categoría al cambiar el deporte
        });
      } else {
        throw Exception('Failed to fetch categorias data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Center(
                child: Text(
                  'Contenido de Registro',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Map<String, dynamic>>(
                decoration: InputDecoration(
                  labelText: 'Ubicación',
                ),
                value: _ubicacionValue != null
                    ? _ubicacionOptions.firstWhere(
                        (option) => option['name'] == _ubicacionValue)
                    : null,
                items: _ubicacionOptions
                    .map((option) => DropdownMenuItem<Map<String, dynamic>>(
                  value: option,
                  child: Text(option['name']),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUbication = value?['id'];
                    _ubicacionValue = value?['name'];
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Seleccione una ubicación';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Map<String, dynamic>>(
                decoration: InputDecoration(
                  labelText: 'Tipo de deporte',
                ),
                value: _tipoDeporteValue != null
                    ? _deporteOptions.firstWhere(
                        (option) => option['name'] == _tipoDeporteValue)
                    : null,
                items: _deporteOptions
                    .map((option) => DropdownMenuItem<Map<String, dynamic>>(
                  value: option,
                  child: Text(option['name']),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDeporte = value?['id'];
                    _tipoDeporteValue = value?['name'];
                    fetchCategorias(value?['id']);
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Seleccione un tipo de deporte';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Tipo de Actividad',
                ),
                value: _tipoActividadValue,
                items: ['Entreno', 'Competencia Oficial']
                    .map((value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _tipoActividadValue = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Seleccione un tipo de actividad';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Map<String, dynamic>>(
                decoration: InputDecoration(
                  labelText: 'Categoría',
                ),
                value: _categoriaValue,
                items: _categoriaOptions
                    .map((option) => DropdownMenuItem<Map<String, dynamic>>(
                  value: option,
                  child: Text(option['name']),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _categoriaValue = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Seleccione una categoría';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _toggleTimer,
                icon: Icon(
                    _isTimerRunning ? Icons.pause : Icons.play_arrow),
                label: Text(_isTimerRunning ? 'Pausa' : 'Iniciar'),
              ),
              SizedBox(height: 32),
              Text(
                'Tiempo transcurrido: ${formatter.formatTime(_secondsPassed)}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 32),
              if (_isTimerStarted && !_isTimerRunning) ...[
                ElevatedButton(
                  onPressed: _detenerYGuardar,
                  child: Text('Guardar'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}







