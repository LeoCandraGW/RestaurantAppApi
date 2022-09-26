import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/data/model/local_restaurant.dart';
import 'package:restaurant_app/data/model/search_restaurant.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  final Client client;

  ApiService(this.client);

  Future<LocalRestaurant> topHeadlines() async {
    final response = await client.get(Uri.parse("${_baseUrl}list"));
    if (response.statusCode == 200) {
      return LocalRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('No Internet Connection');
    }
  }

  Future<DetailRestaurant1> detailRestaurant(String id) async {
    final response = await client.get(Uri.parse("${_baseUrl}detail/$id"));
    if (response.statusCode == 200) {
      return DetailRestaurant1.fromJson(json.decode(response.body));
    } else {
      throw Exception('No Internet Connection');
    }
  }

  Future<SearchRestaurant> searchRestaurant(query) async {
    final response = await client.get(Uri.parse("${_baseUrl}search?q=$query"));
    if (response.statusCode == 200) {
      return SearchRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('No Internet Connection');
    }
  }
}
