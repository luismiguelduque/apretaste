import 'package:apretaste/blocs/blocs.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../data/repositories/repositories.dart';
import '../../services/services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final getIt = GetIt.instance;

  AuthBloc() : super(AuthInitial()) {
    on<OnTokenReceivedEvent>(_handleOnTokenReceivedEvent);
    on<OnStoreFirebaseToken>((event, emit) async {
      try {
        await getIt<AuthRepository>().storeFirebaseToken(
          getIt<MirrorsBloc>().state.preferredMirror??'apretaste.net',
          event.token
        );
      } catch (e) {
        return;
      }
    });

    on<OnRemoveToken>((event, emit) async {
      try {
        getIt<TokenService>().deleteToken();
      } catch (e) {
        return;
      }
    });
  }

  Future<void> _handleOnTokenReceivedEvent(
    OnTokenReceivedEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      getIt<TokenService>().addToken(event.token);
    } catch (e) {
      return;
    }
  }
}
