import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/device_monitor_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/history_screen.dart';
import '../screens/about_screen.dart';


class AppRoutes {
  // 路由名称常量
  static const String splash = '/';
  static const String home = '/home';
  static const String setting = '/setting';
  static const String history = '/history';
  static const String about = '/about';

  // 路由映射表
  static Map<String, WidgetBuilder> routes = {
    splash: (context) => SplashScreen(),
    home: (context) => DeviceMonitorScreen(),
    setting: (context) => SettingsScreen(),
    history: (context) => HistoryScreen(),
    about: (context) => AboutScreen()
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              DeviceMonitorScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: Offset(1.0, 0.0), end: Offset.zero).chain(
                  CurveTween(curve: Curves.ease),
                ),
              ),
              child: child,
            );
          },
        );
      case setting:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              SettingsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      default:
        return null;
    }
  }

  static void pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static void pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  static void pushAndClearStack(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
          (route) => false,
    );
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}