import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/controllers/dark_mode_controller.dart';
import 'package:movies/controllers/games_controller.dart';
import 'package:movies/helpers/constants.dart';
import 'package:movies/widgets/game_card.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  final DarkModeController darkModeController = Get.put(DarkModeController());
  final GamesController gamesController = Get.put(GamesController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = darkModeController.isDark.value;
      final isLoading = gamesController.isLoading.value;
      final games = gamesController.games;

      return Scaffold(
        appBar: AppBar(
          title: Text(
            "GAMER",
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          backgroundColor: isDark ? Colors.black : Colors.white,
          leading: Switch(
            value: isDark,
            onChanged: (value) {
              darkModeController.switchMode();
            },
          ),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        bottomNavigationBar: Obx(() {
          return BottomNavigationBar(
            backgroundColor: isDark ? Colors.black : Colors.white,
            selectedItemColor: redColor,
            selectedLabelStyle: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 0,
            ),
            onTap: (currentIndex) {
              gamesController.updateIndex(currentIndex);
              gamesController.fetchGamesByPlatform(
                currentIndex == 0
                    ? "all"
                    : currentIndex == 1
                        ? "pc"
                        : "browser",
              );
            },
            currentIndex: gamesController.nowIndex.value,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.gamepad), label: "all"),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.computer), label: "pc"),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.globe), label: "web"),
            ],
          );
        }),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            itemCount: isLoading ? 6 : games.length,
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
                    : GameCard(gamemodel: games[index]),
              );
            },
          ),
        ),
      );
    });
  }
}
