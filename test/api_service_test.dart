import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/data/model/local_restaurant.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class ApiTest extends Mock implements http.Client {}

main() {
  ApiTest client;
  ApiService apiService;
  final dummyListJsonInString=LocalRestaurant(
        error: false, 
        message: "message", 
        count: 1, 
        restaurants: <Restaurant>[]
        );
  client = ApiTest();
  apiService = ApiService(client);
  setUp(() {
    client = ApiTest();
    apiService = ApiService(client);
  });

  group("fetchAllRestaurant", () {
    test("should request complate", () async {
      when(client.get(Uri.parse("https://restaurant-api.dicoding.dev/list"))).thenAnswer(
        (_) async => http.Response(dummyListJsonInString.toString(), 200),
      );

      final restaurants = await apiService.topHeadlines();
      expect(restaurants, isA<LocalRestaurant>());
    });

    test("should request failed", () async {
      when(
        client.get(Uri.parse("https://restaurant-api.dicoding.dev/list")),
      ).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      final restaurants = apiService.topHeadlines();
      expect(() => restaurants, throwsA(isInstanceOf<Exception>()));
    });
  });

  group("fetchDetailRestaurant", () {
    test("should request complate", () async {
      when(
        client.get(Uri.parse("https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867")
            ),
      ).thenAnswer(
        (_) async => http.Response(dummyListJsonInString.toString(), 200),
      );

      expect(await apiService.detailRestaurant("rqdv5juczeskfw1e867"),
          isA<RestaurantDetail>());
    });

    test("should request failed", () async {
      when(
        client.get(Uri.parse( "https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867")
           ),
      ).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      final call = apiService.detailRestaurant("rqdv5juczeskfw1e867");
      expect(() => call, throwsA(isInstanceOf<Exception>()));
    });
  });
}
