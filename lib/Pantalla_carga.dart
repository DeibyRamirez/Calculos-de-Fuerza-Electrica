// ignore_for_file: camel_case_types, file_names, non_constant_identifier_names, unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graficos_dinamicos/Principal.dart';

class Pantalla_carga extends StatefulWidget {
  const Pantalla_carga({super.key});

  @override
  State<Pantalla_carga> createState() => _Pantalla_cargaState();
}

class _Pantalla_cargaState extends State<Pantalla_carga> {
  @override
  void initState() {
    super.initState();
    // Espera 5 segundos antes de navegar a la pantalla principal
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Principal()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 10,
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset("assets/Logo_U.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
