import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketmaster_app/data/models/ticket_model.dart';

abstract class TicketRemoteDataSource {
  Future<void> createTicket(TicketModel ticket);
  Future<List<TicketModel>> getTickets(String userId);
}

class TicketRemoteDataSourceImpl implements TicketRemoteDataSource {
  final FirebaseFirestore firestore;

  TicketRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> createTicket(TicketModel ticket) async {
    await firestore.collection('tickets').doc(ticket.id).set(ticket.toJson());
  }

  @override
  Future<List<TicketModel>> getTickets(String userId) async {
    final snapshot = await firestore
        .collection('tickets')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => TicketModel.fromJson(doc.data())).toList();
  }
}