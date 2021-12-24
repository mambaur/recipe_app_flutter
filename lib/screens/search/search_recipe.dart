import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:recipe_app/screens/search/search_result.dart';

class SearchRecipe extends StatefulWidget {
  const SearchRecipe({Key? key}) : super(key: key);

  @override
  _SearchRecipeState createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  TextEditingController searchController = TextEditingController();

  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-2465007971338713/4377479735',
    size: AdSize.mediumRectangle,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  loadAds() async {
    await myBanner.load();
    setState(() {});
  }

  @override
  void initState() {
    loadAds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          style: const TextStyle(color: Colors.black, fontSize: 16),
          textInputAction: TextInputAction.search,
          autofocus: true,
          onSubmitted: (value) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SearchResult(
                keyword: searchController.text,
              );
            }));
          },
          decoration: const InputDecoration(
              border: InputBorder.none, hintText: 'Cari masakan favoritmu...'),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.only(top: 15),
          child: AdWidget(ad: myBanner),
          width: myBanner.size.width.toDouble(),
          height: myBanner.size.height.toDouble(),
        ),
      ),
    );
  }
}
