import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChapterBook {
  late final String idChapter;
  late final String chapterName;
  late final int numberOfChapter;

  ChapterBook(this.idChapter,this.chapterName,this.numberOfChapter);

  ChapterBook.emtpy(){
    chapterName = '';
    numberOfChapter = 0;
  }
  factory ChapterBook.fromRTDB(Map<String, dynamic> data){
    return ChapterBook(data['idChapter'], data['chapterName'], data['numberOfChapter']);
  }

}

