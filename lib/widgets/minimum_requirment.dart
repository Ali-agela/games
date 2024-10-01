
import 'package:flutter/material.dart';
import 'package:movies/models/detailed_game_model.dart';
import 'package:movies/providers/dark_mode_provider.dart';
import 'package:provider/provider.dart';

class MinimumRequirment extends StatelessWidget {
  const MinimumRequirment({super.key, required this.min});
  final MinimumSystemRequirements min;
  @override
  Widget build(BuildContext context) {
    return   Consumer<DarkModeProvider>(
      builder: (context, darkModeConsumer,_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("minumum systme reqierments ",
            style: TextStyle(
              fontWeight: FontWeight.bold,fontSize: 24,
              color: darkModeConsumer.isDark
              ?Colors.white
              :Colors.black
            ),
            ),
            const SizedBox(height: 16,),
            Text("OS : ${min.os}",style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: darkModeConsumer.isDark ? Colors.white : Colors.black
              ),),
            Text("Memory : ${min.memory}",style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: darkModeConsumer.isDark ? Colors.white : Colors.black
              ),),
            Text("Processor : ${min.processor}",style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: darkModeConsumer.isDark ? Colors.white : Colors.black
              ),),
            Text("Graphics : ${min.graphics}",style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: darkModeConsumer.isDark ? Colors.white : Colors.black
            ),),
            Text("Storage : ${min.storage}",style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: darkModeConsumer.isDark ? Colors.white : Colors.black
              ),)
        
          ],
        );
      }
    );
  }
}