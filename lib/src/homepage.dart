import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:quick_share/src/bloc/http_server/http_server_bloc.dart';
import 'package:quick_share/src/bloc/http_server_bloc_controller.dart';
import 'package:device_info_plus/device_info_plus.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HttpServerBloc _httpServerBloc;
  String _url;

  // MyHttpServer _myHttpServer = MyHttpServer();

  @override
  void initState() {
    _httpServerBloc = HttpServerBlocController().httpServerBloc;
    _url = "";
    super.initState();
  }

  Future<String> _selectFileToShare(BuildContext context) async {
    Directory rootPath = Directory('/home/wugq');
    String _pickPath = await FilesystemPicker.open(
      title: 'Select file or folder to share',
      context: context,
      rootDirectory: rootPath,
      fsType: FilesystemType.all,
      folderIconColor: Colors.teal,
      fileTileSelectMode: FileTileSelectMode.wholeTile,
    );
    return _pickPath;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HttpServerBloc, HttpServerState>(
      bloc: _httpServerBloc,
      listener: (context, state) {
        if (state is HttpServerStopped) {
          setState(() {
            _url = "";
          });
        } else if (state is HttpServerStarted) {
          setState(() {
            _url = state.url;
          });
        }
      },
      child: BlocBuilder<HttpServerBloc, HttpServerState>(
        bloc: _httpServerBloc,
        builder: (BuildContext context, HttpServerState state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$_url',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  QrImage(
                    data: '$_url',
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ],
              ),
            ),
            floatingActionButton: state is HttpServerStarted
                ? FloatingActionButton(
                    onPressed: () async {
                      // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                      // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                      _httpServerBloc.add(StopServer());
                    },
                    tooltip: 'Stop',
                    child: Icon(Icons.stop),
                  )
                : FloatingActionButton(
                    onPressed: () async {
                      // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                      // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                      String filePath = await _selectFileToShare(context);
                      _httpServerBloc.add(StartServer(filePath: filePath));
                    },
                    tooltip: 'Start',
                    child: Icon(Icons.add),
                  ),
          );
        },
      ),
    );
  }
}
