import 'package:flutter/material.dart';

class JobDetailsScreen extends StatefulWidget {
  final String uploadedBy;
  final String taskId;

  const JobDetailsScreen({required this.uploadedBy, required this.taskId});
  @override
  _JobDetailsScreenState createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
