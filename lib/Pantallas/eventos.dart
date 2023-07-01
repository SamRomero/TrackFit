import 'package:flutter/material.dart';

class Eventos extends StatelessWidget {
  const Eventos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView( // Utilizamos un ListView para permitir el desplazamiento vertical
        padding: const EdgeInsets.all(8), // Agregamos un padding general al ListView
        children: const [
          Align(
            alignment: Alignment.topCenter, // Alineación en la parte superior del cuerpo
            child: Padding(
              padding: EdgeInsets.only(top: 20), // Espacio superior de 20 unidades
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Alineación del texto en la parte superior
                children: [
                  Text(
                    'Eventos Recreativos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.all(8), // Margen alrededor de la tarjeta
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.sports_basketball, size: 100, color: Colors.orange),
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 8), // Padding inferior
                          child: Text('Torneo Baloncesto'),
                        ),
                        subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris et sem eu odio accumsan ultrices. Duis sollicitudin risus sit amet semper sollicitudin. Aenean ornare iaculis ligula, a placerat justo faucibus ut. Mauris in volutpat metus'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8), // Margen alrededor de la tarjeta
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.sports_soccer, size: 100, color: Colors.green),
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 8), // Padding inferior
                          child: Text('Torneo Fútbol'),
                        ),
                        subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris et sem eu odio accumsan ultrices. Duis sollicitudin risus sit amet semper sollicitudin. Aenean ornare iaculis ligula, a placerat justo faucibus ut. Mauris in volutpat metus'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8), // Margen alrededor de la tarjeta
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.water_outlined, size: 100, color: Colors.blue),
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 8), // Padding inferior
                          child: Text('Torneo Natación'),
                        ),
                        subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris et sem eu odio accumsan ultrices. Duis sollicitudin risus sit amet semper sollicitudin. Aenean ornare iaculis ligula, a placerat justo faucibus ut. Mauris in volutpat metus'),
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