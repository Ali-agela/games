import 'package:flutter/foundation.dart';
import 'package:http/http.dart ' as http ;
import 'package:http/http.dart ';

class Api {
  Future<Response> get(String url) async {
    
    var res =  await http.get(Uri.parse(url));

    if (kDebugMode){
      print("GET ON   $url");
      print("STATUS CODE : ${res.statusCode}");
      print("BODY : ${res.body}");
    }
    return res;

  }
}