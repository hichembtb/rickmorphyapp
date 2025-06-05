import '../../../data/models/character_model.dart';

enum CharacterStatus { initial, loading, success, failure }

class CharacterState {
  final List<CharacterModel> characters;
  final bool hasReachedMax;
  final CharacterStatus status;
  final int currentPage;

  CharacterState({
    this.characters = const [],
    this.hasReachedMax = false,
    this.status = CharacterStatus.initial,
    this.currentPage = 1,
  });

  CharacterState copyWith({
    List<CharacterModel>? characters,
    bool? hasReachedMax,
    CharacterStatus? status,
    int? currentPage,
  }) {
    return CharacterState(
      characters: characters ?? this.characters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
