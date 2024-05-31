import 'package:flutter/material.dart';
import 'package:food_delivery_app/provider/meal_details_provider.dart';
import 'package:food_delivery_app/registration_page/login_form.dart';

import 'package:provider/provider.dart';

void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MealProvider(),
      child: MaterialApp(
        theme: ThemeData(primaryColor: Colors.red[500],
          accentColor: Colors.red[400],
        ),
        title: 'My App',
        home:  SafeArea(child: LoginPage(),//FirstHomeScreen()
        ),
      ),
    );
  }
}

