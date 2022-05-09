import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../chapter_book_widget.dart';

class ListeningPage extends StatefulWidget {
  static const routeName = '/ListeningPage';

  @override
  _AudioFileState createState() => _AudioFileState();
}

class _AudioFileState extends State<ListeningPage> {
  final AudioPlayer advancedPlayer = AudioPlayer();
  final String audioPath = "https://firebasestorage.googleapis.com/v0/b/ebookreader-5bd9b.appspot.com/o/dptk123.mp3?alt=media&token=774f8250-9610-4ed6-a38d-189fec46f419";
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool isPlaying=false;
  bool isPaused=false;
  bool isRepeat=false;
  Color color= Colors.black;
  List<IconData> _icons = [
    Icons.play_circle_fill,
    Icons.pause_circle_filled,
  ];
  late Map recieverMap = Map();

  @override
  void initState(){
    super.initState();
    Future.delayed(Duration.zero,() {
      recieverMap = ModalRoute.of(context)?.settings.arguments as Map;
    });
    advancedPlayer.onDurationChanged.listen((d) {setState(() {
      _duration = d;
    });});
    advancedPlayer.onAudioPositionChanged.listen((p) {setState(() {
      _position = p;
    });
    });
    advancedPlayer.setUrl(audioPath, isLocal: false);
  }

  Widget btnStart() {
    return IconButton(
      padding: const EdgeInsets.only(bottom: 15),
      icon:isPlaying==false?Icon(_icons[0], size:50, color:Colors.blue):Icon(_icons[1], size:50, color:Colors.blue),
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

  Widget btnFast() {
    return
      IconButton(
        icon: Icon(Icons.keyboard_double_arrow_right_rounded),
        onPressed: () {
          advancedPlayer.setPlaybackRate(1.5);
        },
      );
  }
  Widget btnSlow() {
    return IconButton(
      icon:  Icon(Icons.keyboard_double_arrow_left_rounded),
      onPressed: () {
        advancedPlayer.setPlaybackRate(0.5);

      },
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
                btnSlow(),
                btnStart(),
                btnFast(),
              ])
      );
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color.fromRGBO(249, 191, 161, 1), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.center
                //,stops: [0.7,0.9]
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
                              color: Colors.white,
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
                  Hero(
                    tag: Text("Haha"),
                    child: Container(
                      height: size.height * 0.3,
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(size.width * 0.05),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/3.jfif'),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(203, 201, 208, 1),
                                blurRadius: 10,
                                spreadRadius: 0.6,
                                offset: Offset(size.width * 0.55 * 0.051,
                                    size.height * 0.4 * 0.031))
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                Text("Chương ${recieverMap['numberOfChapter']} : ${recieverMap['chapterName']}",
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