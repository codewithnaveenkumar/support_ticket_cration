import 'package:equatable/equatable.dart';

class Ticket extends Equatable {
  final String id;
  final String title;
  final String description;
  final String location;
  final String date;
  final String attachmentUrl;
  final String userId;

  const Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.attachmentUrl,
    required this.userId
  });

  @override
  List<Object?> get props => [id, title, description, location, date, attachmentUrl,userId];
}