import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:quick_share/src/bloc/http_server/http_server_bloc.dart';
import 'package:quick_share/src/bloc/http_server_bloc_controller.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(
    List<InternetAddress> ipList) {
  List<DropdownMenuItem<String>> items = [];
  for (InternetAddress ipAddress in ipList) {
    items.add(DropdownMenuItem(
        value: ipAddress.address, child: Text(ipAddress.address)));
  }
  return items;
}

class _MyHomePageState extends State<MyHomePage> {
  HttpServerBloc _httpServerBloc;
  String _url;

  List<InternetAddress> _ipList;
  bool _ipv4Only = true;
  String _selectedIp;
  List<DropdownMenuItem<String>> _dropDownMenuIpList = [];

  void changedDropDownIpAddress(String selectedIp) {
    setState(() {
      _selectedIp = selectedIp;
    });
    _httpServerBloc.add(HttpServerSelectIp(ipAddress: selectedIp));
  }

  @override
  void initState() {
    _httpServerBloc = HttpServerBlocController().httpServerBloc;
    _url = "";
    _httpServerBloc.add(HttpServerFindIpList());
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
        } else if (state is HttpServerIpListFound) {
          List<DropdownMenuItem<String>> ipSelectList =
              buildAndGetDropDownMenuItems(state.ipList);
          setState(() {
            _ipList = state.ipList;
            _dropDownMenuIpList = ipSelectList;
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
                  DropdownButton(
                    value: _selectedIp,
                    items: _dropDownMenuIpList,
                    onChanged: changedDropDownIpAddress,
                  ),
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
                      _httpServerBloc.add(HttpServerStop());
                    },
                    tooltip: 'Stop',
                    child: Icon(Icons.stop),
                  )
                : FloatingActionButton(
                    onPressed: () async {
                      String filePath = await _selectFileToShare(context);
                      _httpServerBloc.add(HttpServerStart(filePath: filePath));
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
