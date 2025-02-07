// ignore_for_file: file_names, library_private_types_in_public_api, use_super_parameters, avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graficos_dinamicos/CalcularF_TEquilatero.dart';
import 'package:graficos_dinamicos/tabla_prefijos.dart';

class Equilatero extends StatefulWidget {
  const Equilatero({Key? key}) : super(key: key);

  @override
  _EquilateroState createState() => _EquilateroState();
}

class _EquilateroState extends State<Equilatero> {
  final TextEditingController carga1Controller = TextEditingController();
  final TextEditingController carga2Controller = TextEditingController();
  final TextEditingController carga3Controller = TextEditingController();
  final TextEditingController distanciaController = TextEditingController();
  final TextEditingController cargaTrabajoController = TextEditingController();
  late String modelocarga1 = 'assets/Carga_positiva.glb';
  late String modelocarga2 = 'assets/Carga_positiva.glb';
  late String modelocarga3 = 'assets/Carga_positiva.glb';
  late String combinacion3d = 'assets/Caso(+,+,+).glb';
  late String resultante3d =
      'assets/Resultante_Triangulo_EyR/Caso_Resul(+,+,+)_TE_respecto_C1.glb';

//Creación y Uso de los prefijos...

  static const prefijos = <String>['µC', 'nC', 'mC', 'pC'];
  String? prefijoseleccionadoCarga1;
  String? prefijoseleccionadoCarga2;
  String? prefijoseleccionadoCarga3;

// Dando el valor al nombre del prefijo...
  static final Map<String, double> valoresPrefijos = {
    'µC': pow(10, -6).toDouble(),
    'nC': pow(10, -9).toDouble(),
    'mC': pow(10, -3).toDouble(),
    'pC': pow(10, -12).toDouble(),
  };
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
          "Trí Equilatero",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/Equilatero.jpg'),
            const SizedBox(height: 20),
            const Text(
              "Digite los valores de las cargas, Coulombs (C):",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
//Creamos el DropdownButton para permitir visializar las opcines de prefijos que tenemos disponibles...

            DropdownButton<String>(
              hint: const Text("Seleccione un prefijo (q1)"),
              value: prefijoseleccionadoCarga1,
              items: prefijos.map((String prefijo) {
                return DropdownMenuItem<String>(
                  value: prefijo,
                  child: Text(prefijo),
                );
              }).toList(),
              onChanged: (String? nuevoValor) {
                setState(() {
                  prefijoseleccionadoCarga1 = nuevoValor;
                });
              },
            ),
            const SizedBox(height: 5),
            TextField(
              controller: carga1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Carga 1 (q1)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              hint: const Text("Seleccione un prefijo (q2)"),
              value: prefijoseleccionadoCarga2,
              items: prefijos.map((String prefijo) {
                return DropdownMenuItem<String>(
                  value: prefijo,
                  child: Text(prefijo),
                );
              }).toList(),
              onChanged: (String? nuevoValor) {
                setState(() {
                  prefijoseleccionadoCarga2 = nuevoValor;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: carga2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Carga 2 (q2)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              hint: const Text("Seleccione un prefijo (q3)"),
              value: prefijoseleccionadoCarga3,
              items: prefijos.map((String prefijo) {
                return DropdownMenuItem<String>(
                  value: prefijo,
                  child: Text(prefijo),
                );
              }).toList(),
              onChanged: (String? nuevoValor) {
                setState(() {
                  prefijoseleccionadoCarga3 = nuevoValor;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: carga3Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Carga 3 (q3)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              "Digite el valor de la distancia en metros (m):",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: distanciaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'De (q1) a (q2)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              "Digite la carga (q) a trabajar:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: cargaTrabajoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'q1? q2? q3?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Validar que todos los campos estén completos
                if (carga1Controller.text.isEmpty ||
                    carga2Controller.text.isEmpty ||
                    carga3Controller.text.isEmpty ||
                    distanciaController.text.isEmpty ||
                    cargaTrabajoController.text.isEmpty ||
                    prefijoseleccionadoCarga1 == null ||
                    prefijoseleccionadoCarga2 == null ||
                    prefijoseleccionadoCarga3 == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'Por favor complete todos los campos y seleccione los prefijos'),
                  ));
                  return;
                }

                // Obtener los valores de los controladores
                final carga1 = double.parse(carga1Controller.text);
                final carga2 = double.parse(carga2Controller.text);
                final carga3 = double.parse(carga3Controller.text);
                final distancia = double.parse(distanciaController.text);
                final cargaTrabajo =
                    int.tryParse(cargaTrabajoController.text) ?? 0;

                //Convertir la carga usando el prefijo selecionado...

                double carga1Convertida =
                    carga1 * valoresPrefijos[prefijoseleccionadoCarga1]!;
                double carga2Convertida =
                    carga2 * valoresPrefijos[prefijoseleccionadoCarga2]!;
                double carga3Convertida =
                    carga3 * valoresPrefijos[prefijoseleccionadoCarga3]!;

                if (distancia <= 0) {
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

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalFuerzasIsosceles(
                      carga1: carga1,
                      carga2: carga2,
                      carga3: carga3,
                      distancia: distancia,
                      cargaTrabajo: cargaTrabajo,
                      angulo: 60,
                      modelocarga1: modelocarga1,
                      modelocarga2: modelocarga2,
                      modelocarga3: modelocarga3,
                      combinacion3d: combinacion3d,
                      resultante3d: resultante3d,
                      carga1convertida: carga1Convertida,
                      carga2convertida: carga2Convertida,
                      carga3convertida: carga3Convertida,
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
            )
          ],
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
          combinacion3d = 'assets/Caso(-,+,+)_TE_respecto_C1.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,+,+)_TE_respecto_C1.glb';
        }
        if (carga1 < 0 && carga2 > 0 && carga3 > 0 && cargaTrabajar == 2) {
          combinacion3d = 'assets/Caso(-,+,+)_TE_respecto_C2.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,+,+)_TE_respecto_C2.glb';
        }
        if (carga1 < 0 && carga2 > 0 && carga3 > 0 && cargaTrabajar == 3) {
          combinacion3d = 'assets/Caso(-,+,+)_TE_respecto_C3.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,+,+)_TE_respecto_C3.glb';
        }
        if (carga1 < 0 && carga2 < 0 && carga3 > 0 && cargaTrabajar == 1) {
          combinacion3d = 'assets/Caso(-,-,+)_TE_respecto_C1.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,-,+)_TE_respecto_C1.glb';
        }
        if (carga1 < 0 && carga2 < 0 && carga3 > 0 && cargaTrabajar == 2) {
          combinacion3d = 'assets/Caso(-,-,+)_TE_respecto_C2.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,-,+)_TE_respecto_C2.glb';
        }
        if (carga1 < 0 && carga2 < 0 && carga3 > 0 && cargaTrabajar == 3) {
          combinacion3d = 'assets/Caso(-,-,+)_TE_respecto_C3.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,-,+)_TE_respecto_C3.glb';
        }
        if (carga1 < 0 && carga2 < 0 && carga3 < 0 && cargaTrabajar == 1) {
          combinacion3d = 'assets/Caso(-,-,-)_TE_respecto_C1.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,-,-)_TE_respecto_C1.glb';
        }
        if (carga1 < 0 && carga2 < 0 && carga3 < 0 && cargaTrabajar == 2) {
          combinacion3d = 'assets/Caso(-,-,-)_TE_respecto_C2.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,-,-)_TE_respecto_C2.glb';
        }
        if (carga1 < 0 && carga2 < 0 && carga3 < 0 && cargaTrabajar == 3) {
          combinacion3d = 'assets/Caso(-,-,-)_TE_respecto_C3.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,-,-)_TE_respecto_C3.glb';
        }
        if (carga1 > 0 && carga2 > 0 && carga3 > 0 && cargaTrabajar == 1) {
          combinacion3d = 'assets/Caso(+,+,+)_TE_respecto_C1.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,+,+)_TE_respecto_C1.glb';
        }
        if (carga1 > 0 && carga2 > 0 && carga3 > 0 && cargaTrabajar == 2) {
          combinacion3d = 'assets/Caso(+,+,+)_TE_respecto_C2.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,+,+)_TE_respecto_C2.glb';
        }
        if (carga1 > 0 && carga2 > 0 && carga3 > 0 && cargaTrabajar == 3) {
          combinacion3d = 'assets/Caso(+,+,+)_TE_respecto_C3.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,+,+)_TE_respecto_C3.glb';
        }
        if (carga1 > 0 && carga2 > 0 && carga3 < 0 && cargaTrabajar == 1) {
          combinacion3d = 'assets/Caso(+,+,-)_TE_respecto_C1.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,+,-)_TE_respecto_C1.glb';
        }
        if (carga1 > 0 && carga2 > 0 && carga3 < 0 && cargaTrabajar == 2) {
          combinacion3d = 'assets/Caso(+,+,-)_TE_respecto_C2.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,+,-)_TE_respecto_C2.glb';
        }
        if (carga1 > 0 && carga2 > 0 && carga3 < 0 && cargaTrabajar == 3) {
          combinacion3d = 'assets/Caso(+,+,-)_TE_respecto_C3.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,+,-)_TE_respecto_C3.glb';
        }
        if (carga1 > 0 && carga2 < 0 && carga3 < 0 && cargaTrabajar == 1) {
          combinacion3d = 'assets/Caso(+,-,-)_TE_respecto_C1.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,-,-)_TE_respecto_C1.glb';
        }
        if (carga1 > 0 && carga2 < 0 && carga3 < 0 && cargaTrabajar == 2) {
          combinacion3d = 'assets/Caso(+,-,-)_TE_respecto_C2.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,-,-)_TE_respecto_C2.glb';
        }
        if (carga1 > 0 && carga2 < 0 && carga3 < 0 && cargaTrabajar == 3) {
          combinacion3d = 'assets/Caso(+,-,-)_TE_respecto_C3.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,-,-)_TE_respecto_C3.glb';
        }
        if (carga1 < 0 && carga2 > 0 && carga3 < 0 && cargaTrabajar == 1) {
          combinacion3d = 'assets/Caso(-,+,-)_TE_respecto_C1.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,+,-)_TE_respecto_C1.glb';
        }
        if (carga1 < 0 && carga2 > 0 && carga3 < 0 && cargaTrabajar == 2) {
          combinacion3d = 'assets/Caso(-,+,-)_TE_respecto_C2.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,+,-)_TE_respecto_C2.glb';
        }
        if (carga1 < 0 && carga2 > 0 && carga3 < 0 && cargaTrabajar == 3) {
          combinacion3d = 'assets/Caso(-,+,-)_TE_respecto_C3.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(-,+,-)_TE_respecto_C3.glb';
        }
        if (carga1 > 0 && carga2 < 0 && carga3 > 0 && cargaTrabajar == 1) {
          combinacion3d = 'assets/Caso(+,-,+)_TE_respecto_C1.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,-,+)_TE_respecto_C1.glb';
        }
        if (carga1 > 0 && carga2 < 0 && carga3 > 0 && cargaTrabajar == 2) {
          combinacion3d = 'assets/Caso(+,-,+)_TE_respecto_C2.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,-,+)_TE_respecto_C2.glb';
        }
        if (carga1 > 0 && carga2 < 0 && carga3 > 0 && cargaTrabajar == 3) {
          combinacion3d = 'assets/Caso(+,-,+)_TE_respecto_C3.glb';
          resultante3d =
              'assets/Resultantes_Triangulo_EyR/Caso_Resul(+,-,+)_TE_respecto_C3.glb';
        }
      });
    } catch (e) {
      print("Error al cargar modelos 3D: $e");
    }
  }
}
