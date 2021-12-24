part of 'recipe_search_bloc.dart';

@immutable
abstract class RecipeSearchState {}

class RecipeSearchInitial extends RecipeSearchState {}

class GetRecipeSearchLoading extends RecipeSearchState {}

class RecipeSearchData extends RecipeSearchState {
  final List<RecipeModel> listRecipes;
  final bool hasReachMax;
  RecipeSearchData(this.listRecipes, this.hasReachMax);
}

class RecipeSearchSuccess extends RecipeSearchState {
  final String message;
  RecipeSearchSuccess(this.message);
}

class RecipeSearchError extends RecipeSearchState {
  final String message;
  RecipeSearchError(this.message);
}
