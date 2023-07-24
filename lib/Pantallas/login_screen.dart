import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../LocalStorage.dart';
import 'package:trackfit/Pantallas/register_screen.dart';
import 'package:trackfit/Pantallas/my_home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';
  bool isLoading = false; // Variable para controlar la visibilidad de la pantalla de carga

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final localStorage = LocalStorage();
    await localStorage.init();

    final authToken = localStorage.authToken;
    final userData = localStorage.userData;

    if (authToken != '' && userData != {}) {
      // Datos de inicio de sesión encontrados, redirigir a la pantalla de inicio
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MyHomePage(
                title: 'TrackFit',
                initialIndex: 2,
                onTabSelected: (index) {},
              ),
        ),
      );
    }
  }

  Future<void> login() async {
    // Validar si los campos de usuario y contraseña están vacíos
    if (username.isEmpty || password.isEmpty) {
      showEmptyFieldsError();
      return;
    }

    final url = Uri.parse('http://192.168.0.99:8000/api/login');
    final body = jsonEncode({
      'email': username,
      'password': password,
    });
    final headers = {'Content-Type': 'application/json'};

    try {
      setState(() {
        isLoading = true; // Mostrar pantalla de carga
      });

      final response = await http.post(url, headers: headers, body: body);
      final responseData = jsonDecode(response.body);
      print(responseData);

      setState(() {
        isLoading = false; // Ocultar pantalla de carga
      });
      if (response.statusCode == 200) {
        // La API respondió correctamente, guarda los datos en LocalStorage
        final localStorage = LocalStorage();
        await localStorage.init();
        localStorage.authToken = responseData['token'];
        localStorage.userData = responseData['user'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(
              title: 'TrackFit',
              initialIndex: 2,
              onTabSelected: (index) {},
            ),
          ),
        );
      } else {
        // La API respondió con un error, muestra un cuadro de diálogo de error
        showInvalidCredentialsError();
      }
    } catch (error) {
      setState(() {
        isLoading = false; // Ocultar pantalla de carga
      });
      // Error al hacer la solicitud a la API, muestra un cuadro de diálogo de error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error de conexión'),
          content: Text('Hubo un error al intentar conectarse al servidor.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // Función para mostrar el cuadro de diálogo cuando los campos están vacíos
  void showEmptyFieldsError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error de inicio de sesión'),
        content: Text('Por favor, ingrese un usuario y contraseña.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

// Función para mostrar el cuadro de diálogo cuando los datos no son correctos
  void showInvalidCredentialsError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error de inicio de sesión'),
        content: Text('Credenciales inválidas. Por favor, verifique sus datos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade200, Colors.teal.shade400],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 40),
              Image.asset(
                'assets/images/login_image.png',
                height: 250,
                width: 250,
              ),
              SizedBox(height: 40),
              Expanded( // Agregado Expanded
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              username = value;
                            });
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.white70),
                            prefixIcon: Icon(
                                Icons.email, color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Contraseña',
                            hintStyle: TextStyle(color: Colors.white70),
                            prefixIcon: Icon(Icons.lock, color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: login,
                          child: Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal, // Cambia el color del botón
                            onPrimary: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 60.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Regístrate',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}