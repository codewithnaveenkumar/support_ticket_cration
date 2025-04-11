import 'package:ticketmaster_app/domain/entities/ticket_entity.dart';
import 'package:ticketmaster_app/domain/repositories/ticket_repository.dart';

class CreateTicket {
  final TicketRepository repository;

  CreateTicket(this.repository);

  Future<void> call(Ticket ticket) async {
    return await repository.createTicket(ticket);
  }
}

class GetTickets {
  final TicketRepository repository;

  GetTickets(this.repository);

  Future<List<Ticket>> call(String userId) async {
    return await repository.getTickets(userId);
  }
}