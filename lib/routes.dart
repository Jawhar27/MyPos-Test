import 'package:mypos_task/models/employee.dart';
import 'package:mypos_task/pages/employees/add_employee_screen.dart';
import 'package:mypos_task/pages/employees/employee_detail_screen.dart';
import 'package:mypos_task/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:mypos_task/pages/splash_screen.dart';

class ScreenRoutes {
  static const String toSplashScreen = "toSplashScreen";
  static const String toHomeScreen = "toHomeScreen";
  static const String toAddEmployeeScreen = "toAddEmployeeScreen";
  static const String toEmployeeDetailScreen = "toEmployeeDetailScreen";
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map data = (settings.arguments ?? {}) as Map;
    switch (settings.name) {
      case ScreenRoutes.toSplashScreen:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
          settings: settings,
        );

      case ScreenRoutes.toHomeScreen:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
          settings: settings,
        );

      case ScreenRoutes.toAddEmployeeScreen:
        var data = (settings.arguments ?? {}) as Map;
        bool? isUpdate = data['isUpdate'];
        String? empNo = data['empNo'];
        String? departmentCode = data['departmentCode'];
        Function? refresh = data['refresh'];

        return MaterialPageRoute(
          builder: (_) => AddEmployeeScreen(
            empNo: empNo ?? '',
            isUpdate: isUpdate ?? false,
            departCode: departmentCode ?? '',
            refresh: refresh ?? () {},
          ),
          settings: settings,
        );

      case ScreenRoutes.toEmployeeDetailScreen:
        var data = (settings.arguments ?? {}) as Map;
        Employee employee = data['employee'];
        Function? refresh = data['refresh'];
        return MaterialPageRoute(
          builder: (_) => EmployeeDetailScreen(
            employee: employee,
            refresh: refresh ?? () {},
          ),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
          settings: settings,
        );
    }
  }
}
