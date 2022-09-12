import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/search_restaurant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchRestaurantPage extends StatefulWidget {
  static const routeName = '/searchpage';
  const SearchRestaurantPage({Key? key}) : super(key: key);

  @override
  State<SearchRestaurantPage> createState() => _SearchRestaurantPageState();
}

class _SearchRestaurantPageState extends State<SearchRestaurantPage> {
  String name = " ";
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<SearchRestaurant> searchResto() async {
    final response = await http.get(Uri.parse("${_baseUrl}search?q=$name"));
    if (response.statusCode == 200) {
      return SearchRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top headlines');
    }
  }

  late Future<SearchRestaurant> _restaurant;

  @override
  void initState() {
    super.initState();
    _restaurant = searchResto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search Restaurant'),
        ),
        body: Material(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        labelText: 'Search',
                      ),
                      onChanged: (String value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: const Icon(
                        Icons.search,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/searchpage',
                          arguments: name
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildSearch(context),
            ),
          ],
        )));
  }

  Widget _buildSearch(BuildContext context) {
    return FutureBuilder(
      future: _restaurant,
      builder: (context, AsyncSnapshot<SearchRestaurant> snapshot) {
        var state = snapshot.connectionState;
        if (state != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.restaurants.length,
            itemBuilder: (context, index) {
              var restaurant = snapshot.data?.restaurants[index];
              return SearchList(
                restaurant: restaurant!,
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Material(
              child: Text(snapshot.error.toString()),
            ),
          );
        } else {
          return const Material(child: Text(''));
        }
      },
    );
  }
}

class SearchList extends StatelessWidget {
  final RestaurantSearch restaurant;
  const SearchList({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      leading: Hero(
        tag: restaurant.pictureId,
        child: Image.network(
          "https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}",
          width: 100,
        ),
      ),
      title: Text(
        restaurant.name,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.place,
                  size: 15.0,
                ),
                Text(restaurant.city)
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.star,
                  size: 15.0,
                ),
                Text(restaurant.rating.toString()),
              ],
            ),
          ),
        ],
      ),
      onTap: () => Navigator.pushNamed(
        context,
        '/detailpage',
        arguments: restaurant,
      ),
    );
  }
}
