import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'package:filter_demo/models/vga.dart';
import 'package:filter_demo/models/part.dart';

class VgaState {
  var _all = List<Vga>();
  var _sort = PartSort.latest;
  String _searchString = '';
  bool _searchEnabled = false;
  VgaFilter _filter = VgaFilter();
  var _list = BehaviorSubject<List<Vga>>();

  Stream<List<Part>> get list => _list.stream
      .map((e) => _filter.filters(e))
      .map((e) => _searchEnabled ? partSearchMap(e, _searchString) : e)
      .map((e) => partSortMap(e, _sort));

  get searchEnable => _searchEnabled;
  get searchString => _searchString;
  //tempory geter for filter page will delete when refactory filter page to rxdart
  get all => _all;
  get filter => _filter;

  _update() => _list.add(_all);

  Future<void> loadData() async {
    //var data = await http.get('http://10.0.2.2:3000/packages');
    var data = await http.get("https://run.mocky.io/v3/88a4039a-49e0-4f6c-9a78-d90a4bea1bd2");

    final jsonString = json.decode(data.body);
    _all.clear();
    jsonString.forEach((v) {
      final vga = Vga.fromJson(v);
      _all.add(vga);
    });
    _update();

    /*if (data.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      final jsonString = json.decode(data.body);
     // print (data.statusCode);
     // print(data.body);
      _all.clear();
      jsonString.forEach((v) {
        final vga = Vga.fromJson(v);
        _all.add(vga);
      });
      _update();
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }*/

  }

  setFilter(VgaFilter f) {
    _filter = f;
    _update();
  }

  search(String txt, bool enable) {
    _searchString = txt;
    _searchEnabled = enable;
    _update();
  }

  sort(PartSort s) {
    _sort = s;
    _update();
  }
}

var vgaState = VgaState();
