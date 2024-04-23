import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:convert';

class Proj { // 데이터베이스 모델 정의
  int? id;
  String name;
  String date; // 문자열로 저장
  String? imageUrl; // 파일 경로로 저장
  String monitoringItems; // Map을 문자열로 저장 (JSON)
  String measurements; // Map을 문자열로 저장 (JSON)

  Proj({
    this.id,
    required this.name,
    required this.date,
    this.imageUrl,
    required this.monitoringItems,
    required this.measurements,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'image_url': imageUrl,
      'monitoring_items': monitoringItems,
      'measurements': measurements,
    };
  }

  static Proj fromMap(Map<String, dynamic> map) {
    return Proj(
      id: map['id'],
      name: map['name'],
      date: map['date'],
      imageUrl: map['image_url'],
      monitoringItems: map['monitoring_items'],
      measurements: map['measurements'],
    );
  }
}

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'proj.db');
    return await openDatabase(
      path,
      version: 2, // 버전 변경
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE projs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            date TEXT,
            image_url TEXT,
            monitoring_items TEXT,
            measurements TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('DROP TABLE IF EXISTS projs');
          await initDatabase(); // 테이블 재생성
        }
      },
    );
  }

  Future<int> insertProj(Proj proj) async {
    Database db = await database;
    return await db.insert('projs', proj.toMap());
  }

  Future<List<Proj>> getProjs() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('projs');
    return maps.map((map) => Proj.fromMap(map)).toList(); // fromMap 사용
  }

  Future<void> updateProj(Proj proj) async {
    Database db = await database;
    await db.update(
      'projs',
      proj.toMap(),
      where: 'id = ?',
      whereArgs: [proj.id],
    );
  }

  Future<void> deleteProj(int id) async {
    Database db = await database;
    await db.delete(
      'projs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
