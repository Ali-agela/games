import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/controllers/dark_mode_controller.dart';
import 'package:movies/controllers/games_controller.dart';
import 'package:movies/widgets/game_card.dart';
import 'package:shimmer/shimmer.dart';

class GamesGenreScreen extends StatelessWidget {
  final String value;
  final GamesController gamesController = Get.put(GamesController());
  final DarkModeController darkModeController = Get.put(DarkModeController());

  GamesGenreScreen({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    // Fetch games by genre when the screen is loaded
    gamesController.fetchGamesByGenre(value);

    return Obx(() {
      final isDark = darkModeController.isDark.value;
      final isLoading = gamesController.isLoading.value;
      final sameGenreGames = gamesController.sameGenreGames;

      return Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: isDark ? Colors.black : Colors.white,
          title: Text(
            "Genre: $value",
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            itemCount: isLoading ? 6 : sameGenreGames.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isLoading
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Shimmer.fromColors(
                          baseColor: Colors.black12,
                          highlightColor: Colors.white38,
                          child: Container(
                            color: Colors.white,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        ),
                      )
                    : GameCard(gamemodel: sameGenreGames[index]),
              );
            },
          ),
        ),
      );
    });
  }
}
