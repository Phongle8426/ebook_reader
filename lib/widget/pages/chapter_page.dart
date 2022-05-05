import 'package:ebook_reader/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/book_data.dart';
import '../../service/database_service.dart';
import '../chapter_book_widget.dart';


class ChapterPage extends StatefulWidget {
  static const routeName = '/ChapterPage';

  @override
  _ChapterPage createState() => _ChapterPage();
}

class _ChapterPage extends State<ChapterPage>{
  List<PreviewBook> _recentBooks = [];
  @override
  void initState() {
    super.initState();
    _getRecentBooks();
  }

  _getRecentBooks() async {
    List<PreviewBook> lisst = await DatabaseRealTimeService().getAllBook();
    setState(() {
      print("boook $lisst");
      _recentBooks = lisst;
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
              //,stops: [0.7,0.9]
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
              child: Text('Ebook Reader',
                  style: GoogleFonts.portLligatSans(
                    textStyle: Theme.of(context).textTheme.headline1,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.black26,
                  )
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                ),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ChapterBook(_recentBooks),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}