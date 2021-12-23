part of 'recipe_bloc.dart';

@immutable
abstract class RecipeEvent {}

class GetRecipe extends RecipeEvent {
  final int limit;
  final bool isInit;
  GetRecipe(this.limit, this.isInit);
}
