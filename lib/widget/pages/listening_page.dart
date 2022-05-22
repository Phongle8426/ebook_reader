import 'package:audioplayers/audioplayers.dart';
import 'package:ebook_reader/service/database_service.dart';
import 'package:ebook_reader/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/book_model.dart';
import '../../models/chapter_book_model.dart';
import '../../models/content_book_model.dart';
import '../chapter_book_widget.dart';

class ListeningPage extends StatefulWidget {
  static const routeName = '/ListeningPage';

  @override
  _AudioFileState createState() => _AudioFileState();
}

class _AudioFileState extends State<ListeningPage> {
  final AudioPlayer advancedPlayer = AudioPlayer();
  String audioPath = "";
  late final List<ChapterBook> chapterList;
  String nameOfChapter ="";
  int currentChapter = 0;
  PreviewBook currentBook = PreviewBook.emtpy();
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool isPlaying=false;
  double currentSpeed = 1;
  Color color= Colors.black;
  List<IconData> _icons = [
    Icons.play_circle_fill,
    Icons.pause_circle_filled,
  ];
  bool loading = true;
  late Map recieverMap = Map();

  @override
  void initState(){
    super.initState();
    Future.delayed(Duration.zero,() async{
      recieverMap = ModalRoute.of(context)?.settings.arguments as Map;
      _getAudioOfChapter(recieverMap['idBook'], recieverMap['idChapter']);
      _getBook(recieverMap['idBook']);
    });
    Future.delayed(Duration(milliseconds: 500),(){
      initAudio();
    });

  }

  @override
  void dispose() {
    advancedPlayer.release();
    super.dispose();
  }

  void _getAudioOfChapter(String idBook, String idChapter) async{
    ContentBook contentBook = await Provider.of<DatabaseRealTimeService>(context,listen: false).getContentChapter(idBook, idChapter);
    setState(() {
      audioPath = contentBook.contentAudio!;
      currentChapter = contentBook.numberOfChapter!;
    });
  }
  void _getBook(String idBook) async{
    PreviewBook book = await Provider.of<DatabaseRealTimeService>(context, listen: false).getBookById(idBook);
    setState(() {
      currentBook = book;
      loading = false;
    });
  }

  void getAudioNextOrPrevious(String idBook,int number) async{
    advancedPlayer.release();
    String? urlAudio = await Provider.of<DatabaseRealTimeService>(context, listen: false).getAudioChapterByNumberOfChap(idBook, number);
    setState(() {
      audioPath = urlAudio;
      initAudio();
    });
  }

  void initAudio(){
    advancedPlayer.setUrl(audioPath, isLocal: false);
    advancedPlayer.onDurationChanged.listen((d) {setState(() {
      _duration = d;
    });});
    advancedPlayer.onAudioPositionChanged.listen((p) {setState(() {
      _position = p;
    });
    });
  }

  Widget btnStart() {
    return IconButton(
      padding: const EdgeInsets.only(bottom: 15),
      icon:isPlaying==false? Icon(_icons[0], size:50, color: Color(0xFFFF7643)):Icon(_icons[1], size:50, color:Colors.blue),
      onPressed: (){
        if(isPlaying==false) {
          advancedPlayer.play(audioPath, isLocal: false);
          setState(() {
            isPlaying = true;
          });
        }else if(isPlaying==true){
          advancedPlayer.pause();
          setState(() {
            isPlaying=false;
          });
        }
      },
    );
  }

  Widget btnNextChapter() {
    return IconButton(
        icon: Icon(Icons.keyboard_double_arrow_right_rounded),
        onPressed: () {
          if(currentChapter < (recieverMap['listChapter'] as List<ChapterBook>).length){
            getAudioNextOrPrevious(recieverMap['idBook'], currentChapter + 1);
            setState(() {
              isPlaying = false;
            });
          }else{
            final snackBar = SnackBar(
              content: const Text('Đây là chương cuối cùng nha :> !'),
              action: SnackBarAction(
                label: 'OK bạn!',
                onPressed: () {},
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }

        },
      );
  }
  Widget btnPreviousChapter() {
    return IconButton(
      icon:  Icon(Icons.keyboard_double_arrow_left_rounded),
      onPressed: () {
        if(currentChapter > 1){
          getAudioNextOrPrevious(recieverMap['idBook'], currentChapter - 1);
          setState(() {
            isPlaying = false;
          });
        }else{
          final snackBar = SnackBar(
            content: const Text('Đây là chương đầu tiên!'),
            action: SnackBarAction(
              label: 'OK bạn!',
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    );
  }

  Widget btnSpeed(double speed) {
    return MaterialButton(
      child: Text(changeSpeed(speed), style: TextStyle(fontSize: 10),),
      color: Colors.grey,
      onPressed: !isPlaying ? null : () {
          setState(() {
            print(currentSpeed);
            if(currentSpeed == 2) {
              currentSpeed = 1;
            } else {
              currentSpeed = currentSpeed + 0.5;
            }
          });
          advancedPlayer.setPlaybackRate(currentSpeed);
      },
        shape: CircleBorder()
    );
  }

  Widget slider() {
    return Slider(
        activeColor: Colors.orangeAccent,
        inactiveColor: Colors.grey,
        value: _position.inSeconds.toDouble(),
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            changeToSecond(value.toInt());
            value = value;
          });});
  }

  String changeSpeed(double speed){
    if(speed == 1) return "x1";
    if(speed == 1.5) return "x1.5";
    if(speed == 2) return "x2";
    return "";
  }

  void changeToSecond(int second){
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }

  Widget loadAsset() {
    return
      Container(
          child:Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[
                btnPreviousChapter(),
                btnStart(),
                btnNextChapter(),
              ])
      );
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final database = Provider.of<DatabaseRealTimeService>(context);
    setState(() {
      nameOfChapter = database.nameOfChapter;
      currentChapter = database.numberOfChap;
    });
    return Scaffold(
      body: SafeArea(
      child: loading ? Loading() : Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color.fromRGBO(249, 191, 161, 1), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.center
              )),
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
                      Text('Ebook Reader',
                          style: GoogleFonts.portLligatSans(
                            textStyle: Theme.of(context).textTheme.headline1,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          )),
                      Container(
                        padding: EdgeInsets.all(constraints.maxHeight * 0.18),
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
            SizedBox(height: 20,),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xfffff8ee),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
              child: Column(
                children: [
                  SizedBox(height: 50,),
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
                        currentBook.coverImage,
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
                    height: 50,
                  ),
                Text("Chương $currentChapter : $nameOfChapter",
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(66, 66, 86, 1)),
                  ),
                  SizedBox(height: 50,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_position.toString().split(".")[0], style: TextStyle(fontSize: 16),),

                        Text(_duration.toString().split(".")[0], style: TextStyle(fontSize: 16),),
                      ],
                    ),
                  ),
                  slider(),
                  loadAsset(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: size.height * 0.1,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                                                 ChapterBookWidget(recieverMap['listChapter'],recieverMap['idBook'], 1)
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
                            btnSpeed(currentSpeed)
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            )

          ],
        )
        ),
      )
    );
  }
}