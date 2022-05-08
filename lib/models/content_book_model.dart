import 'package:flutter/material.dart';

class ContentBook with ChangeNotifier {
  late final String? contentText;
  late final String? contentAudio;

  ContentBook(this.contentText,this.contentAudio);

  ContentBook.emtpy(){
    contentText = '';
    contentAudio = '';
  }
  factory ContentBook.fromRTDB(Map<String, dynamic> data){
    return ContentBook(data['contentText'], data['contentAudio']);
  }

}

