import 'dart:io';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf/shelf.dart';

class MyHttpServer {
  HttpServer _httpServer;
  Handler _handler;
  String _filePath;
  bool _isConnected = false;
  List<InternetAddress> ipList;
  String selectedIp = "localhost";

  bool isFile(filePath) {
    FileSystemEntityType fileSystemEntityType =
        FileSystemEntity.typeSync(filePath);
    return fileSystemEntityType == FileSystemEntityType.file;
  }

  Future<HttpServer> serve(String filePath) async {
    if (_httpServer != null || _isConnected) {
      await _httpServer.close();
    }

    _filePath = filePath;
    if (isFile(_filePath)) {
      _handler = createFileHandler(_filePath);
    } else {
      _handler = createStaticHandler(_filePath, listDirectories: true);
    }

    return await startServer();
  }

  Future<HttpServer> startServer() async {
    _httpServer = await io.serve(_handler, selectedIp, 8080);
    _isConnected = true;
    return _httpServer;
  }

  Future<void> stop() async {
    await _httpServer.close();
    _isConnected = false;
    return;
  }

  getConnectionInfo() {
    return _httpServer.connectionsInfo();
  }

  bool isConnected() {
    return _isConnected;
  }
}
