import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';
import 'dart:convert'; // JSON 변환을 위한 import

class Project {
  int? id;
  String name;
  String? imageUrl;
  DateTime creationDate;
  Map<String, bool> monitoringItems;  // For tracking monitoring items
  Map<String, dynamic> measurements;  // For storing measurements

  Project({
    this.id,
    required this.name,
    this.imageUrl,
    required this.creationDate,
    required this.monitoringItems,
    required this.measurements,
  });

  // Project to Proj (데이터베이스 모델로 변환)
  Proj toProj() {
    return Proj(
      id: id,
      name: name,
      date: creationDate.toIso8601String(),
      imageUrl: imageUrl,
      monitoringItems: jsonEncode(monitoringItems), // JSON 문자열로 변환
      measurements: jsonEncode(measurements), // JSON 문자열로 변환
    );
  }

  // Proj to Project (프로바이더 모델로 변환)
  static Project fromProj(Proj proj) {
    return Project(
      id: proj.id,
      name: proj.name,
      imageUrl: proj.imageUrl,
      creationDate: DateTime.parse(proj.date), // 문자열에서 DateTime으로 변환
      monitoringItems: jsonDecode(proj.monitoringItems), // JSON에서 Map으로 변환
      measurements: jsonDecode(proj.measurements), // JSON에서 Map으로 변환
    );
  }
}

class ProjectData extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  List<Project> _projects = []; // Proj 대신 Project 사용

  ProjectData({required this.databaseHelper}) {
    _loadProjects();
  }

  List<Project> get projects => _projects; // Proj 대신 Project 반환

  Future<void> _loadProjects() async {
    var projs = await databaseHelper.getProjs(); // 데이터베이스에서 가져오기
    _projects = projs.map((proj) => Project.fromProj(proj)).toList(); // Project로 변환
    notifyListeners(); // 데이터 변경 알림
  }

  Future<void> addProject(Project project) async {
    var proj = project.toProj(); // Proj로 변환
    int id = await databaseHelper.insertProj(proj); // 데이터베이스에 추가
    project.id = id; // 생성된 ID 설정
    _projects.add(project); // 프로바이더 상태 업데이트
    notifyListeners(); // 데이터 변경 알림
  }

  Future<void> editProject(int index, Project updatedProject) async {
    if (index >= 0 && index < _projects.length) {
      // Proj 객체를 생성하고 이름을 변경
      var updatedProj = updatedProject.toProj(); // Proj 객체로 변환
      updatedProj.name = updatedProject.name; // 새로운 이름으로 업데이트
      updatedProj.id = _projects[index].id; // 기존 ID 유지

      await databaseHelper.updateProj(updatedProj); // 데이터베이스 업데이트

      // 프로바이더의 내부 상태 업데이트
      _projects[index] = updatedProject; // 프로바이더의 프로젝트 리스트 업데이트
      notifyListeners(); // UI에 변경 사항 알림
    }
  }



  Future<void> deleteProject(int index) async {
    if (index >= 0 && index < _projects.length) {
      int id = _projects[index].id!;
      await databaseHelper.deleteProj(id); // 데이터베이스에서 삭제
      _projects.removeAt(index); // 프로바이더 상태 업데이트
      notifyListeners(); // 데이터 변경 알림
    }
  }
}
