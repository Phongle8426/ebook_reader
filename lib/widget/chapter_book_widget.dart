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
            itemBuilder: (ctx, i) => GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                    type == 0 ? ReadingPage.routeName : ListeningPage.routeName,
                    arguments: {
                      'idChapter': chapterList[i].idChapter,
                      'idBook': idBook,
                      'numberOfChapter': chapterList[i].numberOfChapter,
                      'chapterName': chapterList[i].chapterName,
                      'listChapter': chapterList}
                );
              },
              child: Row(
                children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: 2,
                          bottom: 2
                        ),
                        padding: EdgeInsets.only(left: 5),
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width - 30,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15))
                        ),
                        child: Text('Chương ${chapterList[i].numberOfChapter}: ${chapterList[i].chapterName}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        )
                        )
                      )
                    ],
                  )
                ),
            itemCount: chapterList.length,
            scrollDirection: Axis.vertical,
          ),
    );
  }
}