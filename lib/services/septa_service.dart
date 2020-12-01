import 'dart:io';

import 'package:bloc_departure/models/train.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SeptaService {
  Future<List<Train>> loadStationData(String station) async {
    // Send the get request
    http.Response response =
        await http.get("http://www3.septa.org/hackathon/Arrivals/$station/20/");

    // Build Train List
    var trains = List<Train>();

    try {
      // Replace Dynamic key and Decode it.
      var decodedJson = convert.jsonDecode('{ "Departures" : ' +
          response.body.substring(response.body.indexOf('[')));
      var north = decodedJson['Departures'][0]['Northbound'];
      var south = decodedJson['Departures'][1]['Southbound'];
      north.forEach((train) => trains.add(Train.fromJson(train)));
      south.forEach((train) => trains.add(Train.fromJson(train)));
    } catch (error) {
      print(error);
    }

    // Sort
    trains.sort((a, b) => a.departTime.compareTo(b.departTime));

    return trains;
  }

  // Method used inside is used to get the contents of the file.
  Future<List<String>> getStations() async {
    var output = List<String>();
    var request = await HttpClient().getUrl(Uri.parse(
        'http://www3.septa.org/hackathon/Arrivals/station_id_name.csv'));
    var response = await request.close();

    // Split the contents of the file using line break.
    await response.transform(convert.Utf8Decoder()).listen((fileContents) {
      convert.LineSplitter ls = convert.LineSplitter();
      List<String> lines = ls.convert(fileContents);
      lines.forEach((line) {
        output.add(line.split(',')[1]);
      });
    }).asFuture();

    return output;
  }
}
