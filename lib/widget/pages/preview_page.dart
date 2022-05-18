import 'dart:collection';

import 'package:ebook_reader/models/data_demo.dart';
import 'package:ebook_reader/widget/loading_widget.dart';
import 'package:ebook_reader/widget/pages/chapter_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/book_model.dart';
import '../../service/database_service.dart';

class PreviewPage extends StatefulWidget {
  static const routeName = '/PreviewPage';

  const PreviewPage({Key? key}) : super(key: key);

  @override
  _PreviewPage createState() => _PreviewPage();
}

class _PreviewPage extends State<PreviewPage>{
  PreviewBook _book = PreviewBook.emtpy();
  String? bookId = '';
  String? uid ='';
  bool loading = true;
  bool isMark = false;
  @override
  void initState() {
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
    uid  = auth.currentUser?.uid;
    Future.delayed(Duration.zero,() {
      print("Chay ne 123");
      bookId = ModalRoute.of(context)?.settings.arguments.toString();
      _getBooks(bookId!);
    });
  }
  _getBooks(String id) async{
    print("Chay ne");
   PreviewBook book = await DatabaseRealTimeService().getBookById(id);
     setState(() {
       _book = book;
       loading = false;
     });
  }

  void _setBookMark(){
    setState(() {
      isMark = !isMark;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: loading ? Loading() : SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color.fromRGBO(249, 191, 161, 1), Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.center
                    //,stops: [0.7,0.9]
                  ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                    height: size.height * 0.085,
                    width: size.width,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              color: Colors.white.withOpacity(0),
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                borderRadius: BorderRadius.circular(
                                    constraints.maxHeight * 0.4),
                                splashColor: Colors.white,
                                child: Container(
                                  padding:
                                  EdgeInsets.all(constraints.maxHeight * 0.18),
                                  //color: Colors.black,
                                  height: constraints.maxHeight * 0.8,
                                  width: constraints.maxWidth * 0.15,
                                  child: FittedBox(
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.54,
                            ),
                            Material(
                              color: Colors.white.withOpacity(0),
                              child: InkWell(
                                onTap: () => {
                                  if(isMark)
                                    DatabaseRealTimeService().removeFavouriteBook(uid!, _book.idBook)
                                  else
                                    DatabaseRealTimeService().addNewFavouriteBook(uid!, _book),
                                  _setBookMark()
                                },
                                borderRadius: BorderRadius.circular(
                                    constraints.maxHeight * 0.4),
                                splashColor: Colors.white,
                                child: Container(
                                  padding:
                                  EdgeInsets.all(constraints.maxHeight * 0.18),
                                  height: constraints.maxHeight * 0.8,
                                  width: constraints.maxWidth * 0.15,
                                  child: FittedBox(
                                      child: Icon(
                                        isMark ? Icons.bookmark : Icons.bookmark_border,
                                        color: isMark ? Color(0xFFFF7643) : Colors.white,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Container(
                    width: size.width * 0.4,
                    height: size.height * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 5,
                          offset: Offset(8, 8),
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                          _book.coverImage,
                        loadingBuilder: (context, child, loadingProgress) => loadingProgress == null
                            ? child
                            : Container(
                          height: size.height * 0.3,
                          width: size.width * 0.4,
                          child: Center(child: CircularProgressIndicator(),),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.33),
                    height: size.height * 0.06,
                    width: size.width,
                    //color: Colors.red,
                    child: FittedBox(
                        child: Text(
                          _book.name,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(66, 66, 86, 1)),
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.1),
                    height: size.height * 0.03,
                    width: size.width,
                    child: FittedBox(
                        child: Text(
                          _book.author,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(142, 142, 154, 1)),
                        )),
                  ),
                  // Hàng thông tin 1
                  Container(
                    height: size.height * 0.07,
                    width: size.width,
                    //color: Colors.red,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  //color: Colors.purple,
                                  width: constraints.maxWidth * 0.27,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(
                                                constraints.maxHeight * 0.1),
                                            //color: Colors.grey,
                                            height: constraints.maxHeight * 0.6,
                                            width: constraints.maxWidth,
                                            child: FittedBox(
                                                child: Text(
                                                  "20/10/22",
                                                  style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          color: Color.fromRGBO(66, 66, 86, 1)
                                                              .withOpacity(0.9),
                                                          fontWeight: FontWeight.bold),
                                                      fontSize: 10),
                                                )),
                                          ),
                                          Container(
                                            //color: Colors.pink,
                                            height: constraints.maxHeight * 0.4,
                                            width: constraints.maxWidth,
                                            child: const FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  "Ngày phát hành",
                                                  style: TextStyle(
                                                          fontSize: 20,
                                                          color: Color.fromRGBO(
                                                              142, 142, 154, 1),
                                                          fontWeight: FontWeight.w300),
                                                )),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  color: Color.fromRGBO(203, 201, 208, 1),
                                  width: constraints.maxWidth * 0.0031,
                                  height: constraints.maxHeight,
                                ),
                                Container(
                                  //color: Colors.purple,
                                  width: constraints.maxWidth * 0.27,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(
                                                constraints.maxHeight * 0.1),
                                            //color: Colors.grey,
                                            height: constraints.maxHeight * 0.6,
                                            width: constraints.maxWidth,
                                            child: FittedBox(
                                                child: Text(
                                                  _book.mountChapter.toString(),
                                                  style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          color: Color.fromRGBO(66, 66, 86, 1)
                                                              .withOpacity(0.9),
                                                          fontWeight: FontWeight.bold)),
                                                )),
                                          ),
                                          Container(
                                            //color: Colors.pink,
                                            height: constraints.maxHeight * 0.4,
                                            width: constraints.maxWidth,
                                            child: const FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  "Số chương",
                                                  style: TextStyle(
                                                          fontSize: 20,
                                                          color: Color.fromRGBO(
                                                              142, 142, 154, 1),
                                                          fontWeight: FontWeight.w300)),
                                                ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  color: Color.fromRGBO(203, 201, 208, 1),
                                  width: constraints.maxWidth * 0.0031,
                                  height: constraints.maxHeight,
                                ),
                                Container(
                                  //color: Colors.purple,
                                  width: constraints.maxWidth * 0.27,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(
                                                constraints.maxHeight * 0.1),
                                            //color: Colors.grey,
                                            height: constraints.maxHeight * 0.6,
                                            width: constraints.maxWidth,
                                            child: FittedBox(
                                                child: Text(
                                                  _book.amountOfVisit.toString(),
                                                  style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          color: Color.fromRGBO(66, 66, 86, 1)
                                                              .withOpacity(0.9),
                                                          fontWeight: FontWeight.bold)),
                                                )),
                                          ),
                                          Container(
                                            //color: Colors.pink,
                                            height: constraints.maxHeight * 0.4,
                                            width: constraints.maxWidth,
                                            child: const FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  "Người đọc",
                                                  style: TextStyle(
                                                          fontSize: 20,
                                                          color: Color.fromRGBO(
                                                              142, 142, 154, 1),
                                                          fontWeight: FontWeight.w300)),
                                                ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8,),
                  // Hàng thông tin 2
                  Container(
                    height: size.height * 0.07,
                    width: size.width,
                    //color: Colors.red,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              //color: Colors.purple,
                              width: constraints.maxWidth * 0.27,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(
                                            constraints.maxHeight * 0.1),
                                        //color: Colors.grey,
                                        height: constraints.maxHeight * 0.6,
                                        width: constraints.maxWidth,
                                        child: FittedBox(
                                            child: Text(
                                              _book.kindOfBook,
                                              style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      color: Color.fromRGBO(66, 66, 86, 1)
                                                          .withOpacity(0.9),
                                                      fontWeight: FontWeight.bold)),
                                            )),
                                      ),
                                      Container(
                                        //color: Colors.pink,
                                        height: constraints.maxHeight * 0.4,
                                        width: constraints.maxWidth,
                                        child: const FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              "Thể loại",
                                              style: TextStyle(
                                                      fontSize: 20,
                                                      color: Color.fromRGBO(
                                                          142, 142, 154, 1),
                                                      fontWeight: FontWeight.w300)),
                                            ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Container(
                              color: Color.fromRGBO(203, 201, 208, 1),
                              width: constraints.maxWidth * 0.0031,
                              height: constraints.maxHeight,
                            ),
                            Container(
                              //color: Colors.purple,
                              width: constraints.maxWidth * 0.27,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: constraints.maxHeight * 0.1),
                                        //color: Colors.grey,
                                        height: constraints.maxHeight * 0.6,
                                        width: constraints.maxWidth,
                                        child: FittedBox(
                                            child: Text(
                                              _book.status,
                                              style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      color: Color.fromRGBO(66, 66, 86, 1)
                                                          .withOpacity(0.9),
                                                      fontWeight: FontWeight.bold)),
                                            )),
                                      ),
                                      Container(
                                        //color: Colors.pink,
                                        height: constraints.maxHeight * 0.4,
                                        width: constraints.maxWidth,
                                        child: const FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              "Trạng thái",
                                              style: TextStyle(
                                                      fontSize: 20,
                                                      color: Color.fromRGBO(
                                                          142, 142, 154, 1),
                                                      fontWeight: FontWeight.w300)),
                                            ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Container(
                    //color: Colors.red,
                    height: size.height * 0.04,
                    width: size.width,
                    child: FittedBox(
                        child: Text(
                          "Mô tả",
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(66, 66, 86, 1),
                              )),
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.all(size.height * 0.01),
                    //color: Colors.red,
                    height: size.height * 0.17,
                    width: size.width,
                    child: Center(
                        child: Text(
                          DataDemo.textDemo,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Color.fromRGBO(66, 66, 86, 1),
                              ),
                        )),
                  ),
                  Container(
                    //padding: EdgeInsets.all(size.height * 0.01),
                    //color: Colors.red,
                      height: size.height * 0.071,
                      width: size.width,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      ChapterPage.routeName,
                                      arguments: {'idBook': _book.idBook, 'nameBook': _book.name, 'type': 0},
                                  );
                                },
                                child: Container(
                                  //padding: EdgeInsets.all(constraints.maxHeight * 0.15),
                                  height: constraints.maxHeight * 0.7,
                                  width: constraints.maxWidth * 0.35,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            //color: Colors.red,
                                            height: constraints.maxHeight * 0.6,
                                            width: constraints.maxWidth * 0.2,
                                            child: FittedBox(
                                                child: Icon(
                                                  Icons.book,
                                                  color: Colors.white,
                                                )),
                                          ),
                                          Container(
                                            //color: Colors.purple,
                                            height: constraints.maxHeight * 0.6,
                                            width: constraints.maxWidth * 0.45,
                                            child: FittedBox(
                                              child: Text("Đọc",
                                                  style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.white))),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(66, 66, 86, 1),
                                      borderRadius: BorderRadius.circular(
                                          constraints.maxWidth * 0.03)),
                                ),
                              ),
                              Container(
                                //padding: EdgeInsets.all(constraints.maxHeight * 0.15),
                                height: constraints.maxHeight * 0.7,
                                width: constraints.maxWidth * 0.35,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          //color: Colors.red,
                                          height: constraints.maxHeight * 0.6,
                                          width: constraints.maxWidth * 0.2,
                                          child: FittedBox(
                                              child: Icon(
                                                Icons.headset,
                                                color: Colors.white,
                                              )),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            Navigator.of(context).pushNamed(
                                              ChapterPage.routeName,
                                              arguments: {'idBook': _book.idBook, 'nameBook': _book.name, 'type': 1},);
                                          },
                                          child: Container(
                                            //color: Colors.purple,
                                            height: constraints.maxHeight * 0.6,
                                            width: constraints.maxWidth * 0.45,
                                            child: FittedBox(
                                              child: Text("Nghe",
                                                  style: GoogleFonts.lato(
                                                      textStyle: TextStyle(
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.white))),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(66, 66, 86, 1),
                                    borderRadius: BorderRadius.circular(
                                        constraints.maxWidth * 0.03)),
                              ),
                            ],
                          );
                        },
                      ))
                ],
              ),
            ),
          )),
    );
  }

}
