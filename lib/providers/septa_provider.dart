import 'package:bloc_departure/blocs/septa_bloc.dart';
import 'package:flutter/cupertino.dart';

class SeptaProvider with ChangeNotifier {
  SeptaBloc _bloc;

  SeptaProvider() {
    _bloc = SeptaBloc();
  }

  // Getter
  SeptaBloc get bloc => _bloc;
}
