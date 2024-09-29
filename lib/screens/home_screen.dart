import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies/helpers/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:movies/models/game_model.dart';
import 'package:movies/widgets/game_card.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int nowIndex = 0;
  bool isLoading =true;
  List<GameModel> games = [];
fetchGamesByPlatform (String platform )async {
  setState(() {
    isLoading = true;
  });
  final  res = await  http.get(Uri.parse("https://www.freetogame.com/api/games?platform=$platform"));
  if(kDebugMode){
    print(res.statusCode);
  }
  if(res.statusCode==200){
    games.clear();
    var data= jsonDecode(res.body);
    games= List<GameModel>.from(data.map((game)=>GameModel.fromJson(game))).toList();
    setState(() {
      isLoading = false;
    });
  }
}
  @override
  void initState() {
    fetchGamesByPlatform("all");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
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
          ?fetchGamesByPlatform("all")
          :currentIndex==1
            ?fetchGamesByPlatform("pc")
            :fetchGamesByPlatform("browser");
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
            itemCount: isLoading?6:games.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) => AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
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
                            )),
                      )
                    : GameCard(gamemodel: games[index]))),
      ),
    );
  }
}
