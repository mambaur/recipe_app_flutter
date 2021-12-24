part of 'recipe_search_bloc.dart';

@immutable
abstract class RecipeSearchEvent {}

class GetRecipeSearch extends RecipeSearchEvent {
  final String keyword;
  final int limit;
  final bool isInit;
  GetRecipeSearch(this.limit, this.isInit, this.keyword);
}
