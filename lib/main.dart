import 'package:flutter/material.dart';
import 'package:bootcamp_growdev_user_list/routes/routes.dart';
import 'package:bootcamp_growdev_user_list/screens/index_user_screen.dart';
import 'package:bootcamp_growdev_user_list/screens/create_user_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xff486FE7),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.INDEX_USER,
      routes: {
        AppRoutes.INDEX_USER: (_) => IndexUserScreen(),
        AppRoutes.CREATE_USER: (_) => CreateUserScreen(),
      },
    );
  }
}
