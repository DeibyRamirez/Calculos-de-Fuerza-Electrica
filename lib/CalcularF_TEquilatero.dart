// ignore_for_file: use_super_parameters, library_private_types_in_public_api, unused_local_variable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:graficos_dinamicos/Informacion.dart';
import 'NotacionCientifica.dart';

//Todos los cambios nesesarios ya fueron creados...
class CalFuerzasIsosceles extends StatefulWidget {
  final int cargaTrabajo;
  final double carga1;
  final double carga2;
  final double carga3;
  final double distancia;
  final double angulo;
  final String modelocarga1;
  final String modelocarga2;
  final String modelocarga3;
  final String combinacion3d;
  final String resultante3d;
  final double carga1convertida;
  final double carga2convertida;
  final double carga3convertida;

  const CalFuerzasIsosceles(
      {Key? key,
      required this.cargaTrabajo,
      required this.carga1,
      required this.carga2,
      required this.carga3,
      required this.distancia,
      required this.angulo,
      required this.modelocarga1,
      required this.modelocarga2,
      required this.modelocarga3,
      required this.combinacion3d,
      required this.resultante3d,
      required this.carga1convertida,
      required this.carga2convertida,
      required this.carga3convertida})
      : super(key: key);

  @override
  _CalFuerzasIsoscelesState createState() => _CalFuerzasIsoscelesState();
}

class _CalFuerzasIsoscelesState extends State<CalFuerzasIsosceles> {
  String mensajeResultadoC1 = '';
  String mensajeResultadoC2 = '';
  String mensajeResultadoC3 = '';
  String mensajeComponentesC1 = '';
  String mensajeComponentesC2 = '';
  String mensajeComponentesC3 = '';
  String mensajeFresultanteC1 = '';
  String mensajeFresultanteC2 = '';
  String mensajeFresultanteC3 = '';
  String mensajesumasC1 = '';
  String mensajesumasC2 = '';
  String mensajesumasC3 = '';
  bool estaPlay = false;
  bool resultPlay = false;
  bool mostrarResultante = false;

  int signoX1 = 1;
  int signoY1 = 1;
  int signoX2 = 1;
  int signoY2 = 1;

  late final Flutter3DController _controller;
  late final Flutter3DController _controllerResult;

  final notacionCientifica = Notacioncientifica();

  @override
  void initState() {
    super.initState();
    _controller = Flutter3DController();
    _controllerResult = Flutter3DController();
  }

  void actualizarMensajes() {
    double fuerza12 = calcularFuerza(
        widget.carga1convertida, widget.carga2convertida, widget.distancia);
    double fuerza13 = calcularFuerza(
        widget.carga1convertida, widget.carga3convertida, widget.distancia);

    double f1componenteX = componentesX(fuerza12 * signoX1, widget.angulo);
    double f1componenteY = componentesY(fuerza12 * signoY1, widget.angulo);

    double f2componenteX = componentesX(fuerza13 * signoX2, widget.angulo);
    double f2componenteY = componentesY(fuerza13 * signoY2, widget.angulo);

    mensajeResultadoC1 =
        "Fuerza entre cargas 1 y 2: \n${notacionCientifica.formatearNotacionCientifica(fuerza12, 2)} N\n\nFuerza entre cargas 1 y 3: \n${notacionCientifica.formatearNotacionCientifica(fuerza13, 2)} N";

    //Realice este cambio para que funcione de manera correcta al momento de escoger el signo de la fuerza23 y ademas para mostrar los mensajes de fuerzas con signo
    if (widget.carga2convertida > 0 &&
            widget.carga3convertida > 0 &&
            widget.carga1convertida < 0 ||
        widget.carga2convertida < 0 &&
            widget.carga3convertida < 0 &&
            widget.carga1convertida > 0) {
      fuerza12 = fuerza12 * -1;
      fuerza13 = fuerza13 * -1;
    }
    if (widget.carga2convertida < 0 &&
            widget.carga3convertida > 0 &&
            widget.carga1convertida < 0 ||
        widget.carga2convertida > 0 &&
            widget.carga3convertida < 0 &&
            widget.carga1convertida > 0) {
      fuerza13 = fuerza13 * -1;
    }
    if (widget.carga2convertida > 0 &&
            widget.carga3convertida < 0 &&
            widget.carga1convertida < 0 ||
        widget.carga2convertida < 0 &&
            widget.carga3convertida > 0 &&
            widget.carga1convertida > 0) {
      fuerza12 = fuerza12 * -1;
    }
    mensajeComponentesC1 =
        " Componentes de la Fuerza (1,2):\n X = ${notacionCientifica.formatearNotacionCientifica(f1componenteX, 2)}  \n Y = ${notacionCientifica.formatearNotacionCientifica(f1componenteY, 2)}  \n\nComponentes de la Fuerza (1,3):\n X = ${notacionCientifica.formatearNotacionCientifica(f2componenteX, 2)}  \n Y = ${notacionCientifica.formatearNotacionCientifica(f2componenteY, 2)} ";

    double fuerzaresultanteX = f1componenteX + f2componenteX;
    double fuerzaresultanteY = f1componenteY + f2componenteY;

    mensajesumasC1 =
        "La suma de la fuerzas en X es:\n ${notacionCientifica.formatearNotacionCientifica(fuerzaresultanteX, 2)} (i) \n\nLa suma de la fuerzas en Y es:\n ${notacionCientifica.formatearNotacionCientifica(fuerzaresultanteY, 2)} (j) ";

    double fuerzaresultante = Fresultante(fuerzaresultanteX, fuerzaresultanteY);

    mensajeFresultanteC1 =
        "${notacionCientifica.formatearNotacionCientifica(fuerzaresultante, 2)} N";
    ////////////////////////////////////////////

    double fuerza21 = calcularFuerza(
        widget.carga1convertida, widget.carga2convertida, widget.distancia);
    double fuerza23 = calcularFuerza(
        widget.carga2convertida, widget.carga3convertida, widget.distancia);

    double f1componenteXC2 = componentesX(fuerza21 * signoX1, widget.angulo);
    double f1componenteYC2 = componentesY(fuerza21 * signoY1, widget.angulo);

    double f2componenteXC2 = componentesX(fuerza23 * signoX2, widget.angulo);
    double f2componenteYC2 = componentesY(fuerza23 * signoY2,
        widget.angulo); // No tocar los angulos, todo funciona melo

    mensajeResultadoC2 =
        "Fuerza entre cargas 2 y 1: \n${notacionCientifica.formatearNotacionCientifica(fuerza21, 2)} N\n\nFuerza entre cargas 2 y 3: \n${notacionCientifica.formatearNotacionCientifica(fuerza23, 2)} N";

    //Realice este cambio para que funcione de manera correcta al momento de escoger el signo de la fuerza23
    if (widget.carga2convertida > 0 && widget.carga3convertida > 0 ||
        widget.carga2convertida < 0 && widget.carga3convertida < 0) {
      fuerza23 = fuerza23 * -1;
    }

    if (widget.carga2convertida > 0 &&
            widget.carga3convertida > 0 &&
            widget.carga1convertida > 0 ||
        widget.carga2convertida < 0 &&
            widget.carga3convertida < 0 &&
            widget.carga1convertida < 0 ||
        widget.carga2convertida > 0 &&
            widget.carga3convertida < 0 &&
            widget.carga1convertida > 0 ||
        widget.carga2convertida < 0 &&
            widget.carga3convertida > 0 &&
            widget.carga1convertida < 0) {
      fuerza21 = fuerza21 * -1;
    }
    mensajeComponentesC2 =
        " Componentes de la Fuerza (2,1):\n X = ${notacionCientifica.formatearNotacionCientifica(f1componenteXC2, 2)} N\n Y = ${notacionCientifica.formatearNotacionCientifica(f1componenteYC2, 2)} N\n\n Componentes de la Fuerza(2,3):\n X = ${notacionCientifica.formatearNotacionCientifica(fuerza23, 2)}  N\n Y = 0 N ";

    double fuerzaresultanteXC2 = f1componenteXC2 + fuerza23;
    double fuerzaresultanteYC2 = f1componenteYC2 + 0;

    mensajesumasC2 =
        "La suma de la fuerzas en X es:\n ${notacionCientifica.formatearNotacionCientifica(fuerzaresultanteXC2, 2)} (i) \n\nLa suma de la fuerzas en Y es:\n ${notacionCientifica.formatearNotacionCientifica(fuerzaresultanteYC2, 2)} (j) ";

    double fuerzaresultanteC2 =
        Fresultante(fuerzaresultanteXC2, fuerzaresultanteYC2);

    mensajeFresultanteC2 =
        "${notacionCientifica.formatearNotacionCientifica(fuerzaresultanteC2, 2)} N";

    /////////////////////////////////////////////

    double fuerza31 = calcularFuerza(
        widget.carga1convertida, widget.carga3convertida, widget.distancia);
    double fuerza32 = calcularFuerza(
        widget.carga2convertida, widget.carga3convertida, widget.distancia);

    double f1componenteXC3 = componentesX(fuerza31 * signoX1, widget.angulo);
    double f1componenteYC3 = componentesY(fuerza31 * signoY1, widget.angulo);

    double f2componenteXC3 = componentesX(fuerza23 * signoX2, widget.angulo);
    double f2componenteYC3 = componentesY(fuerza23 * signoY2, widget.angulo);

    mensajeResultadoC3 =
        "Fuerza entre cargas 3 y 1: \n${notacionCientifica.formatearNotacionCientifica(fuerza31, 2)} N\n\nFuerza entre cargas 3 y 2: \n${notacionCientifica.formatearNotacionCientifica(fuerza32, 2)} N";

    //Realice este cambio para que funcione de manera correcta al momento de escoger el signo de la fuerza32
    if (widget.carga2convertida > 0 && widget.carga3convertida < 0 ||
        widget.carga2convertida < 0 && widget.carga3convertida > 0) {
      fuerza32 = fuerza32 * -1;
    }
    if (widget.carga2convertida > 0 &&
            widget.carga3convertida > 0 &&
            widget.carga1convertida > 0 ||
        widget.carga2convertida < 0 &&
            widget.carga3convertida < 0 &&
            widget.carga1convertida < 0) {
      fuerza31 = fuerza31 * -1;
    }
    mensajeComponentesC3 =
        "Componentes de la Fuerza (3,1): \n X = ${notacionCientifica.formatearNotacionCientifica(f1componenteXC3, 2)}  \n Y = ${notacionCientifica.formatearNotacionCientifica(f1componenteYC3, 2)}  \n\nComponentes de la Fuerza (3,2):\nX = ${notacionCientifica.formatearNotacionCientifica(fuerza32, 2)} N\nY = 0 N";

    double fuerzaresultanteXC3 = f1componenteXC3 + fuerza32;
    double fuerzaresultanteYC3 = f1componenteYC3 + 0;

    double fuerzaresultanteC3 =
        Fresultante(fuerzaresultanteXC3, fuerzaresultanteYC3);

    mensajesumasC3 =
        "La suma de la fuerzas en X es:\n ${notacionCientifica.formatearNotacionCientifica(fuerzaresultanteXC3, 2)} (i) \n\nLa suma de la fuerzas en Y es:\n ${notacionCientifica.formatearNotacionCientifica(fuerzaresultanteYC3, 2)} (j) ";

    mensajeFresultanteC3 = "${notacionCientifica.formatearNotacionCientifica(fuerzaresultanteC3, 2)} N";
  }

  double calcularFuerza(double q1, double q2, double r) {
    const k = 8990000000; // Constante de Coulomb en Nm²/C²
    q2 = q2.abs();
    q1 = q1.abs();
    return k * (q1 * q2) / pow(r, 2); // Fórmula de Coulomb
  }

  double componentesX(double fuerza, double angulo) {
    double anguloRadianes = angulo * (pi / 180); // Convertir a radianes
    double componenteX = fuerza * cos(anguloRadianes);
    return componenteX; // Retorna la componente X
  }

  double componentesY(double fuerza, double angulo) {
    double anguloRadianes = angulo * (pi / 180); // Convertir a radianes
    double componenteY = fuerza * sin(anguloRadianes); // Utiliza la función sin
    return componenteY; // Retorna la componente Y
  }

  double Fresultante(double componentex, double componentey) {
    double Ft = sqrt(pow(componentex, 2) + pow(componentey, 2));
    return Ft;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.cargaTrabajo) {
      case 1:
        return _buildCase1();
      case 2:
        return _buildCase2();
      case 3:
        return _buildCase3();
      default:
        return Scaffold(
          appBar: AppBar(
            title: const Text("Fuerza Eléctrica"),
            centerTitle: true,
          ),
          body: const Center(
            child: Text('Carga de trabajo no válida'),
          ),
        );
    }
  }

  Widget _buildCase1() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Fuerza Eléctrica",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Informacion()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        const Text(
                          "Carga N1",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 160,
                          width: 100,
                          child: Flutter3DViewer(
                            controller: _controller,
                            src: widget.modelocarga1,
                            progressBarColor: Colors.blue,
                            activeGestureInterceptor: true,
                            enableTouch: true,
                            onProgress: (double progressValue) {
                              debugPrint(
                                  'Carga del Modelo en Proceso : $progressValue');
                            },
                            onLoad: (String modelAddress) {
                              debugPrint('Modelo Cargando : $modelAddress');
                            },
                            onError: (String error) {
                              debugPrint('Modelo Fallo al Cargar : $error');
                            },
                          ),
                        ),
                        Text(
                          ' ${widget.carga1.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        const Text(
                          "Carga N2",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 160,
                          width: 100,
                          child: Flutter3DViewer(
                            controller: _controller,
                            src: widget.modelocarga2,
                            progressBarColor: Colors.blue,
                            activeGestureInterceptor: true,
                            enableTouch: true,
                            onProgress: (double progressValue) {
                              debugPrint(
                                  'Carga del Modelo en Proceso : $progressValue');
                            },
                            onLoad: (String modelAddress) {
                              debugPrint('Modelo Cargando : $modelAddress');
                            },
                            onError: (String error) {
                              debugPrint('Modelo Fallo al Cargar : $error');
                            },
                          ),
                        ),
                        Text(
                          ' ${widget.carga2.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        const Text(
                          "Carga N3",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 160,
                          width: 100,
                          child: Flutter3DViewer(
                            controller: _controller,
                            src: widget.modelocarga3,
                            progressBarColor: Colors.blue,
                            activeGestureInterceptor: true,
                            enableTouch: true,
                            onProgress: (double progressValue) {
                              debugPrint(
                                  'Carga del Modelo en Proceso : $progressValue');
                            },
                            onLoad: (String modelAddress) {
                              debugPrint('Modelo Cargando : $modelAddress');
                            },
                            onError: (String error) {
                              debugPrint('Modelo Fallo al Cargar : $error');
                            },
                          ),
                        ),
                        Text(
                          ' ${widget.carga3.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                child: Column(
                  children: [
                    const Text(
                      "Sentido de las Fuerzas",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 280,
                      child: Flutter3DViewer(
                        controller: _controller,
                        src: widget.combinacion3d,
                        progressBarColor: Colors.blue,
                        activeGestureInterceptor: true,
                        enableTouch: true,
                        onProgress: (double progressValue) {
                          debugPrint(
                              'Carga del Modelo en Proceso : $progressValue');
                        },
                        onLoad: (String modelAddress) {
                          debugPrint('Modelo Cargando : $modelAddress');
                        },
                        onError: (String error) {
                          debugPrint('Modelo Fallo al Cargar : $error');
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  estaPlay = !estaPlay;

                                  if (estaPlay) {
                                    _controller.playAnimation();
                                  } else {
                                    _controller.pauseAnimation();
                                  }
                                });
                              },
                              child: Icon(estaPlay
                                  ? Icons.pause_outlined
                                  : Icons.play_arrow_rounded)),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      "Digite el sentido de las componentes",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildForceComponent(
                        "Sentido de la Fuerza (1 y 2)", signoX1, signoY1,
                        (newX, newY) {
                      setState(() {
                        signoX1 = newX;
                        signoY1 = newY;
                      });
                    }),
                    const SizedBox(height: 20),
                    _buildForceComponent(
                        "Sentido de la Fuerza (1 y 3)", signoX2, signoY2,
                        (newX, newY) {
                      setState(() {
                        signoX2 = newX;
                        signoY2 = newY;
                      });
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    actualizarMensajes();
                    mostrarResultante = true;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                  elevation: WidgetStateProperty.all(10),
                ),
                child: const Text(
                  "Ingresar los signos",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 400,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Magnitud de las Fuerzas",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          mensajeResultadoC1,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 400,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Fuerzas con Dirección y Componentes",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          mensajeComponentesC1,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Sumas de las Fuerzas",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          mensajesumasC1,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Magnitud de la Fuerza Resultante",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        mensajeFresultanteC1,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      if (mostrarResultante)
                        SizedBox(
                          height: 280,
                          child: Flutter3DViewer(
                            controller: _controllerResult,
                            src: widget.resultante3d,
                            progressBarColor: Colors.blue,
                            activeGestureInterceptor: true,
                            enableTouch: true,
                            onProgress: (double progressValue) {
                              debugPrint(
                                  'Carga del Modelo en Proceso : $progressValue');
                            },
                            onLoad: (String modelAddress) {
                              debugPrint('Modelo Cargando : $modelAddress');
                            },
                            onError: (String error) {
                              debugPrint('Modelo Fallo al Cargar : $error');
                            },
                          ),
                        ),
                      if (mostrarResultante)
                        Container(
                          margin: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      resultPlay = !resultPlay;

                                      if (resultPlay) {
                                        _controllerResult.playAnimation();
                                      } else {
                                        _controllerResult.pauseAnimation();
                                      }
                                    });
                                  },
                                  child: Icon(resultPlay
                                      ? Icons.pause_outlined
                                      : Icons.play_arrow_rounded)),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForceComponent(
      String title, int signoX, int signoY, Function(int, int) onSignoChanged) {
    return Center(
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text("Componente X: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      onSignoChanged(1, signoY);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: signoX == 1 ? Colors.blue : Colors.white,
                    ),
                    child: const Text("Positivo ( + )",
                        style: TextStyle(
                          color: Colors.black,
                        )),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      onSignoChanged(-1, signoY);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          signoX == -1 ? Colors.blue : Colors.white,
                    ),
                    child: const Text(
                      "Negativo ( - )",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Componente Y: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      onSignoChanged(signoX, 1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: signoY == 1 ? Colors.blue : Colors.white,
                    ),
                    child: const Text(
                      "Positivo ( + )",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      onSignoChanged(signoX, -1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          signoY == -1 ? Colors.blue : Colors.white,
                    ),
                    child: const Text(
                      "Negativo ( - )",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////

  Widget _buildCase2() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Fuerza Eléctrica",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Informacion()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        const Text(
                          "Carga N1",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 160,
                          width: 100,
                          child: Flutter3DViewer(
                            controller: _controller,
                            src: widget.modelocarga1,
                            progressBarColor: Colors.blue,
                            activeGestureInterceptor: true,
                            enableTouch: true,
                            onProgress: (double progressValue) {
                              debugPrint(
                                  'Carga del Modelo en Proceso : $progressValue');
                            },
                            onLoad: (String modelAddress) {
                              debugPrint('Modelo Cargando : $modelAddress');
                            },
                            onError: (String error) {
                              debugPrint('Modelo Fallo al Cargar : $error');
                            },
                          ),
                        ),
                        Text(
                          ' ${widget.carga1.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        const Text(
                          "Carga N2",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 160,
                          width: 100,
                          child: Flutter3DViewer(
                            controller: _controller,
                            src: widget.modelocarga2,
                            progressBarColor: Colors.blue,
                            activeGestureInterceptor: true,
                            enableTouch: true,
                            onProgress: (double progressValue) {
                              debugPrint(
                                  'Carga del Modelo en Proceso : $progressValue');
                            },
                            onLoad: (String modelAddress) {
                              debugPrint('Modelo Cargando : $modelAddress');
                            },
                            onError: (String error) {
                              debugPrint('Modelo Fallo al Cargar : $error');
                            },
                          ),
                        ),
                        Text(
                          ' ${widget.carga2.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        const Text(
                          "Carga N3",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 160,
                          width: 100,
                          child: Flutter3DViewer(
                            controller: _controller,
                            src: widget.modelocarga3,
                            progressBarColor: Colors.blue,
                            activeGestureInterceptor: true,
                            enableTouch: true,
                            onProgress: (double progressValue) {
                              debugPrint(
                                  'Carga del Modelo en Proceso : $progressValue');
                            },
                            onLoad: (String modelAddress) {
                              debugPrint('Modelo Cargando : $modelAddress');
                            },
                            onError: (String error) {
                              debugPrint('Modelo Fallo al Cargar : $error');
                            },
                          ),
                        ),
                        Text(
                          ' ${widget.carga3.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                child: Column(
                  children: [
                    const Text(
                      "Sentido de las Fuerzas",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 280,
                      width: 400,
                      child: Flutter3DViewer(
                        controller: _controller,
                        src: widget.combinacion3d,
                        progressBarColor: Colors.blue,
                        activeGestureInterceptor: true,
                        enableTouch: true,
                        onProgress: (double progressValue) {
                          debugPrint(
                              'Carga del Modelo en Proceso : $progressValue');
                        },
                        onLoad: (String modelAddress) {
                          debugPrint('Modelo Cargando : $modelAddress');
                        },
                        onError: (String error) {
                          debugPrint('Modelo Fallo al Cargar : $error');
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  estaPlay = !estaPlay;

                                  if (estaPlay) {
                                    _controller.playAnimation();
                                  } else {
                                    _controller.pauseAnimation();
                                  }
                                });
                              },
                              child: Icon(estaPlay
                                  ? Icons.pause_outlined
                                  : Icons.play_arrow_rounded)),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Digite el sentido de las componentes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildForceComponent(
                  "Sentido de la Fuerza (2 y 1)", signoX1, signoY1,
                  (newX, newY) {
                setState(() {
                  signoX1 = newX;
                  signoY1 = newY;
                });
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    actualizarMensajes();
                    mostrarResultante = true;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                  elevation: WidgetStateProperty.all(10),
                ),
                child: const Text(
                  "Ingresar los signos",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Magnitud de las Fuerzas",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          mensajeResultadoC2,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Fuerzas con Dirección y Componentes",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(mensajeComponentesC2,
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Sumas de las Fuerzas",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          mensajesumasC2,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Magnitud de la Fuerza Resultante",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          mensajeFresultanteC2,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        if (mostrarResultante)
                          SizedBox(
                            height: 280,
                            child: Flutter3DViewer(
                              controller: _controllerResult,
                              src: widget.resultante3d,
                              progressBarColor: Colors.blue,
                              activeGestureInterceptor: true,
                              enableTouch: true,
                              onProgress: (double progressValue) {
                                debugPrint(
                                    'Carga del Modelo en Proceso : $progressValue');
                              },
                              onLoad: (String modelAddress) {
                                debugPrint('Modelo Cargando : $modelAddress');
                              },
                              onError: (String error) {
                                debugPrint('Modelo Fallo al Cargar : $error');
                              },
                            ),
                          ),
                        if (mostrarResultante)
                          Container(
                            margin: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        resultPlay = !resultPlay;

                                        if (resultPlay) {
                                          _controllerResult.playAnimation();
                                        } else {
                                          _controllerResult.pauseAnimation();
                                        }
                                      });
                                    },
                                    child: Icon(resultPlay
                                        ? Icons.pause_outlined
                                        : Icons.play_arrow_rounded)),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

/////////////////////

  Widget _buildCase3() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Fuerza Eléctrica",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Informacion()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        const Text(
                          "Carga N1",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 160,
                          width: 100,
                          child: Flutter3DViewer(
                            controller: _controller,
                            src: widget.modelocarga1,
                            progressBarColor: Colors.blue,
                            activeGestureInterceptor: true,
                            enableTouch: true,
                            onProgress: (double progressValue) {
                              debugPrint(
                                  'Carga del Modelo en Proceso : $progressValue');
                            },
                            onLoad: (String modelAddress) {
                              debugPrint('Modelo Cargando : $modelAddress');
                            },
                            onError: (String error) {
                              debugPrint('Modelo Fallo al Cargar : $error');
                            },
                          ),
                        ),
                        Text(
                          ' ${widget.carga1.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        const Text(
                          "Carga N2",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 160,
                          width: 100,
                          child: Flutter3DViewer(
                            controller: _controller,
                            src: widget.modelocarga2,
                            progressBarColor: Colors.blue,
                            activeGestureInterceptor: true,
                            enableTouch: true,
                            onProgress: (double progressValue) {
                              debugPrint(
                                  'Carga del Modelo en Proceso : $progressValue');
                            },
                            onLoad: (String modelAddress) {
                              debugPrint('Modelo Cargando : $modelAddress');
                            },
                            onError: (String error) {
                              debugPrint('Modelo Fallo al Cargar : $error');
                            },
                          ),
                        ),
                        Text(
                          ' ${widget.carga2.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        const Text(
                          "Carga N3",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 160,
                          width: 100,
                          child: Flutter3DViewer(
                            controller: _controller,
                            src: widget.modelocarga3,
                            progressBarColor: Colors.blue,
                            activeGestureInterceptor: true,
                            enableTouch: true,
                            onProgress: (double progressValue) {
                              debugPrint(
                                  'Carga del Modelo en Proceso : $progressValue');
                            },
                            onLoad: (String modelAddress) {
                              debugPrint('Modelo Cargando : $modelAddress');
                            },
                            onError: (String error) {
                              debugPrint('Modelo Fallo al Cargar : $error');
                            },
                          ),
                        ),
                        Text(
                          ' ${widget.carga3.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                child: Column(
                  children: [
                    const Text(
                      "Sentido de las Fuerzas",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 280,
                      width: 400,
                      child: Flutter3DViewer(
                        controller: _controller,
                        src: widget.combinacion3d,
                        progressBarColor: Colors.blue,
                        activeGestureInterceptor: true,
                        enableTouch: true,
                        onProgress: (double progressValue) {
                          debugPrint(
                              'Carga del Modelo en Proceso : $progressValue');
                        },
                        onLoad: (String modelAddress) {
                          debugPrint('Modelo Cargando : $modelAddress');
                        },
                        onError: (String error) {
                          debugPrint('Modelo Fallo al Cargar : $error');
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  estaPlay = !estaPlay;

                                  if (estaPlay) {
                                    _controller.playAnimation();
                                  } else {
                                    _controller.pauseAnimation();
                                  }
                                });
                              },
                              child: Icon(estaPlay
                                  ? Icons.pause_outlined
                                  : Icons.play_arrow_rounded)),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Digite el sentido de las componentes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildForceComponent(
                  "Sentido de las Fuerza (3 y 1)", signoX1, signoY1,
                  (newX, newY) {
                setState(() {
                  signoX1 = newX;
                  signoY1 = newY;
                });
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    actualizarMensajes();
                    mostrarResultante = true;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                  elevation: WidgetStateProperty.all(10),
                ),
                child: const Text(
                  "Ingresar los signos",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Magnitud de las Fuerzas",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          mensajeResultadoC3,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Fuerzas con Dirección y Componentes",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          mensajeComponentesC3,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Sumas de las Fuerzas",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          mensajesumasC3,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Magnitud de la Fuerza Resultante",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        mensajeFresultanteC3,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      if (mostrarResultante)
                        SizedBox(
                          height: 280,
                          child: Flutter3DViewer(
                            controller: _controllerResult,
                            src: widget.resultante3d,
                            progressBarColor: Colors.blue,
                            activeGestureInterceptor: true,
                            enableTouch: true,
                            onProgress: (double progressValue) {
                              debugPrint(
                                  'Carga del Modelo en Proceso : $progressValue');
                            },
                            onLoad: (String modelAddress) {
                              debugPrint('Modelo Cargando : $modelAddress');
                            },
                            onError: (String error) {
                              debugPrint('Modelo Fallo al Cargar : $error');
                            },
                          ),
                        ),
                      if (mostrarResultante)
                        Container(
                          margin: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      resultPlay = !resultPlay;

                                      if (resultPlay) {
                                        _controllerResult.playAnimation();
                                      } else {
                                        _controllerResult.pauseAnimation();
                                      }
                                    });
                                  },
                                  child: Icon(resultPlay
                                      ? Icons.pause_outlined
                                      : Icons.play_arrow_rounded)),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
