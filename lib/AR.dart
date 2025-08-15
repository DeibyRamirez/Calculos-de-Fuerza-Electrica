// AR con Flutter3DController - SOLO esta librería para máxima fluidez
// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'dart:async';
import 'dart:math' as math;


class AR extends StatefulWidget {
  const AR({super.key, required this.modeloAR});

  final String modeloAR;

  @override
  State<AR> createState() => _ARState();
}

class _ARState extends State<AR> with TickerProviderStateMixin {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _showModel = false;
  
  // SOLO Flutter3DController - NO O3D
  Flutter3DController? _flutter3DController;
  
  // Animaciones fluidas con AnimationController nativo de Flutter
  late AnimationController _rotationAnimationController;
  late Animation<double> _rotationAnimation;
  
  late AnimationController _scaleAnimationController;
  late Animation<double> _scaleAnimation;
  
  bool _isAnimating = false;
  final double _animationSpeed = 1.0;
  double _currentRotationY = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Inicializar Flutter3DController
    _flutter3DController = Flutter3DController();
    
    // Obtener información de animaciones del modelo después de un delay
    Timer(Duration(seconds: 2), () {
      _getModelAnimationInfo();
    });
    
    // AnimationController para rotación fluida
    _rotationAnimationController = AnimationController(
      duration: Duration(seconds: 4), // 4 segundos por vuelta completa
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi, // 360 grados en radianes
    ).animate(CurvedAnimation(
      parent: _rotationAnimationController,
      curve: Curves.linear, // Movimiento constante sin aceleración
    ));
    
    // AnimationController para escala (efecto pulsante)
    _scaleAnimationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.easeInOut,
    ));
    
    // Listeners para actualizar la UI suavemente
    _rotationAnimation.addListener(() {
      if (mounted) {
        setState(() {
          _currentRotationY = _rotationAnimation.value;
        });
      }
    });
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium, // Medium para mejor rendimiento
        enableAudio: false,
      );
      
      try {
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      } catch (e) {
        debugPrint('Error inicializando cámara: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('AR - Modelo 3D'),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        
      ),
      
      body: Stack(
        children: [
          // Cámara de fondo
          Positioned.fill(
            child: CameraPreview(_cameraController!),
          ),
          
          // Modelo 3D con Flutter3DViewer - ANIMACIONES FLUIDAS
          if (_showModel)
            Positioned(
              top: 60,
              left: 10,
              child: SizedBox(
                width: 360,
                height: 650,
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _rotationAnimation,
                    _scaleAnimation,
                  ]),
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        // Perspectiva 3D
                        ..setEntry(3, 2, 0.001)
                        // Rotación Y fluida
                        ..rotateY(_currentRotationY)
                        // Escala pulsante
                        ..scale(_scaleAnimation.value),
                      child: Flutter3DViewer(
                        src: widget.modeloAR,
                        controller: _flutter3DController!,
                        
                        // Configuración para MÁXIMA FLUIDEZ
                        progressBarColor: Colors.blue,
                        
                      ),
                    );
                  },
                ),
              ),
            ),
          
          // Panel de control de velocidad (MEJORADO)
          // Positioned(
          //   top: 120,
          //   right: 15,
          //   child: Container(
          //     width: 50,
          //     height: 180,
          //     decoration: BoxDecoration(
          //       color: Colors.black.withOpacity(0.8),
          //       borderRadius: BorderRadius.circular(25),
          //       border: Border.all(color: Colors.blue.withOpacity(0.5), width: 1),
          //     ),
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         Icon(Icons.speed, color: Colors.white, size: 16),
          //         RotatedBox(
          //           quarterTurns: 3,
          //           child: Slider(
          //             value: _animationSpeed,
          //             min: 0.2,
          //             max: 4.0,
          //             divisions: 38,
          //             activeColor: Colors.blue,
          //             inactiveColor: Colors.grey.withOpacity(0.5),
          //             onChanged: (value) {
          //               setState(() {
          //                 _animationSpeed = value;
          //                 _updateAnimationSpeed();
          //               });
          //             },
          //           ),
          //         ),
          //         Text(
          //           '${_animationSpeed.toStringAsFixed(1)}x',
          //           style: TextStyle(color: Colors.white, fontSize: 9),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          
          // Controles de animación mejorados
          Positioned(
            bottom: 140,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '🎮 Controles de Animación',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildControlButton(
                          'Rotar\nY', 
                          Icons.rotate_right, 
                          Colors.purple,
                          _toggleRotationY,
                          _rotationAnimationController.isAnimating,
                        ),
                        _buildControlButton(
                          'Anim.\nGLB', 
                          Icons.play_arrow, 
                          Colors.green,
                          _toggleModelAnimation,
                          _isAnimating,
                        ),
                        _buildControlButton(
                          'Reset\nTodo', 
                          Icons.refresh, 
                          Colors.red,
                          _resetAllAnimations,
                          false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Botones principales
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showModel = !_showModel;
                        });
                      },
                      icon: Icon(_showModel ? Icons.visibility_off : Icons.view_in_ar),
                      label: Text(_showModel ? 'Ocultar' : 'Mostrar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _showModel ? Colors.red : Colors.green,
                        foregroundColor: Colors.white,
                        elevation: 3,
                      ),
                    ),
                   
                  ],
                ),
              ),
            ),
          ),
          
          // Indicadores de estado mejorados
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _isAnimating ? Colors.green.withOpacity(0.9) : Colors.grey.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isAnimating ? Colors.greenAccent : Colors.grey.shade300, 
                  width: 1
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isAnimating ? Icons.play_circle : Icons.pause_circle,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(width: 6),
                  Text(
                    _isAnimating 
                        ? 'ANIMANDO ${_animationSpeed.toStringAsFixed(1)}x' 
                        : 'PAUSADO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Indicador LIVE AR
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'LIVE AR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
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

  Widget _buildControlButton(
    String label, 
    IconData icon, 
    Color color, 
    VoidCallback onPressed,
    bool isActive,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: isActive ? 8 : 4,
                spreadRadius: isActive ? 2 : 1,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isActive ? color.withOpacity(0.9) : color,
              foregroundColor: Colors.white,
              minimumSize: Size(50, 50),
              shape: CircleBorder(),
              elevation: isActive ? 8 : 3,
            ),
            child: Icon(icon, size: 22),
          ),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade300,
            fontSize: 9,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // MÉTODOS DE ANIMACIÓN FLUIDA
  void _toggleRotationY() {
    if (_rotationAnimationController.isAnimating) {
      _rotationAnimationController.stop();
    } else {
      _rotationAnimationController.repeat();
    }
  }

 

  // MÉTODO ESPECÍFICO PARA ANIMACIONES INTERNAS DEL MODELO GLB
  void _toggleModelAnimation() {
    setState(() {
      _isAnimating = !_isAnimating;
    });
    
    if (_isAnimating) {
      // REPRODUCIR ANIMACIONES INTERNAS DEL MODELO
      _flutter3DController?.playAnimation();
      
      // Si quieres reproducir una animación específica:
      // _flutter3DController?.playAnimation(animationName: 'Walk');
      // _flutter3DController?.playAnimation(animationName: 'Run');
      
      debugPrint('🎬 Reproduciendo animaciones del modelo GLB');
    } else {
      // PAUSAR ANIMACIONES DEL MODELO
      _flutter3DController?.pauseAnimation();
      debugPrint('⏸️ Pausando animaciones del modelo GLB');
    }
  }


  // void _updateAnimationSpeed() {
  //   // Actualizar duración basada en la velocidad
  //   Duration newDuration = Duration(
  //     milliseconds: (4000 / _animationSpeed).round(),
  //   );
    
  //   if (_rotationAnimationController.isAnimating) {
  //     _rotationAnimationController.stop();
  //     _rotationAnimationController.duration = newDuration;
  //     _rotationAnimationController.repeat();
  //   } else {
  //     _rotationAnimationController.duration = newDuration;
  //   }
  // }

  void _resetAllAnimations() {
    _rotationAnimationController.stop();
    _rotationAnimationController.reset();
    _scaleAnimationController.stop();
    _scaleAnimationController.reset();
    
    setState(() {
      _isAnimating = false;
      _currentRotationY = 0.0;
    });
    
    // RESETEAR ANIMACIONES DEL MODELO Y CÁMARA
    _flutter3DController?.resetCameraOrbit();
    _flutter3DController?.pauseAnimation();
    
    debugPrint('🔄 Todas las animaciones reseteadas');
  }

  // MÉTODO PARA OBTENER INFORMACIÓN DE LAS ANIMACIONES DEL MODELO
  void _getModelAnimationInfo() async {
    try {
      // Obtener nombres de animaciones disponibles
      // final animationNames = await _flutter3DController?.getAnimationNames();
      // debugPrint('🎭 Animaciones disponibles: $animationNames');
      
      // Si tu controlador no soporta obtener nombres de animaciones, omite esta parte.
      // Puedes consultar la documentación del paquete para ver si existe un método alternativo.
    } catch (e) {
      debugPrint('❌ Error obteniendo info de animaciones: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _rotationAnimationController.dispose();
    _scaleAnimationController.dispose();
    super.dispose();
  }
}