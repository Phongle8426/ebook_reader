import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PreviewBook with ChangeNotifier {
  late final String idBook;
  late final String name;
  late final String author;
  late final String coverImage;
  late final int mountChapter;
  late final String status;
  late final String kindOfBook ;
  late final int amountOfVisit;

  PreviewBook(this.idBook,this.name, this.author, this.coverImage,
     this.mountChapter, this.status, this.kindOfBook, this.amountOfVisit);

  PreviewBook.emtpy(){
     idBook = '';
     name = '';
     author = '';
     coverImage = '';
     mountChapter = 0;
     status = '';
     kindOfBook = '';
     amountOfVisit = 0;
  }
  factory PreviewBook.fromRTDB(Map<String, dynamic> data){
    return PreviewBook(data['idBook'],data['name'],data['author'],data['coverImage'],data['mountChapter'],
        data['status'],data['kindOfBook'],data['amountOfVisit']);
  }

  Map<String,dynamic> toMap(){
    return {
      "idBook":idBook,
      "name":name,
      "author":author,
      "coverImage":coverImage,
      "mountChapter": mountChapter,
      "status": status,
      "kindOfBook": kindOfBook,
      "amountOfVisit": amountOfVisit
    };
  }

}

