part of 'mirrors_bloc.dart';

enum MirrorStatus {
  undefined,
  loading,
  active,
  ready,
  devMode,
  noInternet,
  searching,
  noMirror
}

class MirrorsState extends Equatable {
  final getIt = GetIt.instance;

  final List<String> mirrorsList;
  final String? preferredMirror;
  final MirrorStatus mirrorStatus;
  final String? deepLink;
  final bool developerMode;
  final bool devModeChecking;
  final bool devModeFailed;

  MirrorsState({
    this.mirrorsList = const [],
    this.preferredMirror,
    this.mirrorStatus = MirrorStatus.undefined,
    this.deepLink,
    this.developerMode = false,
    this.devModeChecking = false,
    this.devModeFailed = false
  });

  String get storedPreferredMirror{
    return getIt<PreferencesService>().preferredMirror;
  }

  MirrorsState copyWith({
    SuitableDomains? suitableDomains,
    List<String>? mirrorsList,
    String? preferredMirror,
    MirrorStatus? mirrorStatus,
    String? manualInsertedMirror,
    String? deepLink,
    bool? developerMode,
    bool? devModeChecking,
    bool? devModeFailed,
  }) => MirrorsState(
    mirrorsList: mirrorsList ?? this.mirrorsList,
    preferredMirror: preferredMirror ?? this.preferredMirror,
    mirrorStatus: mirrorStatus ?? this.mirrorStatus,
    deepLink: deepLink ?? this.deepLink,
    developerMode: developerMode ?? this.developerMode,
    devModeChecking: devModeChecking ?? this.devModeChecking,
    devModeFailed: devModeFailed ?? this.devModeFailed,
  );

  @override
  List<dynamic> get props => [
    mirrorsList,
    preferredMirror,
    mirrorStatus,
    deepLink,
    developerMode,
    devModeChecking,
    devModeFailed
  ];
}