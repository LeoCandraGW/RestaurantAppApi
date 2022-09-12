import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/local_restaurant.dart';
 
class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
 
  Future<LocalRestaurant> topHeadlines() async {
    
      final response = await http.get(Uri.parse("${_baseUrl}list"));
    if (response.statusCode == 200) {
      return LocalRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top headlines');
    }
    } 

 
  }
