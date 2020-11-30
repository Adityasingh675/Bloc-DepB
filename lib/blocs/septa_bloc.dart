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

  SeptaBloc() {
    loadSettings();
    // loadStationData('Suburban Station');

    // Listeners
    station.listen((station) async {
      changeTrain(await _septaService.loadStationData(station));
    });
  }

  // Getters
  Stream<List<Train>> get trains => _trains.stream;
  Stream<int> get count => _count.stream;
  Stream<String> get station => _station.stream;
  Stream<List<String>> get directions => _directions.stream;

  // Setters
  Function(List<Train>) get changeTrain => _trains.sink.add;
  Function(int) get changeCount => _count.sink.add;
  Function(String) get changeStation => _station.sink.add;
  Function(List<String>) get changeDirection => _directions.sink.add;

  // Dispose
  void dispose() {
    _trains.close();
    _count.close();
    _station.close();
    _directions.close();
  }

  // Load settings from user's device
  void loadSettings() {
    changeCount(10);
    changeDirection(['N', 'S']);
    changeStation('Suburban Station');
  }
}
