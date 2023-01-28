import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/repositories/recipe_repository.dart';

part 'recipe_detail_event.dart';
part 'recipe_detail_state.dart';

class RecipeDetailBloc extends Bloc<RecipeDetailEvent, RecipeDetailState> {
  final RecipeRepository _recipeRepo = RecipeRepository();
  RecipeDetailBloc() : super(RecipeDetailInitial()) {
    on<GetRecipeDetail>(_getRecipeDetail);
  }

  Future _getRecipeDetail(
      GetRecipeDetail event, Emitter<RecipeDetailState> emit) async {
    try {
      emit(GetRecipeDetailLoading());
      RecipeModel? data = await _recipeRepo.getRecipeDetail(event.id);
      if (data != null) {
        emit(RecipeDetailData(data));
      } else {
        emit(RecipeDetailError('Resep tidak ditemukan'));
      }
    } catch (e) {
      emit(RecipeDetailError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }
}
