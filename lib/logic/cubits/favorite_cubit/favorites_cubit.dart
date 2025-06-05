import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/favorite_character_model.dart';
import '../../../data/repositories/favorites_repository.dart';

class FavoritesCubit extends Cubit<List<FavoriteCharacter>> {
  final FavoritesRepository repository;

  FavoritesCubit(this.repository) : super([]);

  Future<void> loadFavorites() async {
    final favorites = await repository.getFavorites();
    emit(favorites);
  }

  Future<void> toggleFavorite(FavoriteCharacter character) async {
    final isFav = state.any((c) => c.id == character.id);
    if (isFav) {
      await repository.removeFavorite(character.id);
      emit(state.where((c) => c.id != character.id).toList());
    } else {
      await repository.saveFavorite(character);
      emit([...state, character]);
    }
  }

  bool isFavorite(int id) {
    return state.any((character) => character.id == id);
  }
}
