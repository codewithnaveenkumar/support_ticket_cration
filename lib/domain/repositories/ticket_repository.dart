import 'package:ticketmaster_app/domain/entities/ticket_entity.dart';

abstract class TicketRepository {
  Future<void> createTicket(Ticket ticket);
  Future<List<Ticket>> getTickets(String userId);
}