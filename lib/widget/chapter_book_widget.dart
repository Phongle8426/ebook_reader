import 'package:ebook_reader/widget/pages/preview_page.dart';
import 'package:flutter/material.dart';
import '../models/book_model.dart';

class ChapterBook extends StatelessWidget {
  final List<PreviewBook> bookList;
  const ChapterBook(this.bookList);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 5,
            ),
            height: MediaQuery.of(context).size.height * 0.15,
            child: ListView.builder(
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                      PreviewPage.routeName,
                      arguments: bookList[i].idBook
                  );
                },
                child: Row(
                  children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 5,
                          ),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                          'Chương 1: Hồi Ức đáng nhớ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          )
                          )
                        )
                      ],
                    )
                  ),

              itemCount: bookList.length,
              scrollDirection: Axis.vertical,
            ),
          )
        ],
      ),
    );
  }
}