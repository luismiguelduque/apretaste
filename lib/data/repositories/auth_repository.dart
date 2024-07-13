import 'package:apretaste/services/services.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class AuthRepository {

  final Dio _dio;
  final getIt = GetIt.instance;

  AuthRepository(this._dio);

  Future<bool> storeFirebaseToken(String url, String id) async {
    try{
      final token = await getIt<TokenService>().getToken();
      final requiestUrl = 'https://$url/api/v1/register_push_id';
      final response = await _dio.post(
        requiestUrl,
        data: {
          "push_notification_id": id
        },
        options: Options(
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${token.toString()}',
          }
        )
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return true;
      }
      return false;
    }catch(e){
      rethrow;
    }
  }
}

