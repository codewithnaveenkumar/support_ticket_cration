import 'package:equatable/equatable.dart';
import 'package:ticketmaster_app/domain/entities/ticket_entity.dart';

abstract class TicketEvent extends Equatable {
  const TicketEvent();

  @override
  List<Object> get props => [];
}

class CreateTicketEvent extends TicketEvent {
  final Ticket ticket;

  const CreateTicketEvent(this.ticket);

  @override
  List<Object> get props => [ticket];
}

class LoadTicketsEvent extends TicketEvent {
  final String userId;

  const LoadTicketsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}