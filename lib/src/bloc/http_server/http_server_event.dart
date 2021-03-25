part of 'http_server_bloc.dart';

abstract class HttpServerEvent extends Equatable {
  const HttpServerEvent();

  List<Object> get props => [];
}

class HttpServerStart extends HttpServerEvent {
  final String filePath;

  HttpServerStart({@required this.filePath});

  List<Object> get props => [filePath];
}

class HttpServerStop extends HttpServerEvent {}

class HttpServerFindIpList extends HttpServerEvent {}

class HttpServerSelectIp extends HttpServerEvent {
  final String ipAddress;

  HttpServerSelectIp({@required this.ipAddress});

  List<Object> get props => [ipAddress];
}
