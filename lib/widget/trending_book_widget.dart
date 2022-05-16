import 'package:ebook_reader/widget/pages/preview_page.dart';
import 'package:flutter/material.dart';

import '../models/book_model.dart';

class TrendingBook extends StatelessWidget {
  final List<PreviewBook> bookList;
  TrendingBook(this.bookList);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top truyện đọc nhiều',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            padding:  EdgeInsets.only(
              bottom: 10,
            ),
            child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemBuilder: (cxt, i) => GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushNamed(
                        PreviewPage.routeName,
                        arguments: bookList[i].idBook
                    );
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5
                      ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          width: MediaQuery.of(context).size.width * 0.18,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              bookList[i].coverImage,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bookList[i].name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Thể loại: ${bookList[i].kindOfBook}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Lượt xem: ${bookList[i].amountOfVisit}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              itemCount: bookList.length,
              scrollDirection: Axis.vertical,
            ),
          ),
        ],
      ),
    );
  }
}
