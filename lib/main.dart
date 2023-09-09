import 'package:mypos_task/pages/main_screen.dart';
import 'package:mypos_task/services/api_service.dart';
import 'package:mypos_task/routes.dart' as router;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Crud',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: router.Router.generateRoute,
      initialRoute: router.ScreenRoutes.toSplashScreen,
      debugShowCheckedModeBanner: false,
    );
  }
}
