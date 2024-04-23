import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'project_data.dart';

class ProjectCreationStep2 extends StatefulWidget {
  final Project project;
  final Function(Project project) onNext;
  final VoidCallback onPrevious;

  ProjectCreationStep2({
    Key? key,
    required this.project,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  _ProjectCreationStep2State createState() => _ProjectCreationStep2State();
}

class _ProjectCreationStep2State extends State<ProjectCreationStep2> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        // imageUrl 필드를 사용하여 이미지 경로 저장
        widget.project.imageUrl = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('이미지 선택')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // imageUrl 필드를 사용하여 이미지 표시
            if (widget.project.imageUrl != null)
              Image.file(File(widget.project.imageUrl!), height: 200),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('갤러리에서 이미지 선택'),
            ),
            ElevatedButton(
              onPressed: widget.onPrevious,
              child: Text('이전 단계'),
            ),
            ElevatedButton(
              onPressed: () => widget.onNext(widget.project),
              child: Text('다음 단계'),
            ),
          ],
        ),
      ),
    );
  }
}
