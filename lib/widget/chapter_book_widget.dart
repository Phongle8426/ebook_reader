import 'package:ebook_reader/models/chapter_book_model.dart';
import 'package:ebook_reader/widget/pages/listening_page.dart';
import 'package:ebook_reader/widget/pages/reading_page.dart';
import 'package:flutter/material.dart';

class ChapterBookWidget extends StatelessWidget {
  final List<ChapterBook> chapterList;
  final String idBook;
  final int type;

  const ChapterBookWidget(this.chapterList, this.idBook, this.type);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (ctx, i) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          child: TextButton(
            style: TextButton.styleFrom(
              primary: Color(0xFFFF7643),
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              backgroundColor: Color(0xFFF5F6F9),
            ),
            onPressed: () => {
              Navigator.pop(context),
              Navigator.of(context).pushNamed(
                  type == 0 ? ReadingPage.routeName : ListeningPage.routeName,
                  arguments: {
                    'idChapter': chapterList[i].idChapter,
                    'idBook': idBook,
                    'numberOfChapter': chapterList[i].numberOfChapter,
                    'chapterName': chapterList[i].chapterName,
                    'listChapter': chapterList
                  })
            },
            child: Row(
              children: [
                Icon(type == 0 ? Icons.bookmark : Icons.headset, color: Color(0xFFFF7643)),
                SizedBox(width: 20),
                Expanded(
                    child: Text(
                        'Chương ${chapterList[i].numberOfChapter}: ${chapterList[i].chapterName}')),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
        itemCount: chapterList.length,
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
