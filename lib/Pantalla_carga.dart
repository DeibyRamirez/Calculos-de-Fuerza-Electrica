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
  double _valorProgreso = 0.0;
  final int _totalsegundos = 4;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    EmpezarTiempo();
  }

  void EmpezarTiempo() {
    const unSegundo = Duration(seconds: 1);
    _timer = Timer.periodic(unSegundo, (timer) {
      setState(() {
        if (_valorProgreso >= 1.0) {
          timer.cancel();
        } else {
          _valorProgreso += 1 / _totalsegundos;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var mensaje = _valorProgreso >= 1.0 ? "Entrar" : "Cargando";
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
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Principal()));
                },
                child: Text(mensaje)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _valorProgreso,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
