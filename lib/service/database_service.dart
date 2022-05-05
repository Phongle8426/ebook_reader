import 'package:ebook_reader/models/book_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class DatabaseRealTimeService with ChangeNotifier{
  List<PreviewBook> _previewBookList = [];
  List<PreviewBook> get previewBookList {
    return _previewBookList;
  }

  Future<List<PreviewBook>> getAllBook() async{
  DataSnapshot dataSnapshot = await FirebaseDatabase(databaseURL: "https://ebookreader-5bd9b-default-rtdb.asia-southeast1.firebasedatabase.app")
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
  _previewBookList = allBooks;
   notifyListeners();
    return allBooks;
  }

  Future<PreviewBook> getBookById(String idBook) async{
    DataSnapshot dataSnapshot = await FirebaseDatabase(databaseURL: "https://ebookreader-5bd9b-default-rtdb.asia-southeast1.firebasedatabase.app")
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

  PreviewBook findById(String id) {
    print('list : $_previewBookList');
    return _previewBookList.firstWhere((prod) => prod.idBook == id);
  }
}