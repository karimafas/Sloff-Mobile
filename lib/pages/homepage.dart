
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import'package:sloff/pages/coupon/coupon.dart';
import'package:sloff/pages/coupon/challenge.dart';


import'package:sloff/pages/timer/timer.dart';
import'package:sloff/pages/profile/profile.dart';

class HomeInitialPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeInitialPageState();
  }
}
class JosKeys {
  static final josKeys1 = const Key('__JosKey1__');
  static final josKeys2 = const Key('__JosKey2__');
  static final josKeys3 = const Key('__JosKey3__');

}
class _HomeInitialPageState extends State<HomeInitialPage> {

  final _scaffoldKeysss = new GlobalKey<ScaffoldState>();
  //final _voteKey = new GlobalKey<VoteTabState>();
  //final _suggKey = new GlobalKey<SuggestionTabState>();

  int _currentIndex = 0;
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeysss,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.blue,
        elevation: 1,
        fixedColor: Colors.white,
        backgroundColor:  Colors.white,


        onTap: (int index) => onBottomNavigationTap(context, index),
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            //icon: Icon(Icons.insert_emoticon),
            icon: _currentIndex==0?new SvgPicture.asset('assets/images/Tab_Bar/Home_icon_ON.svg'):
            SvgPicture.asset('assets/images/Tab_Bar/Home_icon.svg'),
            title: Text('Home', style: TextStyle(color: _currentIndex==0?Colors.blue:Colors.black,
                fontWeight: FontWeight.w500, fontSize: 11) ,),
          ),
          BottomNavigationBarItem(
            //icon: Icon(Icons.zoom_out),
            icon: _currentIndex==1?new SvgPicture.asset('assets/images/Tab_Bar/Coupon_icon_ON.svg'):
            SvgPicture.asset('assets/images/Tab_Bar/Coupon_icon.svg'),

            title: Text('Coupon', style: TextStyle(color: _currentIndex==1?Colors.blue:Colors.black,
                fontWeight: FontWeight.w500, fontSize: 11,),),
          ),
          BottomNavigationBarItem(
            //icon: Icon(Icons.person_outline),
            icon: _currentIndex==2?SvgPicture.asset('assets/images/Tab_Bar/Profilo_ON.svg'):
            SvgPicture.asset('assets/images/Tab_Bar/Profilo.svg'),

            title: Text('Profilo',
              style: TextStyle(color: _currentIndex==2?Colors.blue:Colors.black,
              fontWeight: FontWeight.w500, fontSize: 11,),),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          Timer(),
          Challenge(),
          Profile(),
        ],
      ),
    );
  }

  void onBottomNavigationTap(BuildContext context, int index) {
    if (index == 1) {
      //return _onSuggestionTap();
    }
    setState(() {
      _currentIndex = index;
    });
  }



}
