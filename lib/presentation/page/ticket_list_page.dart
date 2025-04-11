import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:ticketmaster_app/presentation/block/ticket_block.dart';
import 'package:ticketmaster_app/presentation/block/ticket_event.dart';
import 'package:ticketmaster_app/presentation/block/ticket_state.dart';
import 'package:ticketmaster_app/presentation/page/create_ticket_page.dart';
import 'package:ticketmaster_app/presentation/page/ticket_item.dart';

class TicketListPage extends StatefulWidget {
  const TicketListPage({super.key});

  @override
  State<TicketListPage> createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  late Future<String> _userIdFuture;

  @override
  void initState() {
    super.initState();
    _userIdFuture = _initializeUserId();
  }

  Future<String> _initializeUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId == null) {
      userId = const Uuid().v4();
      await prefs.setString('userId', userId);
    }
    context.read<TicketBloc>().add(LoadTicketsEvent(userId));
    return userId;
  }

  Future<void> _refreshTickets() async {
    final userId = await _userIdFuture;
    context.read<TicketBloc>().add(LoadTicketsEvent(userId));
  }

  void _navigateToCreateTicket() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TicketBloc>(),
          child: const CreateTicketPage(),
        ),
      ),
    );
    _refreshTickets();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 400 ? 12.0 : 20.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Tickets',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 4,
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: BlocBuilder<TicketBloc, TicketState>(
          builder: (context, state) {
            if (state is TicketsLoaded) {
              if (state.tickets.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 10),
                      Text(
                        'No tickets yet!',
                        style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap + to create a new ticket',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              final sortedTickets = [...state.tickets];
              sortedTickets.sort(
                (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)),
              );

              return RefreshIndicator(
                onRefresh: _refreshTickets,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: sortedTickets.length,
                  itemBuilder: (context, index) =>
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TicketItem(ticket: sortedTickets[index]),
                      ),
                ),
              );
            } else if (state is TicketError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreateTicket,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Create', style: TextStyle(color: Colors.white)),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }
}
