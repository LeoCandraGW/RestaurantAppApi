import 'dart:async';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/search_restaurant.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/utils/result_state.dart';


class RestaurantSearch extends ChangeNotifier {
  final ApiService apiService;

  RestaurantSearch({required this.apiService});

  late SearchRestaurant? _searchRestaurant;
  late ResultState _state= ResultState.noData;
  String _message = '';

  String get message => _message;

  SearchRestaurant? get result => _searchRestaurant;

  ResultState get state => _state;

  Future<dynamic> fetchSearchRestaurant(query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.searchRestaurant(query);
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _searchRestaurant = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}