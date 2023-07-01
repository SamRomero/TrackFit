import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            const CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('assets/profile_picture.jpg'),
            ),
            const SizedBox(height: 40),
            const Text(
              'Nombre: John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            const Text(
              'Usuario: johndoe',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
            const Text(
              'Correo: johndoe@example.com',
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