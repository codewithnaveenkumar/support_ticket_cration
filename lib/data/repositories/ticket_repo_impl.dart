import 'package:ticketmaster_app/data/datasource/ticket_remote_data_source.dart';
import 'package:ticketmaster_app/domain/entities/ticket_entity.dart';
import 'package:ticketmaster_app/domain/repositories/ticket_repository.dart';
import 'package:ticketmaster_app/data/models/ticket_model.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketRemoteDataSource remoteDataSource;

  TicketRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createTicket(Ticket ticket) async {
    final ticketModel = TicketModel(
      id: ticket.id,
      title: ticket.title,
      description: ticket.description,
      location: ticket.location,
      date: ticket.date,
      attachmentUrl: ticket.attachmentUrl,
      userId: ticket.userId,
    );
    await remoteDataSource.createTicket(ticketModel);
  }

  @override
  Future<List<Ticket>> getTickets(String userId) async {
    final ticketModels = await remoteDataSource.getTickets(userId);

    return ticketModels.map((model) => Ticket(
      id: model.id ?? "",
      title: model.title ?? "",
      description: model.description ?? "",
      location: model.location ?? "",
      date: model.date ?? "",
      attachmentUrl: model.attachmentUrl ?? "",
      userId: model.userId ?? "",
    )).toList();
  }
}