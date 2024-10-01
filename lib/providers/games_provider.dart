import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'package:flutter/material.dart';
import 'package:movies/models/detailed_game_model.dart';
import 'package:movies/models/game_model.dart';
import 'package:movies/services/api.dart';

class GamesProvider with ChangeNotifier {

  bool isLoading = false;
  List<GameModel> games = [];
  List<GameModel> sameGenreGames = [];
  DetailedGameModel? gamedetailes ;

  Api api=Api();


  fetchGamesByPlatform(String platform) async {
      isLoading = true;
      notifyListeners();
    final res = await api.get("https://www.freetogame.com/api/games?platform=$platform");

    if (res.statusCode == 200) {
      games.clear();
      var data = jsonDecode(res.body);
      games = List<GameModel>.from(data.map((game) => GameModel.fromJson(game)))
          .toList();
      print(res.body);
        isLoading = false;
        notifyListeners();
    }
  }

    fetchGame(int id) async {
      isLoading = true;
      notifyListeners();
    final res =
        await api.get("https://www.freetogame.com/api/game?id=$id");
    if (res.statusCode == 200) {
      gamedetailes = DetailedGameModel.fromJson(jsonDecode(res.body));
      print(gamedetailes!.id);
      fetchGamesByGenre(gamedetailes!.genre);
        isLoading = false;
        notifyListeners();
    }
  }

    fetchGamesByGenre(String genre) async {
      isLoading = true;
      notifyListeners();
    final res = await api.get("https://www.freetogame.com/api/games?category=$genre");
    if (res.statusCode == 200) {
      sameGenreGames.clear();
      var data = jsonDecode(res.body);
      sameGenreGames = List<GameModel>.from(data.map((game) => GameModel.fromJson(game)))
          .toList();

      fetchGamesByPlatform(gamedetailes!.genre);

      print(" the is the lesnth of the games ${games.length}");
        isLoading = false;
    } 
  }
}