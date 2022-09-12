import 'package:restaurant_app/data/model/local_restaurant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'dart:convert';

class DetailRestaurant extends StatefulWidget {
  static const routeName = '/detailpage';

  final Restaurant restaurant;

  const DetailRestaurant({Key? key, required this.restaurant})
      : super(key: key);

  @override
  State<DetailRestaurant> createState() => _DetailRestaurantState();
}

class _DetailRestaurantState extends State<DetailRestaurant> {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  Future<DetailRestaurant1> detailResto() async {
    final response =
        await http.get(Uri.parse("${_baseUrl}detail/${widget.restaurant.id}"));
    if (response.statusCode == 200) {
      return DetailRestaurant1.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top headlines');
    }
  }

  late Future<DetailRestaurant1> _restaurant;

  @override
  void initState() {
    super.initState();
    _restaurant = detailResto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restaurant App',
        ),
      ),
      body: FutureBuilder(
        future: _restaurant,
        builder: (context, AsyncSnapshot<DetailRestaurant1> snapshot) {
          var state = snapshot.connectionState;
          if (state != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            var restaurant = snapshot.data?.restaurant;
            return DetailResto(restaurants: restaurant!);
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
      ),
    );
  }
}

class DetailResto extends StatelessWidget {
  final RestaurantDetail restaurants;
  const DetailResto({Key? key, required this.restaurants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: restaurants.pictureId,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                child: Image.network(
                    "https://restaurant-api.dicoding.dev/images/medium/${restaurants.pictureId}"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text(
                        restaurants.name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.star,
                                  size: 15.0,
                                ),
                                Text(restaurants.rating.toString()),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.place,
                                  size: 15.0,
                                ),
                                Text(restaurants.city)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  const Divider(color: Colors.grey),
                  Text(
                    restaurants.description,
                    textAlign: TextAlign.justify,
                  ),
                  const Divider(color: Colors.grey),
                  Text(
                    'Foods',
                    style: Theme.of(context).textTheme.bodyText2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Divider(color: Colors.grey),
                  FoodGridView(restaurants: restaurants),
                  const Divider(color: Colors.grey),
                  Text(
                    'Drinks',
                    style: Theme.of(context).textTheme.bodyText2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Divider(color: Colors.grey),
                  DrinkGridView(restaurants: restaurants),
                  const Divider(color: Colors.grey),
                  Text(
                    'Reviews',
                    style: Theme.of(context).textTheme.bodyText2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Divider(color: Colors.grey),
                  ReviewGridView(restaurants: restaurants),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodGridView extends StatelessWidget {
  final RestaurantDetail restaurants;
  const FoodGridView({Key? key, required this.restaurants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        primary: false,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150,
          crossAxisSpacing: 30,
          mainAxisSpacing: 10,
        ),
        itemCount: restaurants.menus.foods.length,
        itemBuilder: (BuildContext context, index) {
          return Card(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      restaurants.menus.foods[index].name,
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class DrinkGridView extends StatelessWidget {
  final RestaurantDetail restaurants;
  const DrinkGridView({Key? key, required this.restaurants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        primary: false,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150,
          crossAxisSpacing: 30,
          mainAxisSpacing: 10,
        ),
        itemCount: restaurants.menus.drinks.length,
        itemBuilder: (BuildContext context, index) {
          return Card(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      restaurants.menus.drinks[index].name,
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class ReviewGridView extends StatelessWidget {
  final RestaurantDetail restaurants;
  const ReviewGridView({Key? key, required this.restaurants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: restaurants.customerReviews.length,
        itemBuilder: (BuildContext context, index) {
          return ListTile(
            title: Text(
              restaurants.customerReviews[index].name,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    restaurants.customerReviews[index].date,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      restaurants.customerReviews[index].review,
                    ),
                  ),
                ],
              ),
          );
        });
  }
}
