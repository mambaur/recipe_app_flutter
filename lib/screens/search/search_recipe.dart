import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:recipe_app/screens/search/search_result.dart';

class SearchRecipe extends StatefulWidget {
  const SearchRecipe({Key? key}) : super(key: key);

  @override
  _SearchRecipeState createState() => _SearchRecipeState();
}

enum StatusAd { initial, loaded }

class _SearchRecipeState extends State<SearchRecipe> {
  TextEditingController searchController = TextEditingController();

  BannerAd? myBanner;

  StatusAd statusAd = StatusAd.initial;

  BannerAdListener listener() => BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          if (kDebugMode) {
            print('Ad Loaded.');
          }
          setState(() {
            statusAd = StatusAd.loaded;
          });
        },
      );

  @override
  void initState() {
    myBanner = BannerAd(
      // test banner
      // adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      //
      adUnitId: 'ca-app-pub-2465007971338713/7262417937',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: listener(),
    );
    myBanner!.load();
    super.initState();
  }

  @override
  void dispose() {
    myBanner!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          style: const TextStyle(color: Colors.black, fontSize: 16),
          textInputAction: TextInputAction.search,
          autofocus: true,
          onSubmitted: (value) {
            if (searchController.text != '') {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SearchResult(
                  keyword: searchController.text,
                );
              }));
            }
          },
          decoration: const InputDecoration(
              border: InputBorder.none, hintText: 'Cari masakan favoritmu...'),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 15),
          child: statusAd == StatusAd.loaded
              ? Container(
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  alignment: Alignment.center,
                  child: AdWidget(ad: myBanner!),
                  width: myBanner!.size.width.toDouble(),
                  height: myBanner!.size.height.toDouble(),
                )
              : Container(),
        ),
      ),
    );
  }
}
