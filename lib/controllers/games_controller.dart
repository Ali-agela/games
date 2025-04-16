import 'dart:convert';
import 'package:get/get.dart';
import 'package:movies/models/detailed_game_model.dart';
import 'package:movies/models/game_model.dart';
import 'package:movies/services/api.dart';

class GamesController extends GetxController {
  // Reactive variables
  var isLoading = false.obs;
  var games = <GameModel>[].obs;
  var sameGenreGames = <GameModel>[].obs;
  var gamedetailes = Rxn<DetailedGameModel>();
  var nowIndex = 0.obs;
  var isShowMore = false.obs; // Reactive variable for "Show more"

  final Api api = Api();

  // Fetch games by platform
  Future<void> fetchGamesByPlatform(String platform) async {
    isLoading.value = true;
    final res = await api
        .get("https://www.freetogame.com/api/games?platform=$platform");

    if (res.statusCode == 200) {
      games.clear();
      var data = jsonDecode(res.body);
      games.addAll(
          List<GameModel>.from(data.map((game) => GameModel.fromJson(game))));
      print(res.body);
    }
    isLoading.value = false;
    update();
  }

  // Fetch game details by ID
  Future<void> fetchGame(int id) async {
    isLoading.value = true;
    final res = await api.get("https://www.freetogame.com/api/game?id=$id");

    if (res.statusCode == 200) {
      gamedetailes.value = DetailedGameModel.fromJson(jsonDecode(res.body));
      print(gamedetailes.value!.id);
      await fetchGamesByGenre(gamedetailes.value!.genre);
    }
    isLoading.value = false;
    update();
  }

  // Fetch games by genre
  Future<void> fetchGamesByGenre(String genre) async {
    isLoading.value = true;
    final res =
        await api.get("https://www.freetogame.com/api/games?category=$genre");

    if (res.statusCode == 200) {
      sameGenreGames.clear();
      var data = jsonDecode(res.body);
      sameGenreGames.addAll(
          List<GameModel>.from(data.map((game) => GameModel.fromJson(game))));
      print("The length of the games is ${games.length}");
    }
    isLoading.value = false;
    update();
  }

  void toggleShowMore() {
    isShowMore.value = !isShowMore.value; // Toggle the value
    update();
  }

  void updateIndex(int index) {
    nowIndex.value = index;
    update();
  }
}
