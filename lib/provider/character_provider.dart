import 'package:flutter/material.dart';
import '../models/character.dart';
import '../services/api_service.dart';

/// Provider que administra el estado de los personajes: lista completa, filtros, favoritos y errores.
class CharacterProvider with ChangeNotifier {
  List<Character> _allCharacters = []; // Lista completa de personajes desde la API.
  List<Character> _filteredCharacters = []; // Lista filtrada según nombre y estado.
  Set<int> _favoriteIds = {}; // IDs de personajes favoritos.
  String _selectedStatus = 'Todos'; // Filtro actual por estado.
  String _searchQuery = ''; // Texto actual de búsqueda.
  bool _isLoading = false; // Indica si los datos se están cargando.
  String? _error; // Mensaje de error si ocurre algún problema.

  List<Character> get filteredCharacters => _filteredCharacters; // Devuelve la lista filtrada.
  List<Character> get allCharacters => _allCharacters; // Devuelve la lista completa.
  Set<int> get favoriteIds => _favoriteIds; // Devuelve el set de favoritos.
  String get selectedStatus => _selectedStatus; // Devuelve el filtro actual.
  bool get isLoading => _isLoading; // Devuelve el estado de carga.
  String? get error => _error; // Devuelve el error, si existe.

  /// Carga los personajes desde la API y aplica filtros iniciales.
  Future<void> fetchCharacters() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allCharacters = await ApiService.fetchCharacters();
      _filteredCharacters = List.from(_allCharacters);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Aplica búsqueda por nombre y filtro por estado.
  void applyFilters(String query) {
    _searchQuery = query;
    _filteredCharacters = _allCharacters.where((c) {
      final matchesName = (c.name ?? '').toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _selectedStatus == 'Todos' || (c.status?.toLowerCase() == _selectedStatus.toLowerCase());
      return matchesName && matchesStatus;
    }).toList();
    notifyListeners();
  }

  /// Actualiza el filtro de estado y vuelve a aplicar los filtros.
  void updateStatusFilter(String status) {
    _selectedStatus = status;
    applyFilters(_searchQuery);
  }

  /// Agrega o quita un personaje de favoritos.
  void toggleFavorite(int id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  /// Devuelve la lista de personajes marcados como favoritos.
  List<Character> get favoriteCharacters => _allCharacters.where((c) => _favoriteIds.contains(c.id)).toList();

  /// Verifica si un personaje está marcado como favorito.
  bool isFavorite(int id) => _favoriteIds.contains(id);
}
