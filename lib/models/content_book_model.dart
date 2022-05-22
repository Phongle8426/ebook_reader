import 'package:flutter/material.dart';

class ContentBook{
  late final int? numberOfChapter;
  late final String? contentText;
  late final String? contentAudio;

  ContentBook(this.numberOfChapter,this.contentText,this.contentAudio);

  ContentBook.emtpy(){
    numberOfChapter = 0;
    contentText = '';
    contentAudio = '';
  }
  factory ContentBook.fromRTDB(Map<String, dynamic> data){
    return ContentBook(data['numberOfChapter'],data['contentText'], data['contentAudio']);
  }

  @override
  String toString() {
    return 'ContentBook{numberOfChapter: $numberOfChapter, contentText: $contentText, contentAudio: $contentAudio}';
  }
}

