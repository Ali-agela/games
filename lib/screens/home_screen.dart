import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies/helpers/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/providers/dark_mode_provider.dart';
import 'package:movies/providers/games_provider.dart';
import 'package:movies/widgets/game_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int nowIndex = 0;

  @override
  void initState() {
    Provider.of<GamesProvider>(context, listen: false)
        .fetchGamesByPlatform("all");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GamesProvider, DarkModeProvider>(
        builder: (context, gamesConsumer, darkModeConsumer, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "GAMER",
            style: TextStyle(
                color: darkModeConsumer.isDark ? Colors.white : Colors.black),
          ),
          backgroundColor:
              darkModeConsumer.isDark ? Colors.black : Colors.white,
          leading: Switch(
              value: darkModeConsumer.isDark,
              onChanged: (value) {
                darkModeConsumer.switchMode();
              }),
        ),
        backgroundColor: darkModeConsumer.isDark ? Colors.black : Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor:
              darkModeConsumer.isDark ? Colors.black : Colors.white,
          selectedItemColor: redColor,
          selectedLabelStyle: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 0,
          ),
          onTap: (currentIndex) {
            setState(() {
              nowIndex = currentIndex;
            });
            currentIndex == 0
                ? gamesConsumer.fetchGamesByPlatform("all")
                : currentIndex == 1
                    ? gamesConsumer.fetchGamesByPlatform("pc")
                    : gamesConsumer.fetchGamesByPlatform("browser");
          },
          currentIndex: nowIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.gamepad), label: "all"),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.computer), label: "pc"),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.globe), label: "web")
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
              itemCount:
                  gamesConsumer.isLoading ? 6 : gamesConsumer.games.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) => AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: gamesConsumer.isLoading
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Shimmer.fromColors(
                              baseColor: Colors.black12,
                              highlightColor: Colors.white38,
                              child: Container(
                                color: Colors.white,
                                height: double.infinity,
                                width: double.infinity,
                              )),
                        )
                      : GameCard(gamemodel: gamesConsumer.games[index]))),
        ),
      );
    });
  }
}
