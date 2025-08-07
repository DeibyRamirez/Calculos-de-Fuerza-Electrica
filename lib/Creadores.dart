// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Creadores extends StatelessWidget {
  const Creadores({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Creadores",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildCard(
              context,
              "Deiby Ramirez",
              const AssetImage('assets/imagenes/deiby.jpeg'),
              "https://github.com/DeibyRamirez",
              "hero-deiby",
            ),
            const SizedBox(height: 20),
            _buildCard(
              context,
              "David Urrutia",
              const AssetImage("assets/imagenes/David.jpg"),
              "https://github.com/BICHO128",
              "hero-david",
            ),
          ],
        ),
      ),
    );
  }
}

//Creando un Widget personalizado...
Widget _buildCard(BuildContext context, String nombre,
    ImageProvider<Object> avatar, String githubUrl, String herotag) {
  return Center(
    child: Container(
      color: Colors.black,
      height: 400,
      width: 300,
      child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                    tag: herotag,
                    child: CircleAvatar(
                      backgroundImage: avatar,
                      radius: 80,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  nombre,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () => _irGitHub(githubUrl),
                    child: const Text(
                      "Repositorio GitHub",
                      style: TextStyle(color: Colors.black),
                    )),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () =>
                        _segundaPagina(context, nombre, avatar, herotag),
                    child: const Text(
                      "Ver más",
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            ),
          )),
    ),
  );
}

//Creando la seccion a donde ira el hero...
void _segundaPagina(BuildContext context, String nombre,
    ImageProvider<Object> avatar, String heroTag) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => Scaffold(
      appBar: AppBar(
        title: Text(
          nombre,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        //Cambiar a color blanco el boton de regreso de pagina..
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Hero(
              tag: heroTag,
              child: CircleAvatar(
                backgroundImage: avatar,
                radius:
                    100,
              ),
            ),
          ),
          const SizedBox(height: 20),
            Card(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Padding(
              padding:  EdgeInsets.all(15),
              child: Text(
              '''
    - Estudiante de Ingeniería de Software de la Corporación Universitaria del Cauca.

- Cursante de 5 semestre.

    - Este proyecto fue creado para el Semillero de Investigación.
             
- Se aplicaron conocimientos de desarrollo de Aplicaciones Web con lenguaje Dart y el framework de Flutter.
             
    - Se implementó el uso de Modelos 3D de Cargas eléctricas sometidas a diferentes configuraciones para comprender los tipos de fuerzas.
              ''',
              style:  TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
              ),
            ),
            )
        ],
      ),
    ),
  ));
}

//Creando un metodo para viajar al repositorio... es un proceso asincrono y fuera de la app
void _irGitHub(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    debugPrint("No se pude abrir el enlace $url");
  }
}
