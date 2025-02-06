// ignore_for_file: file_names, library_private_types_in_public_api, use_super_parameters, avoid_print

import 'package:flutter/material.dart';
import 'package:graficos_dinamicos/CalcularF_TResctangulo3d.dart';
import 'package:graficos_dinamicos/tabla_prefijos.dart';

class Rectangulo extends StatefulWidget {
  const Rectangulo({Key? key}) : super(key: key);

  @override
  _RectanguloState createState() => _RectanguloState();
}

class _RectanguloState extends State<Rectangulo> {
  TextEditingController carga1Controller = TextEditingController();
  TextEditingController carga2Controller = TextEditingController();
  TextEditingController carga3Controller = TextEditingController();
  TextEditingController distancia12Controller = TextEditingController();
  TextEditingController distancia23Controller = TextEditingController();
  TextEditingController distancia13Controller = TextEditingController();
  TextEditingController cargaTrabajoController = TextEditingController();
  TextEditingController anguloController = TextEditingController();
  late String modelocarga1 = 'assets/Carga_positiva.glb';
  late String modelocarga2 = 'assets/Carga_positiva.glb';
  late String modelocarga3 = 'assets/Carga_positiva.glb';
  late String combinacion3d = 'assets/Caso(+,+,+).glb';
  late String resultante3d =
      'assets/Resultante_Triangulo_EyR/Caso_Resul(+,+,+)_TR_respecto_C1.glb';
  @override
  void dispose() {
    // Dispose los controladores al finalizar
    carga1Controller.dispose();
    carga2Controller.dispose();
    carga3Controller.dispose();
    distancia12Controller.dispose();
    distancia23Controller.dispose();
    distancia13Controller.dispose();
    cargaTrabajoController.dispose();
    anguloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const tabla_prefijos(),
                    ));
              },
              icon: const Icon(Icons.wysiwyg))
        ],
        backgroundColor: Colors.blue,
        title: const Text(
          "Trí Rectángulo",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/Triangulo_Rectangulo.jpg'),
              const SizedBox(height: 20),
              const Text(
                "Digite los valores de las cargas, Coulombs (C):",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: carga1Controller,
                decoration: const InputDecoration(
                  labelText: 'Carga 1 (q1)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: carga2Controller,
                decoration: const InputDecoration(
                  labelText: 'Carga 2 (q2)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: carga3Controller,
                decoration: const InputDecoration(
                  labelText: 'Carga 3 (q3)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
              ),
              const SizedBox(height: 50),
              const Text(
                "Digite el valor de la distancia en metros (m):",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: distancia12Controller,
                decoration: const InputDecoration(
                  labelText: 'De (q1) a (q2), Lado opuesto',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: distancia23Controller,
                decoration: const InputDecoration(
                  labelText: 'De (q2) a (q3), Lado Adyacente',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: distancia13Controller,
                decoration: const InputDecoration(
                  labelText: 'De (q1) a (q3), Usa Pitagoras...',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
              ),
              const SizedBox(height: 50),
              const Text(
                "Digite la carga (q) a trabajar:",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: cargaTrabajoController,
                decoration: const InputDecoration(
                  labelText: 'q1? q2? q3?',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
              ),
              const SizedBox(height: 10),
              const Text(
                "Digite el ángulo:",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: anguloController,
                decoration: const InputDecoration(
                  labelText: 'ʘ?, Usa [Tan^-1(opuesto/Adyacente)]',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // Obtener los valores de los TextField
                  double carga1 = double.tryParse(carga1Controller.text) ?? 0;
                  double carga2 = double.tryParse(carga2Controller.text) ?? 0;
                  double carga3 = double.tryParse(carga3Controller.text) ?? 0;
                  double distancia12 =
                      double.tryParse(distancia12Controller.text) ?? 0;
                  double distancia23 =
                      double.tryParse(distancia23Controller.text) ?? 0;
                  double distancia13 =
                      double.tryParse(distancia13Controller.text) ?? 0;
                  int cargaTrabajo =
                      int.tryParse(cargaTrabajoController.text) ?? 0;
                  double angulo = double.tryParse(anguloController.text) ?? 0;

                  // Validar que los valores no sean 0 o negativos
                  if (distancia12 <= 0 ||
                      distancia23 <= 0 ||
                      distancia13 <= 0) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Error"),
                        content:
                            const Text("Las distancias deben ser mayores a 0."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  if (carga1 == 0 || carga2 == 0 || carga3 == 0) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Error"),
                        content:
                            const Text("Las cargas no deben ser iguales a 0."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  modelo3d(carga1, carga2, carga3, cargaTrabajo);

                  // Navegar a la pantalla de cálculo
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalFuerzasRectangulo(
                        carga1: carga1,
                        carga2: carga2,
                        carga3: carga3,
                        distancia12: distancia12,
                        distancia23: distancia23,
                        distancia13: distancia13,
                        cargaTrabajo: cargaTrabajo,
                        angulo: angulo,
                        combinacion3d: combinacion3d,
                        modelocarga1: modelocarga1,
                        modelocarga2: modelocarga2,
                        modelocarga3: modelocarga3,
                        resultante3d: resultante3d,
                      ),
                    ),
                  );
                },
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                child: const Text(
                  "Calcular",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void modelo3d(
      double carga1, double carga2, double carga3, int cargaTrabajar) {
    try {
      setState(() {
        modelocarga1 = carga1 < 0
            ? 'assets/Carga_negativa.glb'
            : 'assets/Carga_positiva.glb';
        modelocarga2 = carga2 < 0
            ? 'assets/Carga_negativa.glb'
            : 'assets/Carga_positiva.glb';
        modelocarga3 = carga3 < 0
            ? 'assets/Carga_negativa.glb'
            : 'assets/Carga_positiva.glb';

        if (carga1 < 0 && carga2 > 0 && carga3 > 0 && cargaTrabajar == 1) {
          combinacion3d = 'assets/Caso(-,+,+)_TR_respecto_C1.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,+,+)_TR_respecto_C1.glb';
        }
        if (carga1 < 0 && carga2 > 0 && carga3 > 0 && cargaTrabajar == 2) {
          combinacion3d = 'assets/Caso(-,+,+)_TR_respecto_C2.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,+,+)_TR_respecto_C2.glb';
        }
        if (carga1 < 0 && carga2 > 0 && carga3 > 0 && cargaTrabajar == 3) {
          combinacion3d = 'assets/Caso(-,+,+)_TR_respecto_C3.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,+,+)_TR_respecto_C3.glb';
        }
        if (carga1 < 0 && carga2 < 0 && carga3 > 0 && cargaTrabajar == 1) {
          combinacion3d = 'assets/Caso(-,-,+)_TR_respecto_C1.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,-,+)_TR_respecto_C1.glb';
        }
        if (carga1 < 0 && carga2 < 0 && carga3 > 0 && cargaTrabajar == 2) {
          combinacion3d = 'assets/Caso(-,-,+)_TR_respecto_C2.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,-,+)_TR_respecto_C2.glb';
        }
        if (carga1 < 0 && carga2 < 0 && carga3 > 0 && cargaTrabajar == 3) {
          combinacion3d = 'assets/Caso(-,-,+)_TR_respecto_C3.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,-,+)_TR_respecto_C3.glb';
        }
        if (carga1 < 0 && carga2 < 0 && carga3 < 0 && cargaTrabajar == 1) {
          combinacion3d = 'assets/Caso(-,-,-)_TR_respecto_C1.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,-,-)_TR_respecto_C1.glb';
        }
        if (carga1 < 0 && carga2 < 0 && carga3 < 0 && cargaTrabajar == 2) {
          combinacion3d = 'assets/Caso(-,-,-)_TR_respecto_C2.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,-,-)_TR_respecto_C2.glb';
        }
        if (carga1 < 0 && carga2 < 0 && carga3 < 0 && cargaTrabajar == 3) {
          combinacion3d = 'assets/Caso(-,-,-)_TR_respecto_C3.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,-,-)_TR_respecto_C3.glb';
        }
        if (carga1 > 0 && carga2 > 0 && carga3 > 0 && cargaTrabajar == 1) {
          combinacion3d = 'assets/Caso(+,+,+)_TR_respecto_C1.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,+,+)_TR_respecto_C1.glb';
        }
        if (carga1 > 0 && carga2 > 0 && carga3 > 0 && cargaTrabajar == 2) {
          combinacion3d = 'assets/Caso(+,+,+)_TR_respecto_C2.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,+,+)_TR_respecto_C2.glb';
        }
        if (carga1 > 0 && carga2 > 0 && carga3 > 0 && cargaTrabajar == 3) {
          combinacion3d = 'assets/Caso(+,+,+)_TR_respecto_C3.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,+,+)_TR_respecto_C3.glb';
        }
        if (carga1 > 0 && carga2 > 0 && carga3 < 0 && cargaTrabajar == 1) {
          combinacion3d = 'assets/Caso(+,+,-)_TR_respecto_C1.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,+,-)_TR_respecto_C1.glb';
        }
        if (carga1 > 0 && carga2 > 0 && carga3 < 0 && cargaTrabajar == 2) {
          combinacion3d = 'assets/Caso(+,+,-)_TR_respecto_C2.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,+,-)_TR_respecto_C2.glb';
        }
        if (carga1 > 0 && carga2 > 0 && carga3 < 0 && cargaTrabajar == 3) {
          combinacion3d = 'assets/Caso(+,+,-)_TR_respecto_C3.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,+,-)_TR_respecto_C3.glb';
        }
        if (carga1 > 0 && carga2 < 0 && carga3 < 0 && cargaTrabajar == 1) {
          combinacion3d = 'assets/Caso(+,-,-)_TR_respecto_C1.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,-,-)_TR_respecto_C1.glb';
        }
        if (carga1 > 0 && carga2 < 0 && carga3 < 0 && cargaTrabajar == 2) {
          combinacion3d = 'assets/Caso(+,-,-)_TR_respecto_C2.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,-,-)_TR_respecto_C2.glb';
        }
        if (carga1 > 0 && carga2 < 0 && carga3 < 0 && cargaTrabajar == 3) {
          combinacion3d = 'assets/Caso(+,-,-)_TR_respecto_C3.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,-,-)_TR_respecto_C3.glb';
        }
        if (carga1 < 0 && carga2 > 0 && carga3 < 0 && cargaTrabajar == 1) {
          combinacion3d = 'assets/Caso(-,+,-)_TR_respecto_C1.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,+,-)_TR_respecto_C1.glb';
        }
        if (carga1 < 0 && carga2 > 0 && carga3 < 0 && cargaTrabajar == 2) {
          combinacion3d = 'assets/Caso(-,+,-)_TR_respecto_C2.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,+,-)_TR_respecto_C2.glb';
        }
        if (carga1 < 0 && carga2 > 0 && carga3 < 0 && cargaTrabajar == 3) {
          combinacion3d = 'assets/Caso(-,+,-)_TR_respecto_C3.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,+,-)_TR_respecto_C3.glb';
        }
        if (carga1 > 0 && carga2 < 0 && carga3 > 0 && cargaTrabajar == 1) {
          combinacion3d = 'assets/Caso(+,-,+)_TR_respecto_C1.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,-,+)_TR_respecto_C1.glb';
        }
        if (carga1 > 0 && carga2 < 0 && carga3 > 0 && cargaTrabajar == 2) {
          combinacion3d = 'assets/Caso(+,-,+)_TR_respecto_C2.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,-,+)_TR_respecto_C2.glb';
        }
        if (carga1 > 0 && carga2 < 0 && carga3 > 0 && cargaTrabajar == 3) {
          combinacion3d = 'assets/Caso(+,-,+)_TR_respecto_C3.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,-,+)_TR_respecto_C3.glb';
        }
      });
    } catch (e) {
      print("Error al cargar modelos 3D: $e");
    }
  }
}
