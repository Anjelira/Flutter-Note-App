import 'package:flutter/material.dart';
import 'package:flutter_idn_notes_app/data/datasource/auth_local_datasource.dart';
import 'package:flutter_idn_notes_app/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_idn_notes_app/data/datasource/note_remote_datasource.dart';
import 'package:flutter_idn_notes_app/presentation/auth/bloc/login/login_bloc.dart';
import 'package:flutter_idn_notes_app/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:flutter_idn_notes_app/presentation/auth/bloc/register/register_bloc.dart';
import 'package:flutter_idn_notes_app/presentation/auth/bloc/update_note/update_note_bloc.dart';
import 'package:flutter_idn_notes_app/presentation/auth/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_idn_notes_app/presentation/notes/bloc/addNote/add_note_bloc.dart';
import 'package:flutter_idn_notes_app/presentation/notes/bloc/all_notes/all_notes_bloc.dart';
import 'package:flutter_idn_notes_app/presentation/notes/bloc/delete_note/delete_note_bloc.dart';
import 'package:flutter_idn_notes_app/presentation/notes/notes_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => AddNoteBloc(NoteRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => AllNotesBloc(NoteRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => DeleteNoteBloc(NoteRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => UpdateNoteBloc(NoteRemoteDatasource()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(future: AuthLocalDatasource().isLogin(), builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.waiting) {
           return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
           );
         }
         if (snapshot.hasData) {
           return snapshot.data! ? const NotesPage() : const LoginPage();
         } 
         return const Scaffold(
          body: Center(
            child: Text('Error'),
          ),
         );
        }),
      ),
    );
  }
}
