import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/restaurant_search.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/utils/result_state.dart';

class SearchRestaurantPage extends StatefulWidget {
  static const routeName = '/searchpage';
  const SearchRestaurantPage({Key? key}) : super(key: key);

  @override
  State<SearchRestaurantPage> createState() => _SearchRestaurantPageState();
}

class _SearchRestaurantPageState extends State<SearchRestaurantPage> {
  final TextEditingController _controller = TextEditingController();
  Widget _buildList(BuildContext context) {
    return ChangeNotifierProvider<RestaurantSearch>(
        create: (_) => RestaurantSearch(
              apiService: ApiService(),
            ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.text,
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Search Restaurant',
                          labelText: 'Search',
                        )),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Builder(builder: (BuildContext context) {
                      return Container(
                        color: Colors.blue,
                        child: IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          context
                              .read<RestaurantSearch>()
                              .fetchSearchRestaurant(_controller.text);
                        },
                      ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<RestaurantSearch>(
                builder: (context, state, _) {
                  if (state.state == ResultState.loading) {
                    return const Center(child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ));
                  } else if (state.state == ResultState.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.result?.restaurants.length,
                      itemBuilder: (context, index) {
                        var restaurant = state.result!.restaurants[index];
                        return CardRestaurant(restaurant: restaurant);
                      },
                    );
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
                        child: Text(''),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ));
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant'),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Restaurant'),
        transitionBetweenRoutes: false,
      ),
      child: _buildList(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
