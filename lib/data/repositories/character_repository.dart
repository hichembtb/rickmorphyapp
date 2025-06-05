import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';

class CharacterRepository {
  static const _baseUrl = 'https://rickandmortyapi.com/api/character';
  static const _cacheKey = 'cached_characters';

  int _currentPage = 1;
  bool _hasReachedEnd = false;

  Future<List<CharacterModel>> fetchCharacters({bool refresh = false}) async {
    if (_hasReachedEnd && !refresh) return [];

    if (refresh) {
      _currentPage = 1;
      _hasReachedEnd = false;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?page=$_currentPage'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        final characters = results
            .map((json) => CharacterModel.fromJson(json))
            .toList();

        if (_currentPage == 1) {
          await _cacheCharacters(characters);
        }

        _currentPage++;
        if (data['info']['next'] == null) _hasReachedEnd = true;

        return characters;
      } else {
        return _getCachedCharacters();
      }
    } catch (e) {
      return _getCachedCharacters();
    }
  }

  Future<void> _cacheCharacters(List<CharacterModel> characters) async {
    print('🧪 Caching ${characters.length} characters');
    final prefs = await SharedPreferences.getInstance();
    final jsonList = characters.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_cacheKey, jsonList);
  }

  Future<List<CharacterModel>> _getCachedCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_cacheKey) ?? [];
    print('🧪 Loaded ${jsonList.length} cached characters');
    return jsonList
        .map((jsonStr) => CharacterModel.fromJson(json.decode(jsonStr)))
        .toList();
  }
}
