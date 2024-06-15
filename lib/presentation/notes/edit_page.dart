// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_idn_notes_app/data/models/response/note_response_model.dart';
import 'package:flutter_idn_notes_app/presentation/auth/bloc/update_note/update_note_bloc.dart';
import 'package:flutter_idn_notes_app/presentation/notes/notes_page.dart';

class EditPage extends StatefulWidget {
  final Note note;
  const EditPage({
    super.key,
    required this.note,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool isPin = false;

  void isPinHandler(bool value) {
    setState(() {
      isPin = value;
    });
  }

  @override
  void initState() {
    _titleController.text = widget.note.title!;
    _contentController.text = widget.note.content!;
    isPin = widget.note.isPin! == '1' ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Page',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Tittle'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Content'),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Pinned'),
                const SizedBox(
                  width: 16,
                ),
                Switch(
                  value: isPin,
                  onChanged: isPinHandler,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: BlocConsumer<UpdateNoteBloc, UpdateNoteState>(
              listener: (context, state) {
                if (state is UpdateNoteSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Update Success'),
                    backgroundColor: Colors.green,
                  ));
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const NotesPage();
                  }));
                }
                if (state is UpdateNoteFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is UpdateNoteLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ElevatedButton(
                  onPressed: () {
                    context.read<UpdateNoteBloc>().add(
                          UpdateNoteButtonPressed(
                            id: widget.note.id!,
                            title: _titleController.text,
                            content: _contentController.text,
                            isPin: isPin,
                          ),
                        );
                  },
                  child: const Text('Update'),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
