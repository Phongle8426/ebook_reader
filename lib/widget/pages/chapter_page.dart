import 'package:ebook_reader/models/chapter_book_model.dart';
import 'package:ebook_reader/widget/chapter_book_widget.dart';
import 'package:ebook_reader/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../service/database_service.dart';

class ChapterPage extends StatefulWidget {
  static const routeName = '/ChapterPage';

  @override
  _ChapterPage createState() => _ChapterPage();
}

class _ChapterPage extends State<ChapterPage> {
  List<ChapterBook> _chapterBook = [];
  bool loading = true;
  late Map recieverMap = Map();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      recieverMap = ModalRoute.of(context)?.settings.arguments as Map;
      _getChapterBooks(recieverMap['idBook']);
    });
  }

  _getChapterBooks(String bookId) async {
    List<ChapterBook> listChapter =
        await DatabaseRealTimeService().getChapterOfBookById(bookId);
    setState(() {
      print("getChapterOfBookById  $listChapter");
      _chapterBook = listChapter;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: loading
          ? Loading()
          : Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color.fromRGBO(249, 191, 161, 1), Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.center)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.01),
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
                                  padding: EdgeInsets.all(
                                      constraints.maxHeight * 0.18),
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
                            Text(recieverMap['nameBook'] ?? '',
                                style: GoogleFonts.portLligatSans(
                                  textStyle:
                                      Theme.of(context).textTheme.headline1,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                )),
                            Container(
                              padding:
                                  EdgeInsets.all(constraints.maxHeight * 0.18),
                              height: constraints.maxHeight * 0.8,
                              width: constraints.maxWidth * 0.15,
                              child: FittedBox(
                                  child: Icon(
                                Icons.bookmark_border,
                                color: Colors.transparent,
                              )),
                            )
                          ],
                        );
                      },
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
                      child: ChapterBookWidget(
                          _chapterBook,
                          recieverMap['idBook'] ?? '',
                          recieverMap['type'] ?? 0),
                    ),
                  ),
                ],
              ),
            ),
    ));
  }
}
