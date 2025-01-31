import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_idn_notes_app/data/datasource/auth_local_datasource.dart';
import 'package:flutter_idn_notes_app/data/datasource/config.dart';
import 'package:flutter_idn_notes_app/data/models/response/all_notes_response_model.dart';
import 'package:flutter_idn_notes_app/data/models/response/note_response_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class NoteRemoteDatasource {
  Future<Either<String, NoteResponseModel>> addNote(
    String title,
    String content,
    bool isPin,
    XFile? image,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${authData.accessToken}'
    };

    var request =
        http.MultipartRequest('POST', Uri.parse('${Config.baseUrl}/api/notes'));

    request.headers.addAll(headers);
    request.fields['title'] = title;
    request.fields['content'] = content;
    request.fields['is_pin'] = isPin ? '1' : '0';

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
        ),
      );
    }

    http.StreamedResponse response = await request.send();

    final String body = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return Right(NoteResponseModel.fromJson(body));
    } else {
      return Left(body);
    }
  }

  // get all notes
  Future<Either<String, AllNoteResponseModel>> getAllNotes() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse('${Config.baseUrl}/api/notes'),
      headers: {
        'Authorization': 'Bearer ${authData.accessToken}',
        'Content-Type': 'application/json'
      }
    );

    if (response.statusCode == 200) {
      final data = AllNoteResponseModel.fromJson(response.body);
      return Right(data);
    } else {
      return Left(response.body);
    }
  }

  // delete
  Future<Either<String, String>> deleteNotes(int id) async {
   final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.delete(
      Uri.parse('${Config.baseUrl}/api/notes/$id'),
      headers: {
        'Authorization': 'Bearer ${authData.accessToken}',
        'Content-Type': 'application/json'
      }
    );

     if (response.statusCode == 200) {
      return const Right('Delete Success');
    } else {
      return Left(response.body);
    }

  }

  // update
  Future<Either<String, NoteResponseModel>> updateNote(
    int id,
    String title,
    String content,
    bool isPin
  ) async{
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.put(
      Uri.parse('${Config.baseUrl}/api/notes/$id'),
      headers: {
        'Authorization': 'Bearer ${authData.accessToken}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'title': title,
        'content' : content,
        'is_pin' : isPin ? '1' : '0'
      })
    );

     if (response.statusCode == 200) {
      return Right(NoteResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }
}
