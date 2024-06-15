import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_idn_notes_app/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:flutter_idn_notes_app/presentation/auth/login_page.dart';
import 'package:flutter_idn_notes_app/presentation/notes/add_page.dart';
import 'package:flutter_idn_notes_app/presentation/notes/bloc/all_notes/all_notes_bloc.dart';
import 'package:flutter_idn_notes_app/presentation/notes/bloc/delete_note/delete_note_bloc.dart';
import 'package:flutter_idn_notes_app/presentation/notes/detail_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    context.read<AllNotesBloc>().add(GetAllNote());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          // bloc consumer sudah mempunyai parameter listerner dan builder hanya menjalakankan function saja
          BlocConsumer<LogoutBloc, LogoutState>(
            listener: (context, state) {
              if (state is LogoutSuccess) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return const LoginPage();
                }));
              }
              if (state is LogoutFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is LogoutLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return IconButton(
                onPressed: () {
                  context.read<LogoutBloc>().add(LogoutButtonPessed());
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AllNotesBloc, AllNotesState>(
        builder: (context, state) {
          if (state is AllNotesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AllNotesFailed) {
            return const Center(
              child: Text('Failed to load Notes'),
            );
          }
          if (state is AllNotesSuccess) {
            if (state.data.data!.isEmpty) {
              return const Center(
                child: Text('No Notes'),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                final note = state.data.data![index];
                return Card(
                  child: ListTile(
                    title: Text('${note.title}'),
                    subtitle: Text(note.content!.length < 20
                        ? note.content!
                        : note.content!.substring(0, 20)),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BlocConsumer<DeleteNoteBloc, DeleteNoteState>(
                            listener: (context, state) {
                              if (state is DeleteNoteSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Note Deleted Successfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                context.read<AllNotesBloc>().add(GetAllNote());
                              }
                              if (state is DeleteNoteFailed) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is DeleteNoteLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return IconButton(
                                onPressed: () {
                                  context.read<DeleteNoteBloc>().add(
                                      DeleteNoteButtonPressed(id: note.id!));
                                },
                                icon: const Icon(Icons.delete_forever),
                              );
                            },
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DetailPage(note: note);
                              }));
                            },
                            child: const Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                );
              },
              itemCount: state.data.data!.length,
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text('Item $index'),
                  subtitle: Text('This is a subtitle'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
              );
            },
            itemCount: 20,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
