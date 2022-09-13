import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/utils/result_state.dart';
import 'package:restaurant_app/provider/restaurant_detail.dart';
import 'package:restaurant_app/data/api/api_service.dart';

class DetailRestaurant extends StatelessWidget {
  static const routeName = '/detailpage';

  final String id;

  const DetailRestaurant({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restaurant App',
        ),
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return ChangeNotifierProvider(
      create: (_) =>
          RestaurantDetailProvider(apiService: ApiService(), restoId: id),
      child: Scaffold(
        body: Consumer<RestaurantDetailProvider>(builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ));
          } else if (state.state == ResultState.hasData) {
            var restaurant = state.result!.restaurant;
            return DetailResto(restaurants: restaurant);
          } else if (state.state == ResultState.noData) {
            return Center(
              child: Material(
                child: Text(state.message),
              ),
            );
          } else if (state.state == ResultState.error) {
            return Center(
              child: Material(
                child: Text(state.message),
              ),
            );
          } else {
            return const Center(
              child: Material(
                child: Text(""),
              ),
            );
          }
        }),
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
