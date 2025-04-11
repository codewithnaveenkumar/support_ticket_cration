import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster_app/data/datasource/ticket_remote_data_source.dart';
import 'package:ticketmaster_app/data/repositories/ticket_repo_impl.dart';
import 'package:ticketmaster_app/domain/usecase/ticket_usecase.dart';
import 'package:ticketmaster_app/presentation/block/ticket_block.dart';
import 'package:ticketmaster_app/presentation/block/ticket_event.dart';
import 'package:ticketmaster_app/presentation/page/ticket_list_page.dart';
import 'package:ticketmaster_app/presentation/service/notification_service.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
     await NotificationService().init();
    final userId = await getOrCreateUserId();

    runApp(App(userId: userId));
  } catch (e) {
    runApp(const ErrorApp());
  }
}

Future<String> getOrCreateUserId() async {
  final prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  if (userId == null) {
    userId = const Uuid().v4();
    await prefs.setString('userId', userId);
  }
  return userId;
}

class App extends StatelessWidget {
  final String userId;

  const App({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final remoteDataSource = TicketRemoteDataSourceImpl(firestore: firestore);
    final repository = TicketRepositoryImpl(remoteDataSource: remoteDataSource);

    final createTicket = CreateTicket(repository);
    final getTickets = GetTickets(repository);

    return MultiBlocProvider(
      providers: [
        BlocProvider<TicketBloc>(
          create: (_) => TicketBloc(
            createTicket: createTicket,
            getTickets: getTickets,
          )..add(LoadTicketsEvent(userId)),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticket Master',
      debugShowCheckedModeBanner: false,
      home: const TicketListPage(),
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Failed to initialize Firebase or SharedPrefs'),
        ),
      ),
    );
  }
}
