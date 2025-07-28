import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/device_data_provider.dart';
import 'routes/app_routes.dart'; // 导入路由文件

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DeviceDataProvider(),
      child: MaterialApp(
        title: 'Equipment monitor',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        // 使用路由配置
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}