part of 'recipe_detail_bloc.dart';

@immutable
abstract class RecipeDetailEvent {}

class GetRecipeDetail extends RecipeDetailEvent {
  final String key;
  GetRecipeDetail(this.key);
}
