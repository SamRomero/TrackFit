import 'package:flutter/material.dart';
import '../LocalStorage.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _localStorage = LocalStorage(); // Creamos una instancia de LocalStorage

    // Aquí obtenemos los datos del usuario desde el LocalStorage
    final Map<String, dynamic> userData = _localStorage.userData;

    // Extraemos los valores del mapa
    final String nombre = userData['first_name'] ?? 'Nombre desconocido';
    final String apellido = userData['last_name'] ?? 'Nombre desconocido';
    final String usuario = userData['username'] ?? 'Usuario desconocido';
    final String email = userData['email'] ?? 'Correo desconocido';

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuario'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 100,
              backgroundColor: Colors.lightGreen, // Color de fondo del avatar
              child:
            Image.asset(
              'assets/images/user_icon.png',
              height: 130,
              width: 130,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Nombre: $nombre $apellido',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Text(
              'Usuario: $usuario',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
            Text(
              'Correo: $email',
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () {
                  // Lógica para grabar el comando
                },
                child: Icon(Icons.mic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
