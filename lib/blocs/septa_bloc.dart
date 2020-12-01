import 'package:bloc_departure/models/train.dart';
import 'package:bloc_departure/services/septa_service.dart';
import 'package:rxdart/rxdart.dart';

class SeptaBloc {
  // Define StreamController/ Subject.
  final _trains = BehaviorSubject<List<Train>>();
  final _station = BehaviorSubject<String>();
  final _count = BehaviorSubject<int>();
  final _directions = BehaviorSubject<List<String>>();
  final _septaService = SeptaService();
  final _stations = BehaviorSubject<List<String>>();

  SeptaBloc() {
    loadSettings();
    loadStations();
    // loadStationData('Suburban Station');

    // Listeners to get info from the API using RxDart.
    station.listen((station) async {
      await refreshDepartures();
    });
  }

  // Getters
  Stream<List<Train>> get trains => _trains.stream.map((trainList) => trainList
      .where((train) => _directions.value.contains(train.direction))
      .take(_count.value)
      .toList());
  Stream<int> get count => _count.stream;
  Stream<String> get station => _station.stream;
  Stream<List<String>> get directions => _directions.stream;
  Stream<List<String>> get stations => _stations.stream;

  // Setters
  Function(List<Train>) get changeTrain => _trains.sink.add;
  Function(int) get changeCount => _count.sink.add;
  Function(String) get changeStation => _station.sink.add;
  Function(List<String>) get changeDirection => _directions.sink.add;
  Function(List<String>) get changeStations => _stations.sink.add;

  // Dispose
  void dispose() {
    _trains.close();
    _count.close();
    _station.close();
    _directions.close();
    _stations.close();
  }

  // Load settings from user's device
  void loadSettings() {
    changeCount(10);
    changeDirection(['N', 'S']);
    changeStation('Suburban Station');
  }

  Future<void> refreshDepartures() async {
    changeTrain(await _septaService.loadStationData(_station.value));

    // Set Timer to run again
    TimerStream(DateTime.now(), Duration(seconds: 60))
        .listen((timestamp) async {
      print('Refreshing at $timestamp');
      await refreshDepartures();
    });
  }

  Future<void> loadStations() async {
    changeStations(await _septaService.getStations());
  }
}
