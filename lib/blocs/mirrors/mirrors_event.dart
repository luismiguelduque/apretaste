part of 'mirrors_bloc.dart';

abstract class MirrorsEvent extends Equatable {
  const MirrorsEvent();

  @override
  List<Object> get props => [];
}

class OnConnectToMirrorEvent extends MirrorsEvent {}

class OnChangeManualInsertedMirror extends MirrorsEvent {
  final String mirror;
  const OnChangeManualInsertedMirror(this.mirror);
}

class OnMirrorStatusChanged extends MirrorsEvent {
  final MirrorStatus status;
  const OnMirrorStatusChanged(this.status);
}

class OnDeepLinkChanged extends MirrorsEvent {
  final String link;
  const OnDeepLinkChanged(this.link);
}

class OnDeveloperModeChanged extends MirrorsEvent {
  final bool value;
  const OnDeveloperModeChanged(this.value);
}