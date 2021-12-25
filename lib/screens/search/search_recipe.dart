import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:recipe_app/screens/search/search_result.dart';

class SearchRecipe extends StatefulWidget {
  const SearchRecipe({Key? key}) : super(key: key);

  @override
  _SearchRecipeState createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // loadAds();
    super.initState();
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
          child: const BannerAd(
            size: BannerSize.MEDIUM_RECTANGLE,
          ),
          width: 320,
          height: 250,
        ),
      ),
    );
  }
}
