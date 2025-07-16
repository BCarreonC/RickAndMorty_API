import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/character_provider.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';
import 'about_screen.dart';
import 'stats_screen.dart';

/// Pantalla principal que muestra la lista de personajes de Rick and Morty,
/// permite buscar, filtrar, marcar como favorito, ver estadísticas, un personaje aleatorio
/// y navegar a otras secciones como "Favoritos" y "Acerca de".
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Al iniciar, se cargan los personajes desde el provider.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterProvider>().fetchCharacters();
    });
  }

  /// Navega a la pantalla "Acerca de".
  void _navigateToAbout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AboutScreen()),
    );
  }

  /// Navega a la pantalla de favoritos.
  void _navigateToFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FavoritesScreen()),
    );
  }

  /// Navega a la pantalla de estadísticas.
  void _navigateToStats() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const StatsScreen()),
    );
  }

  /// Muestra un personaje aleatorio de la lista disponible.
  void _showRandomCharacter(CharacterProvider provider) {
    if (provider.allCharacters.isNotEmpty) {
      final random = (provider.allCharacters..shuffle()).first;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailScreen(
            character: random,
            heroTag: 'character-${random.id}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
        title: const Text('Personajes', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (value) {
              if (value == 'favorites') _navigateToFavorites();
              if (value == 'about') _navigateToAbout();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'favorites',
                child: Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text('Ver favoritos'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Acerca de'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
            child: Row(
              children: [
                // Campo de búsqueda
                Expanded(
                  flex: 3,
                  child: Consumer<CharacterProvider>(
                    builder: (_, prov, __) => TextField(
                      onChanged: prov.applyFilters,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Buscar personaje...',
                        hintStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(Icons.search, color: Colors.white70),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Filtro por estado (Alive, Dead, Unknown)
                Expanded(
                  flex: 1,
                  child: Consumer<CharacterProvider>(
                    builder: (_, prov, __) => DropdownButtonFormField<String>(
                      value: prov.selectedStatus,
                      dropdownColor: Colors.grey[850],
                      iconEnabledColor: Colors.white,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[800],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                      style: const TextStyle(color: Colors.white),
                      items: ['Todos', 'Alive', 'Dead', 'Unknown']
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) prov.updateStatusFilter(newValue);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<CharacterProvider>(
        builder: (_, prov, __) {
          if (prov.isLoading) return const Center(child: CircularProgressIndicator());
          if (prov.error != null) return Center(child: Text('Error: ${prov.error}'));
          if (prov.filteredCharacters.isEmpty) {
            return const Center(
              child: Text('No se encontraron personajes.', style: TextStyle(color: Colors.white70)),
            );
          }

          // Lista de personajes
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: prov.filteredCharacters.length,
            itemBuilder: (_, i) {
              final c = prov.filteredCharacters[i];
              final isFav = prov.isFavorite(c.id!);
              Color statusColor;
              switch (c.status?.toLowerCase()) {
                case 'alive':
                  statusColor = Colors.greenAccent;
                  break;
                case 'dead':
                  statusColor = Colors.redAccent;
                  break;
                default:
                  statusColor = Colors.blueGrey;
              }

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Card(
                    color: Colors.grey[850],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.greenAccent.shade400, width: 1.5),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Hero(
                        tag: 'character-${c.id}',
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(c.image ?? ''),
                        ),
                      ),
                      title: Text(c.name ?? 'Sin nombre',
                          style: TextStyle(
                              color: Colors.greenAccent[400], fontWeight: FontWeight.bold)),
                      subtitle: Row(
                        children: [
                          Icon(Icons.circle, color: statusColor, size: 10),
                          const SizedBox(width: 6),
                          Text(c.status ?? '',
                              style: TextStyle(color: statusColor, fontStyle: FontStyle.italic)),
                        ],
                      ),
                      trailing: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                        child: IconButton(
                          key: ValueKey(isFav),
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.redAccent : Colors.white38,
                          ),
                          onPressed: () => prov.toggleFavorite(c.id!),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(
                              character: c,
                              heroTag: 'character-${c.id}',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Botón para estadísticas
          FloatingActionButton(
            heroTag: 'stats',
            onPressed: _navigateToStats,
            backgroundColor: Colors.greenAccent[400],
            child: const Icon(Icons.bar_chart, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          // Botón para personaje aleatorio
          FloatingActionButton(
            heroTag: 'random',
            onPressed: () => _showRandomCharacter(context.read<CharacterProvider>()),
            backgroundColor: Colors.greenAccent[400],
            child: const Icon(Icons.shuffle, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
