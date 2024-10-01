import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fullscreen_image_viewer/fullscreen_image_viewer.dart';
import 'package:movies/providers/dark_mode_provider.dart';
import 'package:movies/providers/games_provider.dart';
import 'package:movies/screens/games_genre_screen.dart';
import 'package:movies/widgets/game_card.dart';
import 'package:movies/widgets/minimum_requirment.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class GameDetailsScreen extends StatefulWidget {
  GameDetailsScreen({super.key, required this.id});
  final int id;

  String buttontext = "Show more";

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  bool isShowMore = false;

  @override
  void initState() {
    Provider.of<GamesProvider>(context, listen: false).fetchGame(widget.id);
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
          title: gamesConsumer.gamedetailes == null
              ? SizedBox()
              : Text(
                  gamesConsumer.gamedetailes!.title,
                  style: TextStyle(
                      color: darkModeConsumer.isDark
                          ? Colors.white
                          : Colors.black),
                ),
          centerTitle: true,
        ),
        body: gamesConsumer.isLoading || gamesConsumer.gamedetailes == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              gamesConsumer.gamedetailes!.thumbnail,
                              fit: BoxFit.fill,
                            ),
                            Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 1, horizontal: 4),
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(110)),
                                  child: ElevatedButton(
                                    child: const Text("go to game"),
                                    onPressed: () {
                                      lunchEXUrl(
                                          gamesConsumer.gamedetailes!.gameUrl);
                                    },
                                  ),
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: gamesConsumer
                                  .gamedetailes!.screenshots.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      FullscreenImageViewer.open(
                                        context: context,
                                        child: Hero(
                                          tag: "hero",
                                          child: Image.network(
                                              gamesConsumer.gamedetailes!
                                                  .screenshots[index].image,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                            return loadingProgress != null
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator())
                                                : child;
                                          }),
                                        ),
                                      );
                                    },
                                    child: Hero(
                                      tag: "hero",
                                      child: Image.network(
                                          gamesConsumer.gamedetailes!
                                              .screenshots[index].image,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                        return loadingProgress != null
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : child;
                                      }),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Row(
                          children: [
                            Text(
                              "Description",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: darkModeConsumer.isDark
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: darkModeConsumer.isDark
                                      ? Colors.white
                                      : Colors.black),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child: Text(gamesConsumer.gamedetailes!.genre),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: darkModeConsumer.isDark
                                      ? Colors.white
                                      : Colors.black),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child: Text(gamesConsumer.gamedetailes!.status),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: darkModeConsumer.isDark
                                      ? Colors.white
                                      : Colors.black),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child:
                                    Text(gamesConsumer.gamedetailes!.platform),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          gamesConsumer.gamedetailes!.description,
                          maxLines: isShowMore ? 50 : 3,
                          style: TextStyle(
                              color: darkModeConsumer.isDark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            isShowMore = isShowMore;
                            if (widget.buttontext == "Show more") {
                              widget.buttontext = "Show less";
                            } else {
                              widget.buttontext = "Show more";
                            }
                            setState(() {});
                          },
                          child: Text(
                            widget.buttontext,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        gamesConsumer.gamedetailes!.minimumSystemRequirements !=
                                null
                            ? MinimumRequirment(
                                min: gamesConsumer
                                    .gamedetailes!.minimumSystemRequirements!)
                            : const SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              gamesConsumer.gamedetailes!.genre,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GamesGenreScreen(
                                                  value: gamesConsumer
                                                      .gamedetailes!.genre)));
                                },
                                child: const Text(
                                  "see all",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.blue),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 400,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  min(20, gamesConsumer.sameGenreGames.length),
                              itemBuilder: (context, index) {
                                print(gamesConsumer.games[index].title);
                                return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: gamesConsumer.isLoading
                                            ? CircularProgressIndicator()
                                            : GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              GameDetailsScreen(
                                                                  id: gamesConsumer
                                                                      .sameGenreGames[
                                                                          index]
                                                                      .id)));
                                                },
                                                child: SizedBox(
                                                  height: 300,
                                                  width: 300,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: GameCard(
                                                        gamemodel: gamesConsumer
                                                                .sameGenreGames[
                                                            index]),
                                                  ),
                                                ),
                                              )));
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      );
    });
  }

  lunchEXUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "couldn`t lunch $url ";
    }
  }
}
