import 'package:ebook_reader/models/book_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class PreviewBookProvider with ChangeNotifier{
 String name = "123";
 void setName(String namena){
   name = namena;
   notifyListeners();
 }
}