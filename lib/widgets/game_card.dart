import 'package:flutter/material.dart';
import 'package:movies/models/game_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies/providers/dark_mode_provider.dart';
import 'package:movies/screens/game_details_screen.dart';
import 'package:provider/provider.dart';

class GameCard extends StatelessWidget {
  GameCard({super.key, required this.gamemodel});
  final GameModel gamemodel;
  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(
      builder: (context,darkModeConsumer,_) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GameDetailsScreen(id: gamemodel.id)));
          },
          child: Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GridTile(
                header: Container(
                    height: 60,
                    decoration: gameCardBoxDecoration("top", darkModeConsumer),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            gamemodel.genre,
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            gamemodel.platform.contains("Windows")
                                ? FontAwesomeIcons.computer
                                : FontAwesomeIcons.globe,
                            color: Colors.white,
                            size: 12,
                          )
                        ],
                      ),
                    )),
                footer: Container(
                  height: 80,
                  decoration: gameCardBoxDecoration("bottom", darkModeConsumer),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          gamemodel.publisher,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                                child: AutoSizeText(
                              gamemodel.title,
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
                              maxFontSize: 16,
                              minFontSize: 10,
                              maxLines: 2,
                            ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                child: Container(
                  color: Colors.black12,
                  child: Image.network(
                    gamemodel.thumbnail,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loading) {
                      return loading == null
                          ? child
                          : const Center(
                              child: CircularProgressIndicator(),
                            );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}

BoxDecoration gameCardBoxDecoration(String pos,DarkModeProvider darkModeConsumer) {
  return pos == "bottom"
      ? const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black87, Colors.transparent],
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter))
      : const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black87, Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter));
}
