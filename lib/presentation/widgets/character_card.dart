import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/character_model.dart';
import '../../data/models/favorite_character_model.dart';
import '../../logic/cubits/favorite_cubit/favorites_cubit.dart';

class CharacterCard extends StatelessWidget {
  final CharacterModel character;

  const CharacterCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final favoritesCubit = context.watch<FavoritesCubit>();
    final isFav = favoritesCubit.isFavorite(character.id);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: character.image,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const CircularProgressIndicator(strokeWidth: 2),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),

        title: Text(
          character.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          '${character.status} - ${character.species}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        isThreeLine: true,
        trailing: IconButton(
          icon: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? Colors.red : null,
          ),
          onPressed: () {
            final fav = FavoriteCharacter(
              id: character.id,
              name: character.name,
              image: character.image,
              status: character.status,
            );
            context.read<FavoritesCubit>().toggleFavorite(fav);
          },
        ),
      ),
    );
  }
}
