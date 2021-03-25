import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quick_share/src/utils/MyHttpServer.dart';

part 'http_server_event.dart';
part 'http_server_state.dart';

class HttpServerBloc extends Bloc<HttpServerEvent, HttpServerState> {
  HttpServerBloc() : super(HttpServerInitial());

  final MyHttpServer myHttpServer = MyHttpServer();

  @override
  Stream<HttpServerState> mapEventToState(
    HttpServerEvent event,
  ) async* {
    if (event is StartServer) {
      myHttpServer.serve(event.filePath);
      yield HttpServerStarted(url: "abc");
    } else if (event is StopServer) {
      await myHttpServer.stop();
      yield HttpServerStopped();
    }
  }
}
