import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/recipe_search_bloc/recipe_search_bloc.dart';
import 'package:recipe_app/screens/recipes/recipe_detail.dart';
import 'package:recipe_app/utils/custom_cached_image.dart';
import 'package:recipe_app/utils/text_format.dart';

class SearchResult extends StatefulWidget {
  final String keyword;
  const SearchResult({Key? key, required this.keyword}) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  late RecipeSearchBloc recipeSearchBloc;

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    recipeSearchBloc.add(GetRecipeSearch(10, true, widget.keyword));
  }

  @override
  void initState() {
    recipeSearchBloc = BlocProvider.of<RecipeSearchBloc>(context);
    recipeSearchBloc.add(GetRecipeSearch(10, true, widget.keyword));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.keyword,
          style: const TextStyle(fontWeight: FontWeight.normal),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.search))
        ],
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.orangeAccent.shade700,
        displacement: 20,
        onRefresh: () => _refresh(),
        child: BlocBuilder<RecipeSearchBloc, RecipeSearchState>(
          builder: (context, state) {
            if (state is RecipeSearchData) {
              return ListView.builder(
                  itemCount: state.listRecipes.length,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          state.listRecipes[index].title != null
                              ? state.listRecipes[index].title!
                              : TextFormat.slugToTitle(
                                  state.listRecipes[index].slug ?? ''),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(Icons.timer_outlined,
                              size: 14, color: Colors.grey.shade400),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(state.listRecipes[index].timeCooking ?? '',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade400)),
                          const SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.ramen_dining_outlined,
                              size: 14, color: Colors.grey.shade400),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(state.listRecipes[index].portion ?? '',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade400)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RecipeDetail(
                            recipeModel: state.listRecipes[index],
                          );
                        }));
                      },
                      leading: SizedBox(
                          width: 70,
                          height: 70,
                          child: CustomCachedImage.build(context,
                              imgUrl: state.listRecipes[index].coverImage ?? '',
                              borderRadius: BorderRadius.circular(10))),
                    );
                  });
            } else {
              return Center(
                  child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                    color: Colors.orange.shade600, strokeWidth: 3),
              ));
            }
          },
        ),
      ),
    );
  }
}
