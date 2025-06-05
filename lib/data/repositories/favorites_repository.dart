import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite_character_model.dart';

class FavoritesRepository {
  static const String _favoritesKey = 'favorite_characters';

  Future<List<FavoriteCharacter>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_favoritesKey) ?? [];
    return data
        .map((jsonStr) => FavoriteCharacter.fromJson(json.decode(jsonStr)))
        .toList();
  }

  Future<void> saveFavorite(FavoriteCharacter character) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    final updated = [...favorites, character];
    final jsonList = updated.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_favoritesKey, jsonList);
  }

  Future<void> removeFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    final updated = favorites.where((c) => c.id != id).toList();
    final jsonList = updated.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_favoritesKey, jsonList);
  }

  Future<bool> isFavorite(int id) async {
    final favorites = await getFavorites();
    return favorites.any((c) => c.id == id);
  }
}
