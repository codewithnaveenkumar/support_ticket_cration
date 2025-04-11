import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketmaster_app/domain/usecase/ticket_usecase.dart';
import 'package:ticketmaster_app/presentation/block/ticket_event.dart';
import 'package:ticketmaster_app/presentation/block/ticket_state.dart';
import 'package:ticketmaster_app/presentation/service/notification_service.dart'; 

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final CreateTicket createTicket;
  final GetTickets getTickets;

  TicketBloc({required this.createTicket, required this.getTickets}) : super(TicketInitial()) {
    on<CreateTicketEvent>(_onCreateTicket);
    on<LoadTicketsEvent>(_onLoadTickets);
  }

  Future<void> _onCreateTicket(CreateTicketEvent event, Emitter<TicketState> emit) async {
    emit(TicketLoading());
    try {
      await createTicket(event.ticket);
      
      Timer(const Duration(minutes: 1), () {
        NotificationService().scheduleNotification(
          title: "Ticket Created",
          body: "Your support ticket has been registered.",
        );
      });
      final tickets = await getTickets(event.ticket.userId);
      emit(TicketsLoaded(tickets));
    } catch (e) {
      emit(TicketError(e.toString()));
    }
  }

  Future<void> _onLoadTickets(LoadTicketsEvent event, Emitter<TicketState> emit) async {
    emit(TicketLoading());
    try {
      final tickets = await getTickets(event.userId);
      emit(TicketsLoaded(tickets));
    } catch (e) {
      emit(TicketError(e.toString()));
    }
  }
}
