import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:bloc/bloc.dart';

import '../../data/repositories/mirrors_repository.dart';
import '../../services/preferences_service.dart';
import '../../data/models/models.dart';

part 'mirrors_event.dart';
part 'mirrors_state.dart';

class MirrorsBloc extends Bloc<MirrorsEvent, MirrorsState> {
  final getIt = GetIt.instance;

  MirrorsBloc() : super(MirrorsState()) {

    on<OnDeveloperModeChanged>((event, emit) async {
      emit(state.copyWith(developerMode: event.value));
    });

    on<OnDeepLinkChanged>((event, emit) async {
      emit(state.copyWith(deepLink: event.link));
    });

    on<OnMirrorStatusChanged>((event, emit) async {
      emit(state.copyWith(mirrorStatus: event.status));
    });

    on<OnConnectToMirrorEvent>((event, emit) async {
      try {
        emit(state.copyWith(mirrorStatus: MirrorStatus.loading));
        // Checking current preferred or default mirror
        if(state.storedPreferredMirror != ''){
          if(await _checkPreferred(emit)) return;
        }else{
          if(await _checkDefault(emit)) return;
        }
        emit(state.copyWith(
          mirrorStatus: MirrorStatus.searching,
          developerMode: false
        ));
        if(await _checkS3List(emit)) return;
        emit(state.copyWith(mirrorStatus: MirrorStatus.noMirror));
      }  on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout
          || e.type == DioErrorType.receiveTimeout
          || e.type == DioErrorType.unknown) {
          emit(state.copyWith(mirrorStatus: MirrorStatus.noInternet));
        } else {
          emit(state.copyWith(mirrorStatus: MirrorStatus.noMirror));
        }
      } catch(e){
        emit(state.copyWith(mirrorStatus: MirrorStatus.noMirror));
      }
    });

    on<OnChangeManualInsertedMirror>((event, emit) async {
      try {
        emit(state.copyWith(devModeChecking: true));
        final checkResult = await _checkMirrors([event.mirror]);
        emit(state.copyWith(devModeChecking: false));
        if(checkResult.validMirrors.isEmpty){
          emit(state.copyWith(
            devModeFailed: true,
          ));
          return;
        }
        emit(state.copyWith(
          mirrorStatus: MirrorStatus.loading,
          preferredMirror: event.mirror,
        ));
        getIt<PreferencesService>().preferredMirror = event.mirror;
        final result = await _checkPreferred(emit);
        if(result) {
          emit(state.copyWith(
            mirrorStatus: MirrorStatus.active,
            developerMode: false
          ));
          return;
        }
        emit(state.copyWith(mirrorStatus: MirrorStatus.noMirror));
      } catch (e) {
        emit(state.copyWith(mirrorStatus: MirrorStatus.noMirror));
        rethrow;
      }
    });
  }

  Future<bool> _checkPreferred(Emitter<MirrorsState> emit) async {
    final result = await _checkMirrors([state.storedPreferredMirror]);
    if(result.validMirrors.isNotEmpty){
      emit(state.copyWith(
        mirrorStatus: MirrorStatus.active,
        preferredMirror: state.storedPreferredMirror,
      ));
      return true;
    }
    return false;
  }

  Future<bool> _checkDefault(Emitter<MirrorsState> emit) async {
    const defaultMirror = 'apretaste.net';
    final result = await _checkMirrors([defaultMirror]);
    if(result.validMirrors.isNotEmpty){
      emit(state.copyWith(
        mirrorStatus: MirrorStatus.active,
        preferredMirror: defaultMirror,
      ));
      getIt<PreferencesService>().preferredMirror = defaultMirror;
      return true;
    }
    return false;
  }

  Future<bool> _checkS3List(Emitter<MirrorsState> emit) async {
    try{
      final mirrors = await getIt<MirrorsRepository>().getMirrors();
      if(mirrors.mirrors.isNotEmpty){
        mirrors.mirrors.shuffle();
        final result = await _checkMirrors(mirrors.mirrors);
        if(result.validMirrors.isNotEmpty){
          emit(state.copyWith(
            mirrorStatus: MirrorStatus.active,
            preferredMirror: result.validMirrors[0],
            mirrorsList: result.validMirrors
          ));
          getIt<PreferencesService>().preferredMirror = result.validMirrors[0];
          return true;
        }
      }
      return false;
    }catch(e){
      rethrow;
    }
  }

  Future<GroupedMirrors> _checkMirrors(List<String> mirrors) async {
    List<String> validMorrors = [];
    List<String> invalidMorrors = [];
    await Future.wait(mirrors.map((item) =>
      getIt<MirrorsRepository>().checkMirror(item).then((status) {
        if(status){
          validMorrors.add(item);
        }else{
          invalidMorrors.add(item);
        }
      })
    ));
    return GroupedMirrors(validMirrors: validMorrors, invalidMirrors: invalidMorrors);
  }
}
