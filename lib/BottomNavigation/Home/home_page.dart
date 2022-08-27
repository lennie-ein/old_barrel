import 'dart:async';
import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:old_barrel/Assets/assets.dart';
import 'package:old_barrel/Components/brands_list.dart';
import 'package:old_barrel/Components/cart_icon.dart';
import 'package:old_barrel/Components/entry_field2.dart';
import 'package:old_barrel/Locale/locale.dart';
import 'package:old_barrel/Routes/page_routes.dart';

var locationMessage = '';
var Address = '';
Future getCurrentLocation() async {
  var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  // var lastPosition = await Geolocator.getLastKnownPosition();
  List<Placemark> placemarks =
  await placemarkFromCoordinates(position.latitude, position.longitude);
  Placemark place = placemarks[0];
  // print(lastPosition);
  // print(placemarks);
  // print(place);

    locationMessage = "Lat: ${position.latitude},Long: ${position.longitude}";
    Address =
    "${place.isoCountryCode}, ${place.administrativeArea}, ${place.locality}, ${place.thoroughfare}";


}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class Category {
  String? title;
  String image;

  Category(this.title, this.image);
}

class _HomePageState extends State<HomePage> {




  Future permissionsCheck() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print(serviceEnabled);
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }


    return await getCurrentLocation();
  }

  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  BannerAd? _anchoredBanner;
  bool _loadingAnchoredBanner = false;

  Future<void> _createAnchoredBanner(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    final BannerAd banner = BannerAd(
      size: size,
      request: request,
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716',
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            _anchoredBanner = ad as BannerAd?;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
    );
    // return banner.load();
  }

  Timer? timer;

  @override
  void initState() {
        timer = Timer.periodic(
        Duration(seconds: 360), (Timer t) => getCurrentLocation());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _anchoredBanner?.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    List<Category> categories = [
      Category(locale.beer, Assets.liquor1),
      Category(locale.wine, Assets.liquor2),
      Category(locale.vodka, Assets.liquor3),
      Category(locale.brandy, Assets.liquor4),
      Category(locale.rum, Assets.liquor5),
      Category(locale.tequila, Assets.liquor6),
      Category(locale.whiskey, Assets.liquor7),
      Category(locale.more, Assets.liquor8),
    ];

    return Builder(
      builder: (BuildContext context) {
        if (!_loadingAnchoredBanner) {
          _loadingAnchoredBanner = false;
          _createAnchoredBanner(context);
          permissionsCheck();
          getCurrentLocation();
        }
        return Scaffold(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: locale.deliveryTo!.toUpperCase() + '\n',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: Theme.of(context).primaryColor, fontSize: 12)),
                  TextSpan(
                      text: '$Address',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 12, height: 1.4)),
                ])),
                SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Theme.of(context).primaryColor,
                )
              ],
            ),
            actions: [CartIcon()],
          ),
          body: FadedSlideAnimation(
            ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: EntryFieldDark(
                    onTap: () {
                      Navigator.pushNamed(context, PageRoutes.searchPage);
                    },
                    readOnly: true,
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsetsDirectional.only(end: 8.0),
                          child: FadedScaleAnimation(
                            Image.asset(
                              Assets.banner1,
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      }),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        child: Text(
                          locale.categories!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontSize: 16),
                        ),
                      ),
                      GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          shrinkWrap: true,
                          itemCount: categories.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  crossAxisCount: 4),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PageRoutes.beerPage);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Theme.of(context)
                                              .secondaryHeaderColor,
                                          Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ])),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      categories[index].title!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(fontSize: 12),
                                    ),
                                    Spacer(),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: FadedScaleAnimation(
                                        Image.asset(
                                          categories[index].image,
                                          scale: 3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                      if (_anchoredBanner != null)
                        Container(
                          padding: EdgeInsets.all(16),
                          width: _anchoredBanner!.size.width.toDouble(),
                          height: _anchoredBanner!.size.height.toDouble(),
                          child: AdWidget(ad: _anchoredBanner!),
                        ),
                      LiquorBrands(),
                      SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            beginOffset: Offset(0, 0.3),
            endOffset: Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
          ),
        );
      },
    );
  }


}
