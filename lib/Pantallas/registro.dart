import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trackfit/Pantallas/my_home_page.dart';

class Registro extends StatefulWidget {
  const Registro({Key? key}) : super(key: key);

  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  late Timer _timer;
  int _secondsPassed = 0;
  bool _isTimerRunning = false;
  int _currentIndex = 4; // Variable _currentIndex agregada

  final _nombreController = TextEditingController();
  String? _ubicacionValue;
  String? _tipoDeporteValue;
  String? _distanciaValue;

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

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;
    int remainingSeconds = seconds % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  bool _isFormEmpty() {
    return _nombreController.text.isEmpty ||
        _ubicacionValue == null ||
        _tipoDeporteValue == null ||
        _distanciaValue == null;
  }

  void _iniciarTemporizador() {
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
      setState(() {
        _isTimerRunning = true;
      });
      _startTimer();
    }
  }

  void _detenerYGuardar() {
    _stopTimer();
    setState(() {
      _secondsPassed = 0;
      _isTimerRunning = false;
    });

    Navigator.popUntil(context, ModalRoute.withName('/'));

    Future.delayed(Duration.zero, () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MyHomePage(
          title: 'TrackFit',
          onTabSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          initialIndex: 4,
        );
      }));
    });
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
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Ubicación',
                ),
                value: _ubicacionValue,
                items: ['Opción 1', 'Opción 2', 'Opción 3']
                    .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _ubicacionValue = value;
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
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Tipo de deporte',
                ),
                value: _tipoDeporteValue,
                items: ['Opción 1', 'Opción 2', 'Opción 3']
                    .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _tipoDeporteValue = value;
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
                  labelText: 'Distancia',
                ),
                value: _distanciaValue,
                items: ['Opción 1', 'Opción 2', 'Opción 3']
                    .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _distanciaValue = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Seleccione una distancia';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  if (!_isTimerRunning) {
                    _iniciarTemporizador();
                  }
                },
                icon: Icon(Icons.play_arrow),
                label: Text('Iniciar'),
              ),
              SizedBox(height: 32),
              Text(
                'Tiempo transcurrido: ${_formatTime(_secondsPassed)}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _detenerYGuardar,
                child: Text('Detener y guardar'),
              ),
            ],
          );
        },
      ),
    );
  }
}


