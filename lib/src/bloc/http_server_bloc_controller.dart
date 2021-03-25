import 'http_server/http_server_bloc.dart';

class HttpServerBlocController {
  HttpServerBlocController._();

  static HttpServerBlocController _instance = HttpServerBlocController._();

  factory HttpServerBlocController() => _instance;
  HttpServerBloc httpServerBloc = HttpServerBloc();
}
