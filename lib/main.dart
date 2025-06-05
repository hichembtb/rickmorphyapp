import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme.dart';
import 'data/repositories/character_repository.dart';
import 'data/repositories/favorites_repository.dart';
import 'logic/cubits/characters_cubit/character_cubit.dart';
import 'logic/cubits/favorite_cubit/favorites_cubit.dart';
import 'logic/cubits/theme_cubit/theme_cubit.dart';
import 'presentation/pages/home_page.dart';

void main() {
  runApp(const RickAndMortyApp());
}

class RickAndMortyApp extends StatelessWidget {
  const RickAndMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (_) =>
              CharacterCubit(CharacterRepository())..fetchCharacters(),
        ),
        BlocProvider(
          create: (_) => FavoritesCubit(FavoritesRepository())..loadFavorites(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Rick and Morty',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
