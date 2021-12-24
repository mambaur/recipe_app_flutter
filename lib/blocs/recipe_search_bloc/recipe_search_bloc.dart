import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/repositories/recipe_repository.dart';

part 'recipe_search_event.dart';
part 'recipe_search_state.dart';

class RecipeSearchBloc extends Bloc<RecipeSearchEvent, RecipeSearchState> {
  final RecipeRepository _recipeRepo = RecipeRepository();
  List<RecipeModel> listRecipes = [];

  RecipeSearchBloc() : super(RecipeSearchInitial()) {
    on<GetRecipeSearch>(_getRecipesSearch);
  }

  Future _getRecipesSearch(
      GetRecipeSearch event, Emitter<RecipeSearchState> emit) async {
    try {
      emit(GetRecipeSearchLoading());
      List<RecipeModel>? data =
          await _recipeRepo.getSearchRecipes(keyword: event.keyword);
      if (data != null) {
        listRecipes = data;
        emit(RecipeSearchData(listRecipes, true));
      } else {
        emit(RecipeSearchError('Resep masakan tidak ditemukan'));
      }
    } catch (e) {
      emit(RecipeSearchError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }
}
