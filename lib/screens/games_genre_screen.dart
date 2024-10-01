import 'package:flutter/material.dart';
import 'package:movies/providers/dark_mode_provider.dart';
import 'package:movies/providers/games_provider.dart';
import 'package:movies/widgets/game_card.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class GamesGenreScreen extends StatefulWidget {
  const GamesGenreScreen({super.key, required this.value});
  final String value;

  @override
  State<GamesGenreScreen> createState() => _GamesGenreScreenState();
}

class _GamesGenreScreenState extends State<GamesGenreScreen> {
  void initState() {
    Provider.of<GamesProvider>(context, listen: false).sameGenreGames;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GamesProvider, DarkModeProvider>(
        builder: (context, gamesConsumer, darkModeConsumer, _) {
      return Scaffold(
        backgroundColor: darkModeConsumer.isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor:
              darkModeConsumer.isDark ? Colors.black : Colors.white,
          title: Text("genre" ":" + widget.value,
          style: TextStyle(
            color:darkModeConsumer.isDark
          ?Colors.white
          :Colors.black
          ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
              itemCount: gamesConsumer.isLoading
                  ? 6
                  : gamesConsumer.sameGenreGames.length,
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
                      : GameCard(
                          gamemodel: gamesConsumer.sameGenreGames[index]))),
        ),
      );
    });
  }
}
