import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fullscreen_image_viewer/fullscreen_image_viewer.dart';
import 'package:get/get.dart';
import 'package:movies/controllers/dark_mode_controller.dart';
import 'package:movies/controllers/games_controller.dart';
import 'package:movies/screens/games_genre_screen.dart';
import 'package:movies/widgets/game_card.dart';
import 'package:movies/widgets/minimum_requirment.dart';
import 'package:url_launcher/url_launcher.dart';

class GameDetailsScreen extends StatelessWidget {
  final int id;
  final GamesController gamesController = Get.put(GamesController());
  final DarkModeController darkModeController = Get.put(DarkModeController());

  GameDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    // Fetch game details when the screen is loaded
    gamesController.fetchGame(id);

    return Obx(() {
      final isDark = darkModeController.isDark.value;
      final gameDetails = gamesController.gamedetailes.value;
      final isLoading = gamesController.isLoading.value;

      return Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: isDark ? Colors.black : Colors.white,
          title: gameDetails == null
              ? const SizedBox()
              : Text(
                  gameDetails.title,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
          centerTitle: true,
        ),
        body: isLoading || gameDetails == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Game Thumbnail
                      Stack(
                        children: [
                          Image.network(
                            gameDetails.thumbnail,
                            fit: BoxFit.fill,
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: ElevatedButton(
                              onPressed: () => _launchUrl(gameDetails.gameUrl),
                              child: const Text("Go to Game"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Screenshots
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: gameDetails.screenshots.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  FullscreenImageViewer.open(
                                    context: context,
                                    child: Image.network(
                                      gameDetails.screenshots[index].image,
                                    ),
                                  );
                                },
                                child: Image.network(
                                  gameDetails.screenshots[index].image,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Description and Tags
                      Row(
                        children: [
                          Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4),
                            child: Text(
                              gameDetails.genre,
                              style: TextStyle(
                                  color: isDark ? Colors.black : Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4),
                            child: Text(
                              gameDetails.status,
                              style: TextStyle(
                                  color: isDark ? Colors.black : Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4),
                            child: Text(
                              gameDetails.platform,
                              style: TextStyle(
                                  color: isDark ? Colors.black : Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        return Text(
                          gameDetails.description,
                          maxLines: gamesController.isShowMore.value ? 50 : 3,
                          style: TextStyle(
                              color: isDark ? Colors.white : Colors.black),
                        );
                      }),
                      TextButton(
                        onPressed: () {
                          gamesController.toggleShowMore();
                        },
                        child: Obx(() {
                          return Text(
                            gamesController.isShowMore.value
                                ? "Show less"
                                : "Show more",
                            style: const TextStyle(color: Colors.blue),
                          );
                        }),
                      ),

                      // Minimum Requirements
                      if (gameDetails.minimumSystemRequirements != null)
                        MinimumRequirment(
                            min: gameDetails.minimumSystemRequirements!),

                      // Similar Games
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Similar Games",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(() =>
                                  GamesGenreScreen(value: gameDetails.genre));
                            },
                            child: const Text(
                              "See all",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 400,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              min(20, gamesController.sameGenreGames.length),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => GameDetailsScreen(
                                    id: gamesController
                                        .sameGenreGames[index].id));
                              },
                              child: SizedBox(
                                height: 300,
                                width: 300,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: GameCard(
                                    gamemodel:
                                        gamesController.sameGenreGames[index],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      );
    });
  }

  void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Couldn't launch $url";
    }
  }
}
