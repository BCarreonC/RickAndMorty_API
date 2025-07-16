import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Acerca de' , style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.greenAccent[400],
        iconTheme: const IconThemeData(color: Colors.black87),
        
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rick and Morty App',
              style: TextStyle(
                fontSize: 22,
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Esta aplicación muestra información sobre los personajes de la serie Rick and Morty, incluyendo sus nombres, estado (vivo, muerto o desconocido), número de episodios en los que han aparecido, y su imagen.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Funcionalidades:',
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- Búsqueda de personajes\n'
              '- Filtrado por estado\n'
              '- Favoritos\n'
              '- Vista de detalles\n'
              '- Selección aleatoria\n'
              '- Gráficas con estadísticas',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Tecnologías utilizadas:',
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- Flutter\n'
              '- Provider\n'
              '- fl_chart\n'
              '- API pública de Rick and Morty',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Desarrollado por:',
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Benjamín Carreón Cadenas\n Estudiante de Ingeniería en Software',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'API Publica:',
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'API: https://rickandmortyapi.com',
              ),
          ],
        ),
      ),
    );
  }
}
