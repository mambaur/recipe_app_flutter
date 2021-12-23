import 'package:flutter/material.dart';
import 'package:recipe_app/screens/search/search_result.dart';

class SearchRecipe extends StatefulWidget {
  const SearchRecipe({Key? key}) : super(key: key);

  @override
  _SearchRecipeState createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: const TextStyle(color: Colors.black, fontSize: 16),
          textInputAction: TextInputAction.search,
          autofocus: true,
          onSubmitted: (value) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const SearchResult();
            }));
          },
          decoration: const InputDecoration(
              border: InputBorder.none, hintText: 'Cari masakan favoritmu...'),
        ),
      ),
    );
  }
}
