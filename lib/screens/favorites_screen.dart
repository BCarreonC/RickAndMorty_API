import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/character_provider.dart';
import 'detail_screen.dart';

/// Pantalla que muestra los personajes marcados como favoritos.
/// Permite navegar a los detalles de cada personaje y eliminarlos deslizando.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  /// Muestra un cuadro de diálogo de ayuda explicando cómo eliminar favoritos.
  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[850],
        title: const Text('¿Cómo eliminar?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Para eliminar un personaje de la lista de favoritos, deslízalo hacia la izquierda.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text('Entendido', style: TextStyle(color: Colors.greenAccent)),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<CharacterProvider>();
    final favs = prov.favoriteCharacters;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
        title: const Text('Favoritos', style: TextStyle(color: Colors.black87)),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          // Botón de ayuda para explicar cómo eliminar favoritos
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: '¿Cómo eliminar?',
            onPressed: () => _showHelp(context),
          ),
        ],
      ),
      body: favs.isEmpty
          // Muestra mensaje si no hay favoritos
          ? const Center(
              child: Text('No hay personajes favoritos.',
                  style: TextStyle(color: Colors.white70)),
            )
          // Lista de personajes favoritos
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              itemCount: favs.length,
              itemBuilder: (_, i) {
                final c = favs[i];
                return Dismissible(
                  key: ValueKey(c.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  // Al deslizar, elimina el favorito y muestra snackbar
                  onDismissed: (_) {
                    prov.toggleFavorite(c.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${c.name} eliminado de favoritos'),
                        backgroundColor: Colors.redAccent,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Card(
                      color: Colors.grey[850],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                            color: Colors.greenAccent.shade400, width: 1.5),
                      ),
                      child: ListTile(
                        leading: Hero(
                          tag: 'character-${c.id}',
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(c.image ?? ''),
                          ),
                        ),
                        title: Text(c.name ?? 'Sin nombre',
                            style: const TextStyle(color: Colors.white)),
                        // Navega al detalle del personaje
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(
                              character: c,
                              heroTag: 'character-${c.id}',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
