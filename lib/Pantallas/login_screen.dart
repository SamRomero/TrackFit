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
            builder: (context) =>
                MyHomePage(
                  title: 'TrackFit',
                  initialIndex: 2,
                  onTabSelected: (index) {},
                ),
          ),
        );

      } else {
        // La API respondió con un error, muestra un diálogo de error

      }
    } catch (error) {
      setState(() {
        isLoading = false; // Ocultar pantalla de carga
      });
      // Error al hacer la solicitud a la API, muestra un diálogo de error

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 30),
                  Container(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/images/login_image.png'), //cambia esto por tu icono de usuario y borra este comentario
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //este textfield modificalo para que quede como los tuyos solo asegurate de dejar el onchanged y personaliza el resto a como los tengas
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              username = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        //igual este textfield modificalo para que tenga el estilo de tu app
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Contraseña',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'No tienes cuenta ?               ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black38,
                                  ),
                                ),
                                TextSpan(
                                  text: '        Registrate',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.teal, //cambia el color por tu color de acento
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10), // Agregamos espacio adicional entre los botones
                        ElevatedButton(
                          onPressed: login,
                          child: Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          //podes modificar esto para cambiar el estilo del boton
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.teal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isLoading, // Mostrar pantalla de carga solo si isLoading es true
            child: Container(
              color: Colors.black87,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}