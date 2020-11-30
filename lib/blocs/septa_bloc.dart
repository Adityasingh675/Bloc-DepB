import 'package:bloc_departure/models/train.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SeptaBloc {
  // Define StreamController/ Subject.
  final _trains = BehaviorSubject<List<Train>>();

  SeptaBloc() {
    loadStationData('Suburban Station');
  }

  // Getters
  Stream<List<Train>> get trains => _trains.stream;

  // Setters
  Function(List<Train>) get changeTrain => _trains.sink.add;

  // Dispose
  void dispose() {
    _trains.close();
  }

  void loadStationData(String station) async {
    // Send the get request
    http.Response response =
        await http.get("http://www3.septa.org/hackathon/Arrivals/$station/20/");

    // Replace Dynamic key and Decode it.
    var decodedJson = convert.jsonDecode('{ "Departures" : ' +
        response.body.substring(response.body.indexOf('[')));

    // Build Train List
    var trains = List<Train>();

    try {
      var north = decodedJson['Departures'][0]['Northbound'];
      var south = decodedJson['Departures'][1]['Southbound'];
      north.forEach((train) => trains.add(Train.fromJson(train)));
      south.forEach((train) => trains.add(Train.fromJson(train)));
    } catch (error) {
      print(error);
    }

    // Sort
    trains.sort((a, b) => a.departTime.compareTo(b.departTime));

    // Update Stream
    changeTrain(trains);
  }
}
