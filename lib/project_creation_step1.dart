import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'project_data.dart';

class ProjectCreationStep1 extends StatefulWidget {
  final Function(Project project) onNext;

  ProjectCreationStep1({Key? key, required this.onNext}) : super(key: key);

  @override
  _ProjectCreationStep1State createState() => _ProjectCreationStep1State();
}

class _ProjectCreationStep1State extends State<ProjectCreationStep1> {
  final TextEditingController _nameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Map<String, bool> _monitoringItems = {
    '초장': false,
    '엽수': false,
    '엽장': false,
    '엽폭': false,
    '엽병장': false,
  };

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    // 프로젝트 이름이 입력되었는지 확인
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로젝트 이름을 입력해주세요.')),
      );
      return;
    }

    // Project 객체 생성
    Project newProject = Project(
      name: _nameController.text,
      creationDate: _selectedDate,
      monitoringItems: _monitoringItems,
      measurements: {},
    );

    // 다음 단계로 이동
    widget.onNext(newProject);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('프로젝트 생성 - 단계 1')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: '프로젝트 이름'),
              ),
              ListTile(
                title: Text('생성 날짜: ${DateFormat.yMMMd().format(_selectedDate)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2025),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
              ),
              ..._monitoringItems.keys.map((item) {
                return CheckboxListTile(
                  title: Text(item),
                  value: _monitoringItems[item],
                  onChanged: (bool? value) {
                    setState(() {
                      _monitoringItems[item] = value!;
                    });
                  },
                );
              }).toList(),
              ElevatedButton(
                onPressed: _onNextPressed,
                child: Text('다음'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
