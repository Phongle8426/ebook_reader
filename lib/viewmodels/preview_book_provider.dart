import 'package:ebook_reader/models/book_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class PreviewBookProvider with ChangeNotifier{
  final _database = FirebaseDatabase.instance.reference();
  final List<PreviewBook> _previewBookRead = [];
  List<Map<String, dynamic>> _previewBookTrend = [];
  List<PreviewBook> get previewBookRead {
    return _previewBookRead;
  }
  void getAllRead() async{
   await _database.onValue.listen((event) {
      print("2");
      final data = Map<String, dynamic>.from(event.snapshot.value);
      print("DATA: $data");
      data.forEach((key, value) {
        Map<String, dynamic> newData = Map<String, dynamic>.from(value);
        _previewBookRead.add(PreviewBook.fromRTDB(newData));
      });
    });
    notifyListeners();
  }
}