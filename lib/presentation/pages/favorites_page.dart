import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubits/favorite_cubit/favorites_cubit.dart';
import '../../data/models/favorite_character_model.dart';
import '../widgets/favorite_card.dart';

enum SortOption { name, status }

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  SortOption _sortOption = SortOption.name;

  List<FavoriteCharacter> _sort(List<FavoriteCharacter> list) {
    switch (_sortOption) {
      case SortOption.name:
        return List.from(list)..sort((a, b) => a.name.compareTo(b.name));
      case SortOption.status:
        return List.from(list)..sort((a, b) => a.status.compareTo(b.status));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, List<FavoriteCharacter>>(
      builder: (context, favorites) {
        final sortedFavorites = _sort(favorites);

        if (favorites.isEmpty) {
          return const Center(child: Text('No favorites yet.'));
        }

        return SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Text('Sort by:'),
                    const SizedBox(width: 10),
                    DropdownButton<SortOption>(
                      value: _sortOption,
                      items: const [
                        DropdownMenuItem(
                          value: SortOption.name,
                          child: Text('Name'),
                        ),
                        DropdownMenuItem(
                          value: SortOption.status,
                          child: Text('Status'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _sortOption = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sortedFavorites.length,
                  itemBuilder: (context, index) {
                    return FavoriteCard(character: sortedFavorites[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
