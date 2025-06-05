import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/character_repository.dart';
import 'character_state.dart';

class CharacterCubit extends Cubit<CharacterState> {
  final CharacterRepository repository;

  CharacterCubit(this.repository) : super(CharacterState());

  Future<void> fetchCharacters() async {
    try {
      if (state.status == CharacterStatus.initial) {
        final characters = await repository.fetchCharacters();
        emit(
          CharacterState(
            status: CharacterStatus.success,
            characters: characters,
            hasReachedMax: false,
          ),
        );
        return;
      }

      final characters = await repository.fetchCharacters();
      if (characters.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        emit(
          CharacterState(
            status: CharacterStatus.success,
            characters: List.of(state.characters)..addAll(characters),
            hasReachedMax: false,
          ),
        );
      }
    } catch (e) {
      print('🧪 Failed to fetch characters: $e');
      emit(state.copyWith(status: CharacterStatus.failure));
    }
  }

  Future<void> refreshCharacters() async {
    try {
      final characters = await repository.fetchCharacters(refresh: true);
      emit(
        CharacterState(
          status: CharacterStatus.success,
          characters: characters,
          hasReachedMax: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: CharacterStatus.failure));
    }
  }
}
