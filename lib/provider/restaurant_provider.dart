import 'dart:async';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/local_restaurant.dart';
import 'package:restaurant_app/utils/result_state.dart';
import 'package:flutter/material.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  late LocalRestaurant _restaurantResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  LocalRestaurant get result => _restaurantResult;

  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.topHeadlines();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'No Internet Connection';
    }
  }
}
