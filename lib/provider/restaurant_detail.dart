import 'dart:async';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/utils/result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  String restoId= '';

  RestaurantDetailProvider({required this.apiService, required this.restoId}){
    fetchDetailRestaurant(restoId);
  }

  late DetailRestaurant1? _detailRestaurant;
  ResultState _state = ResultState.noData;
  String _message = '';

  String get message => _message;

  DetailRestaurant1? get result => _detailRestaurant;

  ResultState get state => _state;

  Future<dynamic> fetchDetailRestaurant(id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.detailRestaurant(id);
      _state = ResultState.hasData;
      notifyListeners();
      return _detailRestaurant = restaurant;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'No Internet Connection';
    }
  }
}
