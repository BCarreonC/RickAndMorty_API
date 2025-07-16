import 'package:flutter/material.dart';
import '../models/character.dart';

/// Pantalla que muestra los detalles de un personaje seleccionado.
/// Incluye imagen, nombre, estado, especie, origen y ubicación.
class DetailScreen extends StatelessWidget {
  /// Personaje a mostrar.
  final Character character;

  /// Etiqueta para animación Hero compartida.
  final String heroTag;

  /// Constructor de la pantalla de detalle.
  const DetailScreen({
    super.key,
    required this.character,
    required this.heroTag,
  });

  /// Devuelve un color asociado al estado del personaje.
  /// Verde si está vivo, rojo si está muerto, gris para otro.
  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'alive':
        return Colors.greenAccent;
      case 'dead':
        return Colors.redAccent;
      default:
        return Colors.blueGrey;
    }
  }

  /// Genera una fila de información con etiqueta y valor.
  /// Cambia el color del valor si la etiqueta es "Estado".
  Widget _infoRow(String label, String? value) {
    Color valColor =
        label.toLowerCase() == 'estado' ? _statusColor(value) : Colors.white;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          Text(value ?? 'No disponible',
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: valColor)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
        title: Text(character.name ?? 'Detalle',
            style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              color: Colors.grey[850],
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                    color: Colors.greenAccent.shade400, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Imagen con animación Hero
                    Hero(
                      tag: heroTag,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          character.image ?? '',
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Nombre del personaje
                    Text(character.name ?? '',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent[400])),
                    const SizedBox(height: 16),
                    Divider(color: Colors.greenAccent.shade100),
                    const SizedBox(height: 16),
                    // Fila de información detallada
                    _infoRow('ID', character.id.toString()),
                    _infoRow('Estado', character.status),
                    _infoRow('Especie', character.species),
                    _infoRow('Origen', character.origin?.name),
                    _infoRow('Ubicación', character.location?.name),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
