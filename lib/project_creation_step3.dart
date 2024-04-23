import 'package:flutter/material.dart';
import 'project_data.dart';

class ProjectCreationStep3 extends StatefulWidget {
  final Project project;
  final VoidCallback onPrevious;
  final VoidCallback onComplete;

  ProjectCreationStep3({
    Key? key,
    required this.project,
    required this.onPrevious,
    required this.onComplete,
  }) : super(key: key);

  @override
  _ProjectCreationStep3State createState() => _ProjectCreationStep3State();
}

class _ProjectCreationStep3State extends State<ProjectCreationStep3> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    widget.project.monitoringItems.forEach((key, selected) {
      if (selected) {
        _controllers[key] = TextEditingController();
      }
    });
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _onCompletePressed() {
    Map<String, double> measurements = {};
    _controllers.forEach((key, controller) {
      double? value = double.tryParse(controller.text);
      if (value != null) {
        measurements[key] = value;
      }
    });

    widget.project.measurements = measurements;
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('측정값 입력')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._controllers.entries.map((entry) {
                return TextField(
                  controller: entry.value,
                  decoration: InputDecoration(labelText: '${entry.key} 측정값'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                );
              }).toList(),
              ElevatedButton(
                onPressed: _onCompletePressed,
                child: Text('완료'),
              ),
              ElevatedButton(
                onPressed: widget.onPrevious,
                child: Text('이전 단계'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
