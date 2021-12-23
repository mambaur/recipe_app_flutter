part of 'recipe_detail_bloc.dart';

@immutable
abstract class RecipeDetailState {}

class RecipeDetailInitial extends RecipeDetailState {}

class GetRecipeDetailLoading extends RecipeDetailState {}

class RecipeDetailData extends RecipeDetailState {
  final RecipeModel recipeModel;
  RecipeDetailData(this.recipeModel);
}

class RecipeDetailSuccess extends RecipeDetailState {
  final String message;
  RecipeDetailSuccess(this.message);
}

class RecipeDetailError extends RecipeDetailState {
  final String message;
  RecipeDetailError(this.message);
}
