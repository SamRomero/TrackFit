import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Estadisticas extends StatelessWidget {
  const Estadisticas({Key? key}) : super(key: key);

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
                    value: 'Opción 1',
                    onChanged: (value) {},
                    items: <String>['Opción 1', 'Opción 2', 'Opción 3']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: 'Opción 1',
                    onChanged: (value) {},
                    items: <String>['Opción 1', 'Opción 2', 'Opción 3']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: 'Opción 1',
                    onChanged: (value) {},
                    items: <String>['Opción 1', 'Opción 2', 'Opción 3']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: Icon(Icons.looks_one_rounded, size: 50),
                  title: Text('Título 1'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Label 1'),
                      Text('Label 2'),
                      Text('Label 3'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: Icon(Icons.looks_two_rounded, size: 50),
                  title: Text('Título 2'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Label 1'),
                      Text('Label 2'),
                      Text('Label 3'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: Icon(Icons.looks_3, size: 50),
                  title: Text('Título 3'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Label 1'),
                      Text('Label 2'),
                      Text('Label 3'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 200,
                child: charts.LineChart(
                  _createSampleData(),
                  animate: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      LinearSales(0, 5),
      LinearSales(1, 25),
      LinearSales(2, 100),
      LinearSales(3, 75),
      LinearSales(4, 33),
      LinearSales(5, 80),
    ];

    return [
      charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
