import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quick_share/src/utils/MyHttpServer.dart';
import 'package:quick_share/src/utils/common.dart';

part 'http_server_event.dart';

part 'http_server_state.dart';

class HttpServerBloc extends Bloc<HttpServerEvent, HttpServerState> {
  HttpServerBloc() : super(HttpServerInitial());

  final MyHttpServer myHttpServer = MyHttpServer();

  @override
  Stream<HttpServerState> mapEventToState(
    HttpServerEvent event,
  ) async* {
    if (event is HttpServerStart) {
      myHttpServer.serve(event.filePath);
      yield HttpServerStarted(url: "abc");
    } else if (event is HttpServerStop) {
      await myHttpServer.stop();
      yield HttpServerStopped();
    } else if (event is HttpServerFindIpList) {
      List<InternetAddress> ipList = await CommonTools.getIPList();
      myHttpServer.ipList = ipList;
      yield HttpServerIpListFound(ipList: ipList);
    } else if (event is HttpServerSelectIp) {
      myHttpServer.selectedIp = event.ipAddress;
    }
  }
}
