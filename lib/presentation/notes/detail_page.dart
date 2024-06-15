// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_idn_notes_app/data/datasource/config.dart';

import 'package:flutter_idn_notes_app/data/models/response/note_response_model.dart';
import 'package:flutter_idn_notes_app/presentation/notes/edit_page.dart';

class DetailPage extends StatelessWidget {
  final Note note;
  const DetailPage({
    Key? key,
    required this.note,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title!,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.content!,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 16,
            ),
            if (note.image != null)
              Image.network(
                '${Config.baseUrl}/images/${note.image!}',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            SizedBox(
              height: 16,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return EditPage(note: note);
                    }));
                  },
                  child: const Text('Edit')),
            )
          ],
        ),
      ),
    );
  }
}
