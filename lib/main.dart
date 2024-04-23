import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'project_data.dart';
import 'DatabaseHelper.dart';
import 'my_page.dart';

void main() {
  final databaseHelper = DatabaseHelper(); // DatabaseHelper 생성

  runApp(MyApp(databaseHelper: databaseHelper));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper databaseHelper; // DatabaseHelper 필드 선언

  MyApp({required this.databaseHelper}); // 생성자에서 파라미터 받기

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProjectData(databaseHelper: databaseHelper), // `ProjectData`에 `DatabaseHelper` 전달
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'G-VISION',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff4CAF50)),
        ),
        home: MyPage(databaseHelper: databaseHelper), // 더 이상 `DatabaseHelper` 필요 없음
      ),
    );
  }
}
