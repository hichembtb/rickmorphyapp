import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubits/characters_cubit/character_cubit.dart';
import '../../logic/cubits/characters_cubit/character_state.dart';
import '../widgets/character_card.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    context.read<CharacterCubit>().fetchCharacters();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CharacterCubit>().fetchCharacters();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterCubit, CharacterState>(
      builder: (context, state) {
        if (state.status == CharacterStatus.loading &&
            state.characters.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == CharacterStatus.failure) {
          return const Center(child: Text('Failed to load characters.'));
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: state.hasReachedMax
              ? state.characters.length
              : state.characters.length + 1,
          itemBuilder: (context, index) {
            if (index >= state.characters.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final character = state.characters[index];
            return CharacterCard(character: character);
          },
        );
      },
    );
  }
}
