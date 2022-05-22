import 'dart:math';
import 'package:ebook_reader/models/book_model.dart';
import 'package:ebook_reader/models/chapter_book_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import '../models/content_book_model.dart';
import '../models/user_model.dart';

class DatabaseRealTimeService with ChangeNotifier{
  String databaseUrl = "https://ebookreader-5bd9b-default-rtdb.asia-southeast1.firebasedatabase.app";
  String nameUser = "";
  int numberOfChap = 0;
  String nameOfChapter = "";

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

  // check favourite book
  Future<bool> isFavouriteBook(String uid, String idBook) async{
    DataSnapshot dataSnapshot = await FirebaseDatabase(databaseURL: databaseUrl)
        .reference().child("StoredBook").child(uid).orderByChild('idBook').equalTo(idBook).once();
    if(dataSnapshot.value != null) {
      return true;
    }
    return false;
  }

  Future<PreviewBook> getBookById(String idBook) async{
    DataSnapshot dataSnapshot = await FirebaseDatabase(databaseURL: databaseUrl)
        .reference().child("allBooks").orderByChild('idBook').equalTo(idBook).once();
    PreviewBook book = PreviewBook.emtpy();
      if(dataSnapshot.value != null){
        final data = Map<String, dynamic>.from(dataSnapshot.value);
        data.forEach((key, value) {
          Map<String, dynamic> newData = Map<String, dynamic>.from(value);
          book = PreviewBook.fromRTDB(newData);
        });
      }
    return book;
  }

  Future<List<PreviewBook>> getBookByType(String type) async{
    DataSnapshot dataSnapshot = await FirebaseDatabase(databaseURL: databaseUrl)
        .reference().child("allBooks").orderByChild('kindOfBook').equalTo(type).once();
    List<PreviewBook> allBooks = [];
    if(dataSnapshot.value != null){
      final data = Map<String, dynamic>.from(dataSnapshot.value);
      data.forEach((key, value) {
        Map<String, dynamic> newData = Map<String, dynamic>.from(value);
        allBooks.add(PreviewBook.fromRTDB(newData));
      });
    }
    return allBooks;
  }

  Future<List<ChapterBook>> getChapterOfBookById(String idBook) async{
    DataSnapshot dataSnapshot = await FirebaseDatabase(databaseURL: databaseUrl)
        .reference().child("ChapterOfBook").child(idBook).once();
    List<ChapterBook> allChapter = [];
    if(dataSnapshot.value != null){
      final data = Map<String, dynamic>.from(dataSnapshot.value);
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

      DataSnapshot snapshot = await FirebaseDatabase(databaseURL: databaseUrl)
          .reference().child("ChapterOfBook").child(idBook).orderByChild('idChapter').equalTo(idChapter).once();
      ChapterBook chapter = ChapterBook.emtpy();
      if(snapshot.value != null){
        final dataChap = Map<String, dynamic>.from(snapshot.value);
        dataChap.forEach((key, value) {
          Map<String, dynamic> newData = Map<String, dynamic>.from(value);
          chapter = ChapterBook.fromRTDB(newData);
          numberOfChap = chapter.numberOfChapter;
          nameOfChapter = chapter.chapterName;
        });
        notifyListeners();
      }
    }
    return contentChapter;
  }

  Future<String> getAudioChapter(String idBook,String idChapter) async{
    DataSnapshot dataSnapshot = await FirebaseDatabase(databaseURL: databaseUrl)
        .reference().child("ContentOfBook").child(idBook).child(idChapter).child("contentAudio").once();
   String url = "";
    if(dataSnapshot.value != null){
      url = dataSnapshot.value.toString();
    }
    return url;
  }

  Future<String> getAudioChapterByNumberOfChap(String idBook, int number) async{
    DataSnapshot dataSnapshot = await FirebaseDatabase(databaseURL: databaseUrl)
        .reference().child("ContentOfBook").child(idBook).orderByChild('numberOfChapter').equalTo(number).once();
    ContentBook contentChapter = ContentBook.emtpy();
    String url = "";
    if(dataSnapshot.value != null){
      final data = Map<String, dynamic>.from(dataSnapshot.value);
      data.forEach((key, value) {
        Map<String, dynamic> newData = Map<String, dynamic>.from(value);
        contentChapter = ContentBook.fromRTDB(newData);
      });
      url = contentChapter.contentAudio!;
      data.forEach((key, value) async {
        DataSnapshot dataSnapshot = await FirebaseDatabase(databaseURL: databaseUrl)
            .reference().child("ChapterOfBook").child(idBook).orderByChild('idChapter').equalTo(key).once();
        ChapterBook chapter = ChapterBook.emtpy();
        if(dataSnapshot.value != null){
          final data = Map<String, dynamic>.from(dataSnapshot.value);
          data.forEach((key, value) {
            Map<String, dynamic> newData = Map<String, dynamic>.from(value);
            chapter = ChapterBook.fromRTDB(newData);
            numberOfChap = chapter.numberOfChapter;
            nameOfChapter = chapter.chapterName;
          });
          notifyListeners();
        }
      });
    }
    return url;
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
    postUserName(userProfile.userName);
    return userProfile;
  }
  void postUserName(String name){
    print("chay ne 1234567890");
    nameUser = name;
    notifyListeners();
  }

  Future<void> changeNameUser(String uid, String name) async {
    FirebaseDatabase(databaseURL: databaseUrl)
        .reference().child("UserProfile").child(uid).child("userName").set(name);
    postUserName(name);
    notifyListeners();
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

  // Get audio next chapter

}