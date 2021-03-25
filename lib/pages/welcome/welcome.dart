import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/rendering.dart';
import 'package:sloff/components/rectangle_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sloff/pages/cambiocausa.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';

class Welcome extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final String utente;

  const Welcome({
    Key key,
    this.text,
    this.onTap,
    this.utente
  }) : super(key: key);

  @override
  _Welcome createState() => _Welcome();
}

class _Welcome extends State<Welcome> with WidgetsBindingObserver{
  int _current = 0;
  CarouselController buttonCarouselController = CarouselController();
  String ut;
  var texts =[];
  Artboard _riveArtboard1;
  Artboard _riveArtboard2;
  Artboard _riveArtboard3;
  RiveAnimationController _controller;


  /*'assets/images/sloff_divano.riv'
    'assets/images/sloff_lavora.riv'
    'assets/images/sloff_salva_pianeta.riv'*/
  var image =[
    'assets/images/On_boarding/Sloff_img1.svg',
    'assets/images/On_boarding/Sloff_img2.svg',
    'assets/images/On_boarding/Sloff_img3.svg'
  ];
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }
  @override

  Future<String> _check () async {

    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Coupon/Coupon.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Coupon/Coupon_da_riscattare.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Coupon/Coupon_grigio.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Coupon/Riscatta_coupon.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Coupon/Sloff_Coupon_finiti.svg'), context,);

    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Home/Freccia_detox.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Home/Inizia.svg'), context,);
    //await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Home/Inizia_attivo.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Home/SLOFF_logo.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Home/Sloth_detox.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Home/Stop.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Home/Terra.svg'), context,);

    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/menu/Esci.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/menu/Gestione_account.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/menu/Impostazioni.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/menu/Privacy_policy.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/menu/Segnala.svg'), context,);
    //await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/menu/Servizio_clienti.svg'), context,);

    //await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/On_boarding/On_boarding_testo.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/On_boarding/Sloff_img1.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/On_boarding/Sloff_img2.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/On_boarding/Sloff_img3.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/On_boarding/Torta.svg'), context,);

    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Profilo/Copia.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Profilo/Coupon_aperto.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Profilo/Coupon_aperto_linea.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Profilo/Coupon_da_utilizzare.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Profilo/Modifica_profilo.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Profilo/Segnala.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Profilo/Servizio_Clienti.svg'), context,);

    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Tab_Bar/Coupon_icon.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Tab_Bar/Coupon_icon_ON.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Tab_Bar/Home_icon.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Tab_Bar/Home_icon_ON.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Tab_Bar/Profilo.svg'), context,);
    await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/Tab_Bar/Profilo_ON.svg'), context,);


  }

  void initState() {
    super.initState();
    _check();
    WidgetsBinding.instance.addObserver(this);

    rootBundle.load('assets/images/sloff_divano.riv').then(
          (data) async {
        final file = RiveFile();

        // Load the RiveFile from the binary data.
        if (file.import(data)) {
          // The artboard is the root of the animation and gets drawn in the
          // Rive widget.
          final artboard = file.mainArtboard;
          // Add a controller to play back a known animation on the main/default
          // artboard.We store a reference to it so we can toggle playback.
          artboard.addController(_controller = SimpleAnimation('Untitled 1'));
          setState(() => _riveArtboard1 = artboard);
        }
      },
    );
    rootBundle.load('assets/images/sloff_lavora.riv').then(
          (data) async {
        final file = RiveFile();

        // Load the RiveFile from the binary data.
        if (file.import(data)) {
          // The artboard is the root of the animation and gets drawn in the
          // Rive widget.
          final artboard = file.mainArtboard;
          // Add a controller to play back a known animation on the main/default
          // artboard.We store a reference to it so we can toggle playback.
          artboard.addController(_controller = SimpleAnimation('Untitled 1'));
          setState(() => _riveArtboard2 = artboard);
        }
      },
    );
    rootBundle.load('assets/images/sloff_salva_pianeta.riv').then(
          (data) async {
        final file = RiveFile();

        // Load the RiveFile from the binary data.
        if (file.import(data)) {
          // The artboard is the root of the animation and gets drawn in the
          // Rive widget.
          final artboard = file.mainArtboard;
          // Add a controller to play back a known animation on the main/default
          // artboard.We store a reference to it so we can toggle playback.
          artboard.addController(_controller = SimpleAnimation('Untitled 1'));
          setState(() => _riveArtboard3 = artboard);
        }
      },
    );
     texts =[<TextSpan>[
      new TextSpan(text: 'welcome'.tr(namedArgs: {'utente': widget.utente}), style: new TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat', fontSize: 24, color: Colors.black)),
      new TextSpan(style: new TextStyle(fontFamily: 'Montserrat', color: Colors.black),
          text: 'welcomesub'.tr()),
    ],
      <TextSpan>[
        new TextSpan(text: 'welcome1'.tr(), style: new TextStyle(fontWeight: FontWeight.normal, fontFamily: 'Montserrat', fontSize: 18, color: Colors.black)),
        new TextSpan(style: new TextStyle(fontFamily: 'Montserrat', color: Colors.black),
            text: 'welcome1sub'.tr()),
      ],
      <TextSpan>[
        new TextSpan(text: 'welcome2'.tr(), style: new TextStyle(fontWeight: FontWeight.normal, fontFamily: 'Montserrat', fontSize: 18, color: Colors.black)),
        new TextSpan(style: new TextStyle(fontFamily: 'Montserrat', color:  Colors.black),
            text: 'welcome2sub'.tr()),
      ],
    ];

  }
  void callbackFunction(int index, CarouselPageChangedReason reason) {
    setState(() {
      _current = index;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
      body:
      SafeArea(
        child:
      Container(padding: EdgeInsets.all(20),
          child:SingleChildScrollView(child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                  viewportFraction: 1.0,
                  autoPlay: false,
                  height: 500,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: callbackFunction,

                ),

                items: [1,2,3].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width*1,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                              color: Colors.transparent
                          ),
                          child:
                              Column(crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                  SvgPicture.asset(image[i-1]),
                                /*Container(
                                    width: MediaQuery.of(context).size.width*1,
                                height: 600,
                                child:
                                Padding(
                                  padding: const EdgeInsets.all(42.0),
                                  child: Center(
                                      child: //Text('${_formatIntervalTime(inBedTime, outBedTime)}',
                                      // style: TextStyle(fontSize: 36.0, color: Colors.blue))
                                      Rive(artboard: i==0?_riveArtboard1:i==1?_riveArtboard2:_riveArtboard3),
                                    //SvgPicture.asset('assets/images/Home/Terra.svg')
                                    //FlareActor('assets/images/Sloff_lavora.json', animation: 'idle',)
                                  ),
                                )),*/
                                Center(child:
                                new RichText(
                                    textAlign: TextAlign.center,
                                    text: new TextSpan(

                                        style: new TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500

                                        ),
                                        children:texts[i-1]
                                    )),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 15),
                                  child:
                                      GestureDetector(
                                        onTap: ()=>_settingModalBottomSheet(context),
                                        child: Text(_current<2?('welcomescopri').tr():('welcomescopri').tr(),
                                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),),
                                      )

                                )


                              ],)
                          );
                    },
                  );
                }).toList(),

              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(
                  [1,2,3],
                      (index, url) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.symmetric(vertical: 7.0, horizontal: 7.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Colors.blue
                              : Color(0xffD1D1C5)),
                    );
                  },
                ),
              ),
              GestureDetector(onTap: (){
                if(_current<2){
                  buttonCarouselController.nextPage(
                      duration: Duration(milliseconds: 300), curve: Curves.linear);
                }else{
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => CambioCausa())
                  );

                }

              },
                child:
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child:
                RectangleButton(text: _current<2?('avanti').tr():('mondoattende').tr().toUpperCase()), )),

            ],

          )))),
    );
  }

  void _settingModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        elevation: 10,
        isScrollControlled:true,

        builder: (BuildContext bc){
          return Material(
             elevation: 10,
             child:Scaffold(
               backgroundColor: Colors.transparent,
               /*appBar: new AppBar(backgroundColor: Colors.white,
                   automaticallyImplyLeading: false,
                 leading: new IconButton(
                 icon: new Icon(Icons.clear, color: Colors.black),
                 onPressed: () => Navigator.of(context).pop(),
               ), ),*/
             body:SingleChildScrollView(child:
            Container(
              padding: EdgeInsets.only(top: 50),
              color: Colors.white,
              // margin: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),

              child: new Column(
                children: <Widget>[
              Align(
              alignment: Alignment.topRight,
                  child:Container(child:
                    new IconButton(
                      icon: new Icon(Icons.clear, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  )),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 327,
                      margin: EdgeInsets.only(top: 8),
                      child: new RichText(
                          textAlign: TextAlign.left,
                          text: new TextSpan(
                              style: new TextStyle(
                                fontSize: 26.0,
                                color: Colors.black,
                              ),
                              children:[
                                TextSpan(
                                  text: ('EccoCome').tr()+' ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                              ]
                          )),
                    ),
                  ),
                  Container(
                    color:  Colors.white,

                    margin: EdgeInsets.only(top: 28, bottom: 5),

                    child: SvgPicture.asset(
                      "assets/images/On_boarding/Torta.svg",
                      fit: BoxFit.none,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 327,
                      margin: EdgeInsets.only(top: 28),
                      child: new RichText(
                          textAlign: TextAlign.left,
                          text: new TextSpan(
                              style: new TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              children:[
                                TextSpan(text: ('Ecco1').tr()+' '),
                                TextSpan(
                                  text: ('Ecco12').tr()+' ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: ('Ecco13').tr()+' '),

                              ]
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 327,
                      margin: EdgeInsets.only(top: 8),
                      child: new RichText(
                          textAlign: TextAlign.left,
                          text: new TextSpan(
                              style: new TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              children:[
                                TextSpan(
                                  text: ('Ecco2').tr()+' ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                              ]
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 327,
                      margin: EdgeInsets.only(top: 8),
                      child: new RichText(
                          textAlign: TextAlign.left,
                          text: new TextSpan(
                              style: new TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              children:[
                                TextSpan(text: ('Ecco3').tr()+' '),
                                TextSpan(
                                  text: ('Ecco32').tr()+' ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                              ]
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 327,
                      margin: EdgeInsets.only(top: 8),
                      child: new RichText(
                          textAlign: TextAlign.left,
                          text: new TextSpan(
                              style: new TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              children:[
                                TextSpan(text: ('Ecco4').tr()+' '),
                                TextSpan(
                                  text: ('Ecco41').tr()+' ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: ('Ecco42').tr()+' '),

                              ]
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 327,
                      margin: EdgeInsets.only(top: 8),
                      child: new RichText(
                          textAlign: TextAlign.left,
                          text: new TextSpan(
                              style: new TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              children:[
                                TextSpan(text: ('Ecco5').tr()+' '),
                                TextSpan(
                                  text: ('Ecco51').tr()+' ',
                                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                ),

                              ]
                          )),
                    ),
                  ),
                Container(height: 15,)

                ],
              ),

            ))//)
          ))
              ;
        }
    );
  }
}







