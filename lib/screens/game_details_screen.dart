import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fullscreen_image_viewer/fullscreen_image_viewer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movies/models/detailed_game_model.dart';
import 'package:movies/models/game_model.dart';
import 'package:movies/screens/games_genre_screen.dart';
import 'package:movies/widgets/game_card.dart';

class GameDetailsScreen extends StatefulWidget {
  GameDetailsScreen({super.key, required this.id});
  final int id;

  bool isShowMore = false;
  String buttontext = "Show more";

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  DetailedGameModel? gamedetailes;
  bool isLoading = true;
  bool isLoading2 = true;
  List<GameModel> games = [];
  fetchGame(int id) async {
    setState(() {
      isLoading = true;
    });
    final res =
        await http.get(Uri.parse("https://www.freetogame.com/api/game?id=$id"));
    if (res.statusCode == 200) {
      gamedetailes = DetailedGameModel.fromJson(jsonDecode(res.body));
      print("before ");
      print(gamedetailes!.id);
      fetchGamesByPlatform(gamedetailes!.genre);
      print("after ");
      setState(() {
        isLoading = false;
      });
    }
  }

  fetchGamesByPlatform(String genre) async {
    setState(() {
      isLoading2 = true;
    });
    print("before ");
    final res = await http
        .get(Uri.parse("https://www.freetogame.com/api/games?category=$genre"));
    print("after ");
    if (res.statusCode == 200) {
      games.clear();
      var data = jsonDecode(res.body);
      games = List<GameModel>.from(data.map((game) => GameModel.fromJson(game)))
          .toList();

      fetchGamesByPlatform(gamedetailes!.genre);

      print(" the is the lesnth of the games ${games.length}");
      setState(() {
        isLoading2 = false;
      });
    } else {
      print(res.statusCode);
    }
  }

  @override
  void initState() {
    fetchGame(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: gamedetailes == null ? SizedBox() : Text(gamedetailes!.title),
        centerTitle: true,
      ),
      body: isLoading || gamedetailes == null
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
                      Image.network(
                        gamedetailes!.thumbnail,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   child: Container(
                      //     height: 100,
                      //     child: Row(
                      //       children: [
                      //         Padding(
                      //           padding: EdgeInsets.symmetric(horizontal: 8),
                      //           child: Image.network(
                      //               gamedetailes!.screenshots[0].image,
                      //               loadingBuilder:
                      //                   (context, child, loadingProgress) {
                      //             return CircularProgressIndicator();
                      //           }),
                      //         ),
                      //         Padding(
                      //           padding: EdgeInsets.symmetric(horizontal: 8),
                      //           child: Image.network(
                      //               gamedetailes!.screenshots[1].image,
                      //               loadingBuilder:
                      //                   (context, child, loadingProgress) {
                      //             return CircularProgressIndicator();
                      //           }),
                      //         ),
                      //         Padding(
                      //           padding: EdgeInsets.symmetric(horizontal: 8),
                      //           child: Image.network(
                      //             gamedetailes!.screenshots.first.image,
                      //             loadingBuilder:
                      //                 (context, child, loadingProgress) {
                      //               return CircularProgressIndicator();
                      //             },
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: gamedetailes!.screenshots.length,
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
                                            gamedetailes!
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
                                        gamedetailes!.screenshots[index].image,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
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
                          const Text(
                            "Description",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.black12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4),
                              child: Text(gamedetailes!.genre),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.black12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4),
                              child: Text(gamedetailes!.status),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.black12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4),
                              child: Text(gamedetailes!.platform),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        gamedetailes!.description,
                        maxLines: widget.isShowMore ? 50 : 3,
                      ),
                      TextButton(
                        onPressed: () {
                          widget.isShowMore = !widget.isShowMore;
                          if (widget.buttontext == "Show more") {
                            widget.buttontext = "Show less";
                          } else {
                            widget.buttontext = "Show more";
                          }
                          setState(() {});
                        },
                        child: Text(
                          widget.buttontext,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      gamedetailes!.minimumSystemRequirements != null
                          ? Text(
                              "${gamedetailes!.minimumSystemRequirements!.graphics} \n ${gamedetailes!.minimumSystemRequirements!.memory} \n ${gamedetailes!.minimumSystemRequirements!.os}  \n ${gamedetailes!.minimumSystemRequirements!.processor}\n ${gamedetailes!.minimumSystemRequirements!.storage}")
                          : const SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            gamedetailes!.genre,
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
                                        builder: (context) => GamesGenreScreen(
                                            value: gamedetailes!.genre)));
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
                            itemCount: min(20, games.length),
                            itemBuilder: (context, index) {
                              print(games[index].title);
                              return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: isLoading
                                          ? CircularProgressIndicator()
                                          : GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            GameDetailsScreen(
                                                                id: games[index]
                                                                    .id)));
                                              },
                                              child: SizedBox(
                                                height: 300,
                                                width: 300,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: GameCard(
                                                      gamemodel: games[index]),
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
  }
}
