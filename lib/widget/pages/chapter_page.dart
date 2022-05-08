import 'package:ebook_reader/models/chapter_book_model.dart';
import 'package:ebook_reader/widget/chapter_book_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../service/database_service.dart';


class ChapterPage extends StatefulWidget {
  static const routeName = '/ChapterPage';

  @override
  _ChapterPage createState() => _ChapterPage();
}

class _ChapterPage extends State<ChapterPage>{
  List<ChapterBook> _chapterBook = [];
  late Map recieverMap = Map();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() {
      recieverMap = ModalRoute.of(context)?.settings.arguments as Map;
      print("recieverMap  $recieverMap");
      _getChapterBooks(recieverMap['idBook']);
    });
  }

  _getChapterBooks(String bookId) async {
    List<ChapterBook> listChapter = await DatabaseRealTimeService().getChapterOfBookById(bookId);
    setState(() {
      print("getChapterOfBookById  $listChapter");
      _chapterBook = listChapter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color.fromRGBO(249, 191, 161, 1), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.center
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 40,
                bottom: 20,
              ),
              child: Text(recieverMap['nameBook'] ?? '',
                  style: GoogleFonts.portLligatSans(
                    textStyle: Theme.of(context).textTheme.headline1,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.black26,
                  )
              ),
            ),
            Icon(
              recieverMap['type'] == 0 ? Icons.book : Icons.headset,
              color: Colors.black,
              size: 50,
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(
                  left: 20,
                ),
                height: double.infinity,
                width: double.infinity,
                child: ChapterBookWidget(_chapterBook,recieverMap['idBook'] ?? '', recieverMap['type'] ?? 0),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}