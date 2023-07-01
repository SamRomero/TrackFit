import 'package:flutter/material.dart';

class Registros extends StatelessWidget {
  const Registros({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: const [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Registros',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.directions_run, size: 50),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mi registro primer día'),
                            SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('5 metros'),
                                Text('5 minutos'),
                                Text('Carreras a pie'),
                                Text('Polideportivo'),
                                Text('27/06/2023'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.water, size: 50),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Título de la Tarjeta 2'),
                            SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('5 metros'),
                                Text('5 minutos'),
                                Text('Carreras a pie'),
                                Text('Polideportivo'),
                                Text('27/06/2023'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.directions_bike_outlined, size: 50),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Título de la Tarjeta 3'),
                            SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('5 metros'),
                                Text('5 minutos'),
                                Text('Carreras a pie'),
                                Text('Polideportivo'),
                                Text('27/06/2023'),
                              ],
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
        ],
      ),
    );
  }
}
