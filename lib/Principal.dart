// ignore_for_file: file_names, use_super_parameters

import 'package:flutter/material.dart';
import 'package:graficos_dinamicos/Lineal_datos.dart';
import 'package:graficos_dinamicos/T_Equilatero_datos.dart';
import 'package:graficos_dinamicos/T_Rectangulo_datos.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  // Lista de ejemplos...

  final List<Map<String, dynamic>> ejemplos = [
    {
      'nombre': 'Lineal',
      'imagen': 'assets/Lineal.jpg',
      'widget': const Lineal_datos(),
    },
    {
      'nombre': 'Triangulo Rectangulo',
      'imagen': 'assets/Triangulo_Rectangulo.jpg',
      'widget': const Rectangulo(),
    },
    {
      'nombre': 'Triangulo Equilatero',
      'imagen': 'assets/Equilatero.jpg',
      'widget': const Equilatero(),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Fuerzas Eléctricas",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                "Selecciona el Diagrama de tu ejercicio: ",
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 10),
              Column(
                children: ejemplos.map((ejemplo) {
                  return EjemploCard(
                    nombre: ejemplo['nombre'],
                    imagen: ejemplo['imagen'],
                    widgetDestino: ejemplo['widget'],
                    context: context,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Widget personalizado para cada ejemplo...

class EjemploCard extends StatelessWidget {
  final String nombre;
  final String imagen;
  final Widget widgetDestino;
  final BuildContext context;

  const EjemploCard({
    Key? key,
    required this.nombre,
    required this.imagen,
    required this.widgetDestino,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Text(
            nombre,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Image.asset(imagen),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => widgetDestino),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text(
              'Ingresar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
