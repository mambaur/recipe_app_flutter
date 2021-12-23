part of 'recipe_bloc.dart';

@immutable
abstract class RecipeState {}

class RecipeInitial extends RecipeState {}

class GetRecipeLoading extends RecipeState {}

class RecipeData extends RecipeState {
  final List<RecipeModel> listRecipes;
  final bool hasReachMax;
  RecipeData(this.listRecipes, this.hasReachMax);
}

class RecipeSuccess extends RecipeState {
  final String message;
  RecipeSuccess(this.message);
}

class RecipeError extends RecipeState {
  final String message;
  RecipeError(this.message);
}
