import 'package:equatable/equatable.dart';
import 'package:ticketmaster_app/domain/entities/ticket_entity.dart';

abstract class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object> get props => [];
}

class TicketInitial extends TicketState {}

class TicketLoading extends TicketState {}

class TicketCreatedSuccess extends TicketState {}

class TicketsLoaded extends TicketState {
  final List<Ticket> tickets;

  const TicketsLoaded(this.tickets);

  @override
  List<Object> get props => [tickets];
}

class TicketError extends TicketState {
  final String message;

  const TicketError(this.message);

  @override
  List<Object> get props => [message];
}