part of 'http_server_bloc.dart';

abstract class HttpServerEvent extends Equatable {
  const HttpServerEvent();

  List<Object> get props => [];
}

class StartServer extends HttpServerEvent {
  final String filePath;

  StartServer({@required this.filePath});

  List<Object> get props => [filePath];
}

class StopServer extends HttpServerEvent {}
