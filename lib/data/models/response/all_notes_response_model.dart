import 'dart:convert';

import 'package:flutter_idn_notes_app/data/models/response/note_response_model.dart';

class AllNoteResponseModel {
    final String? message;
    final List<Note>? data;

    AllNoteResponseModel({
        this.message,
        this.data,
    });

    factory AllNoteResponseModel.fromJson(String str) => AllNoteResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AllNoteResponseModel.fromMap(Map<String, dynamic> json) => AllNoteResponseModel(
        message: json["message"],
        data: json["data"] == null ? [] : List<Note>.from(json["data"]!.map((x) => Note.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

