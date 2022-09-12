import 'package:flutter/material.dart';
import 'package:restaurant_app/ui/detail_resto.dart';
import 'package:restaurant_app/ui/home_page.dart';
import 'package:restaurant_app/data/model/local_restaurant.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/ui/search_restaurant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
              onPrimary: Colors.black,
              secondary: secondaryColor,
            ),
        textTheme: myTextTheme,
        appBarTheme: const AppBarTheme(elevation: 0),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              ),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/detailpage': (context) => DetailRestaurant(
            restaurant:
                ModalRoute.of(context)?.settings.arguments as Restaurant),
        '/searchpage':(context) => const SearchRestaurantPage(),
      },
    );
  }
}
