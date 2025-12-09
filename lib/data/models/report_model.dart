import 'dart:io';

class ReportModel {
  final double x;
  final double y;
  final String date; // yyyy-MM-dd
  final String time; // HH:mm:ss
  final String comment;
  final File? imageFile; // <-- make it nullable in case no image is picked

  // Updated constructor
  ReportModel({
    required this.x,
    required this.y,
    required this.date,
    required this.time,
    required this.comment,
    this.imageFile,
  });

  // Convert to JSON (excluding File, because File cannot be directly sent in JSON)
  Map<String, dynamic> toJson() => {
    'x': x,
    'y': y,
    'date': date,
    'time': time,
    'comment': comment,
  };
}
