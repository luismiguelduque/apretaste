import 'package:dio/dio.dart';

import '../../data/models/models.dart';

class MirrorsRepository {

  final Dio _dio;

  MirrorsRepository(this._dio);

  Future<SuitableDomains> getMirrors() async {
    try{
      final response = await _dio.get(
        'https://s3.amazonaws.com/apretaste/mirrors.json'
      );
      if(response.statusCode == 200){
        return SuitableDomains.fromMap(response.data);
      }
      return SuitableDomains(mirrors: []);
    }catch(e){
      rethrow;
    }
  }

  Future<bool> checkMirror(String url) async {
    try{
      final requiestUrl = 'https://$url/api/v1/ping';
      final response = await _dio.get(requiestUrl);
      if(response.statusCode == 200){
        final pingRespomse = Ping.fromMap(response.data);
        if(pingRespomse.code == 'PONG'){
          return true;
        }
        return false;
      }
      return false;
    }catch(e){
      return false;
    }
  }

}
