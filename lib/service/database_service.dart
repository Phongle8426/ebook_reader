import 'dart:math';

import 'package:ebook_reader/models/book_model.dart';
import 'package:ebook_reader/models/chapter_book_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import '../models/content_book_model.dart';
import '../models/user_model.dart';

class DatabaseRealTimeService with ChangeNotifier{
  String databaseUrl = "https://ebookreader-5bd9b-default-rtdb.asia-southeast1.firebasedatabase.app";
  List<PreviewBook> _previewBookList = [];
  List<PreviewBook> get previewBookList {
    return _previewBookList;
  }

  Future<List<PreviewBook>> getAllBook() async{
  DataSnapshot dataSnapshot = await FirebaseDatabase(databaseURL: databaseUrl)
      .reference().child("allBooks").once();
   List<PreviewBook> allBooks = [];
   if(dataSnapshot.value != null){
     final data = Map<String, dynamic>.from(dataSnapshot.value);
     print("Data: $data");
     data.forEach((key, value) {
       Map<String, dynamic> newData = Map<String, dynamic>.from(value);
       allBooks.add(PreviewBook.fromRTDB(newData));
     });
   }
    return sortListTrending(allBooks);
  }

  // get all favourite book
  Future<List<PreviewBook>> getAllFavouriteBook(String uid) async{
    DataSnapshot dataSnapshot = await FirebaseDatabase(databaseURL: databaseUrl)
        .reference().child("StoredBook").child(uid).once();
    List<PreviewBook> allBooks = [];
    if(dataSnapshot.value != null){
      final data = Map<String, dynamic>.from(dataSnapshot.value);
      data.forEach((key, value) {
        Map<String, dynamic> newData = Map<String, dynamic>.from(value);
        allBooks.add(PreviewBook.fromRTDB(newData));
      });
    }
    return sortListTrending(allBooks);
  }

  Future<PreviewBook> getBookById(String idBook) async{
    DataSnapshot dataSnapshot = await FirebaseDatabase(databaseURL: databaseUrl)
        .reference().child("allBooks").orderByChild('idBook').equalTo(idBook).once();
    PreviewBook book = PreviewBook.emtpy();
    print("Phong1: $dataSnapshot");
      if(dataSnapshot.value != null){
        final data = Map<String, dynamic>.from(dataSnapshot.value);
        print("Phong2: $data");
        data.forEach((key, value) {
          Map<String, dynamic> newData = Map<String, dynamic>.from(value);
          book = PreviewBook.fromRTDB(newData);
        });
      }
    print("Phong3: $book");
    return book;
  }

  Future<List<PreviewBook>> getBookByType(String type) async{
    DataSnapshot dataSnapshot = await FirebaseDatabase(databaseURL: databaseUrl)
        .reference().child("allBooks").orderByChild('kindOfBook').equalTo(type).once();
    List<PreviewBook> allBooks = [];
    if(dataSnapshot.value != null){
      final data = Map<String, dynamic>.from(dataSnapshot.value);
      print("Data: $data");
      data.forEach((key, value) {
        Map<String, dynamic> newData = Map<String, dynamic>.from(value);
        allBooks.add(PreviewBook.fromRTDB(newData));
      });
    }
    _previewBookList = allBooks;
    notifyListeners();
    return allBooks;
  }

  Future<List<ChapterBook>> getChapterOfBookById(String idBook) async{
    DataSnapshot dataSnapshot = await FirebaseDatabase(databaseURL: databaseUrl)
        .reference().child("ChapterOfBook").child(idBook).once();
    List<ChapterBook> allChapter = [];
    if(dataSnapshot.value != null){
      final data = Map<String, dynamic>.from(dataSnapshot.value);
      print("Data: $data");
      data.forEach((key, value) {
        Map<String, dynamic> newData = Map<String, dynamic>.from(value);
        allChapter.add(ChapterBook.fromRTDB(newData));
      });
    }
    return sortList(allChapter);
  }

  Future<ContentBook> getContentChapter(String idBook,String idChapter) async{
    DataSnapshot dataSnapshot = await FirebaseDatabase(databaseURL: databaseUrl)
        .reference().child("ContentOfBook").child(idBook).child(idChapter).once();
    ContentBook contentChapter = ContentBook.emtpy();
    if(dataSnapshot.value != null){
      final data = Map<String, dynamic>.from(dataSnapshot.value);
      print("Data: $data");
      contentChapter = ContentBook.fromRTDB(data);
    }
    return contentChapter;
  }


  PreviewBook findById(String id) {
    print('list : $_previewBookList');
    return _previewBookList.firstWhere((prod) => prod.idBook == id);
  }

  List<ChapterBook> sortList(List<ChapterBook> list){
    list.sort((a,b){
      return a.numberOfChapter.compareTo(b.numberOfChapter);
    });
    return list;
  }

  List<PreviewBook> sortListTrending(List<PreviewBook> list){
    list.sort((a,b){
      return b.amountOfVisit.compareTo(a.amountOfVisit);
    });
    return list;
  }

  // Profile
  Future<UserInfor> getInforUser(String uid) async{
    DataSnapshot dataSnapshot = await FirebaseDatabase(databaseURL: databaseUrl)
        .reference().child("UserProfile").child(uid).once();
    UserInfor userProfile = UserInfor.emtpy();
    if(dataSnapshot.value != null){
      final data = Map<String, dynamic>.from(dataSnapshot.value);
      print("Data: $data");
      userProfile = UserInfor.fromRTDB(data);
    }
    return userProfile;
  }

  void changeNameUser(String uid, String name){
    FirebaseDatabase(databaseURL: databaseUrl)
        .reference().child("UserProfile").child(uid).child("userName").set(name);
  }

  void addNewUser(String uid, String email){
    String userNameRandom = '#${Random().nextInt(1000000).toString()}';
    FirebaseDatabase(databaseURL: databaseUrl)
        .reference().child("UserProfile").child(uid).set({
      'userName': userNameRandom,
      'email': email
    });
  }

  // Save favourite book
  void addNewFavouriteBook(String uid, PreviewBook book){
    FirebaseDatabase(databaseURL: databaseUrl)
        .reference().child("StoredBook").child(uid).push().set(book.toMap());
  }

  void removeFavouriteBook(String uid, String idBook) async{
    DataSnapshot dataSnapshot = await FirebaseDatabase(databaseURL: databaseUrl)
        .reference().child("StoredBook").child(uid).orderByChild('idBook').equalTo(idBook).once();
    final data = Map<String, dynamic>.from(dataSnapshot.value);
    data.forEach((key, value) {
      FirebaseDatabase(databaseURL: databaseUrl)
          .reference().child("StoredBook").child(uid).child(key).remove();
    });
  }

}