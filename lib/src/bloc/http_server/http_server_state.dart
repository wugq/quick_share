part of 'http_server_bloc.dart';

abstract class HttpServerState extends Equatable {
  const HttpServerState();
}

class HttpServerInitial extends HttpServerState {
  @override
  List<Object> get props => [];
}

class HttpServerStarted extends HttpServerInitial {
  final String url;

  HttpServerStarted({this.url});

  @override
  List<Object> get props => [url];
}

class HttpServerStopped extends HttpServerInitial {}

class HttpServerIpListFound extends HttpServerInitial {
  final List<InternetAddress> ipList;

  HttpServerIpListFound({this.ipList});

  @override
  List<Object> get props => [ipList];
}

class HttpServerIpSelected extends HttpServerInitial {}
