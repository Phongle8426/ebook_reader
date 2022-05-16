import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/content_book_model.dart';
import '../../service/database_service.dart';
import '../chapter_book_widget.dart';

class ReadingPage extends StatefulWidget {
  static const routeName = '/ReadingPage';
  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  late Map recieverMap = Map();
  String content = "";
  String nameOfChapter = "";
  double fontSizeText = 13;
  bool darkMode = false;
  @override
  void initState() {
    Future.delayed(Duration.zero,() {
      recieverMap = ModalRoute.of(context)?.settings.arguments as Map;
      print("recieverMap  $recieverMap");
      nameOfChapter = "Chương ${recieverMap['numberOfChapter']} :  ${recieverMap['chapterName']}";
      _getContentChapter(recieverMap['idBook'], recieverMap['idChapter']);
    });
    super.initState();
  }

  _getContentChapter(String idBook, String idChapter) async{
    ContentBook contentBook = await DatabaseRealTimeService().getContentChapter(idBook, idChapter);
    setState(() {
      content = contentBook.contentText!;
    });
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: darkMode ? Colors.black87 : Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                  height: size.height * 0.085,
                  width: size.width,
                  //color: Colors.red,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: EdgeInsets.all(constraints.maxHeight * 0.18),
                              //color: Colors.black,
                              height: constraints.maxHeight * 0.8,
                              width: constraints.maxWidth * 0.15,
                              child: FittedBox(
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Color.fromRGBO(66, 66, 86, 1),
                                  )),
                            ),
                          ),
                          Container(
                            //color: Colors.red,
                            height: constraints.maxHeight * 0.85,
                            width: constraints.maxWidth * 0.51,
                            child: Container(
                                  height: constraints.maxHeight * 0.85 * 0.7,
                                  width: constraints.maxWidth * 0.35,
                                  child: FittedBox(
                                      child: Text(
                                        nameOfChapter ??'',
                                        style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(66, 66, 86, 1),
                                            )),
                                      )
                                  ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(constraints.maxHeight * 0.18),
                            //color: Colors.black,
                            height: constraints.maxHeight * 0.8,
                            width: constraints.maxWidth * 0.15,
                            child: FittedBox(
                                child: Icon(
                                  Icons.share,
                                  color: Color.fromRGBO(66, 66, 86, 1),
                                ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              Container(
                    padding: EdgeInsets.only(top: size.height * 0.01, left: size.height * 0.01, right: size.height * 0.01),
                    //color: Colors.red,
                    height: size.height * 0.76,
                    width: size.width,
                    child: SingleChildScrollView(
                      child: Center(
                          child: Text(
                            content,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: darkMode ? Colors.grey : Color.fromRGBO(101, 101, 101, 1),
                                  fontSize: fontSizeText
                                )),
                          ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Container(
                  //color: Colors.amber,
                  height: size.height * 0.1,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Material(
                            borderRadius:
                            BorderRadius.circular(constraints.maxHeight * 0.45),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  fontSizeText = fontSizeText - 2;
                                });
                              },
                              borderRadius: BorderRadius.circular(
                                  constraints.maxHeight * 0.45 / 2),
                              //splashColor: Colors.grey,
                              child: Container(
                                height: constraints.maxHeight * 0.45,
                                width: constraints.maxWidth * 0.9 / 5,
                                //color: Colors.white,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        constraints.maxHeight * 0.45 / 2)),
                                child: FittedBox(
                                    child: Icon(
                                      Icons.text_rotation_angledown,
                                      color: Color.fromRGBO(69, 69, 88, 1),
                                    )),
                              ),
                            ),
                          ),
                          Material(
                            borderRadius:
                            BorderRadius.circular(constraints.maxHeight * 0.45),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  fontSizeText = fontSizeText + 2;
                                });
                              },
                              borderRadius: BorderRadius.circular(
                                  constraints.maxHeight * 0.45 / 2),
                              //splashColor: Colors.grey,
                              child: Container(
                                height: constraints.maxHeight * 0.45,
                                width: constraints.maxWidth * 0.9 / 5,
                                //color: Colors.white,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        constraints.maxHeight * 0.45 / 2)),
                                child: FittedBox(
                                    child: Icon(
                                      Icons.text_rotation_angleup,
                                      color: Color.fromRGBO(69, 69, 88, 1),
                                    )),
                              ),
                            ),
                          ),
                          Material(
                            borderRadius:
                            BorderRadius.circular(constraints.maxHeight * 0.45),
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    context: context,
                                    builder: (BuildContext context){
                                      return SizedBox(
                                        height: 250,
                                        child: Container(
                                          padding: EdgeInsets.only(left: 10, top: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              FittedBox(
                                                  child: Text(
                                                   'Danh sách chương',
                                                    style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Color.fromRGBO(66, 66, 86, 1),
                                                        )),
                                                  )
                                              ),
                                              SizedBox(height: 5,),
                                              ChapterBookWidget(recieverMap['listChapter'],recieverMap['idBook'], 0)
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              borderRadius: BorderRadius.circular(
                                  constraints.maxHeight * 0.45 / 2),
                              child: Container(
                                height: constraints.maxHeight * 0.45,
                                width: constraints.maxWidth * 0.9 / 5,
                                //color: Colors.white,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        constraints.maxHeight * 0.45 / 2)),
                                child: FittedBox(
                                    child: Icon(
                                      Icons.list,
                                      color: Color.fromRGBO(69, 69, 88, 1),
                                    )),
                              ),
                            ),
                          ),
                          Material(
                            borderRadius:
                            BorderRadius.circular(constraints.maxHeight * 0.45),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  darkMode = !darkMode;
                                });
                              },
                              borderRadius: BorderRadius.circular(
                                  constraints.maxHeight * 0.45 / 2),
                              //splashColor: Colors.grey,
                              child: Container(
                                height: constraints.maxHeight * 0.45,
                                width: constraints.maxWidth * 0.9 / 5,
                                //color: Colors.white,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        constraints.maxHeight * 0.45 / 2)),
                                child: FittedBox(
                                    child: Icon(
                                      Icons.brightness_3,
                                      color: darkMode ? Colors.black87 : Color.fromRGBO(191, 191, 191, 1),
                                    )),
                              ),
                            ),
                          ),
                          Material(
                            borderRadius:
                            BorderRadius.circular(constraints.maxHeight * 0.45),
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(
                                  constraints.maxHeight * 0.45 / 2),
                              //splashColor: Colors.grey,
                              child: Container(
                                height: constraints.maxHeight * 0.45,
                                width: constraints.maxWidth * 0.9 / 5,
                                //color: Colors.white,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        constraints.maxHeight * 0.45 / 2)),
                                child: FittedBox(
                                    child: Icon(
                                      Icons.headset,
                                      color: Color.fromRGBO(191, 191, 191, 1),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          )),
    );
  }
}
