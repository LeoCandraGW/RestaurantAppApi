import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/data/model/local_restaurant.dart';
import 'package:flutter/material.dart';

class CardRestaurant extends StatelessWidget {
  final Restaurant restaurant;

  const CardRestaurant({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primaryColor,
      child: ListTile(
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
          arguments: restaurant.id,
        ),
      ),
    );
  }
}
