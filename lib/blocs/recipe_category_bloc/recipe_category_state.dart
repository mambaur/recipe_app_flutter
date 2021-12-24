part of 'recipe_category_bloc.dart';

@immutable
abstract class RecipeCategoryState {}

class RecipeCategoryInitial extends RecipeCategoryState {}

class GetRecipeByCategoryLoading extends RecipeCategoryState {}

class RecipeByCategoryData extends RecipeCategoryState {
  final List<RecipeModel> listRecipes;
  final bool hasReachMax;
  RecipeByCategoryData(this.listRecipes, this.hasReachMax);
}

class RecipeByCategorySuccess extends RecipeCategoryState {
  final String message;
  RecipeByCategorySuccess(this.message);
}

class RecipeByCategoryError extends RecipeCategoryState {
  final String message;
  RecipeByCategoryError(this.message);
}
