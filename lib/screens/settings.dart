import 'package:bloc_departure/providers/septa_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SeptaProvider>(context).bloc;
    return Scaffold(
      appBar: AppBar(
        title: Text('Departure Settings',
            style: Theme.of(context).textTheme.headline6),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 25.0,
          ),
          StreamBuilder<String>(
              stream: bloc.station,
              builder: (context, snapshot) {
                if (!snapshot.hasData) Container();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: StreamBuilder<List<String>>(
                      stream: bloc.stations,
                      builder: (context, snapshotStations) {
                        if (!snapshotStations.hasData)
                          return Row(
                            children: [],
                          );
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Station'),
                            DropdownButton<String>(
                              value: snapshot.data,
                              onChanged: (String value) {
                                bloc.changeStation(value);
                              },
                              items: snapshotStations.data
                                  .map<DropdownMenuItem<String>>(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                              value: value, child: Text(value)))
                                  .toList(),
                            ),
                          ],
                        );
                      }),
                );
              }),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: StreamBuilder<int>(
                stream: bloc.count,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Departures'),
                      DropdownButton<int>(
                        value: snapshot.data,
                        onChanged: (int value) {
                          bloc.changeCount(value);
                        },
                        items: <int>[4, 8, 10, 12, 16]
                            .map<DropdownMenuItem<int>>(
                              (int value) => DropdownMenuItem(
                                value: value,
                                child: Text(value.toString()),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  );
                }),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Text('Choose Direction'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: StreamBuilder<List<String>>(
                stream: bloc.directions,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  var directions = snapshot.data;
                  return Container(
                    child: Wrap(
                      spacing: 5.0,
                      runSpacing: 3.0,
                      children: [
                        FilterChip(
                          label: Text(
                            'Northbound',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          selected: (directions.contains('N')) ? true : false,
                          onSelected: (bool value) {
                            if (value == true) {
                              directions.add('N');
                              bloc.changeDirection(directions);
                            } else {
                              directions.remove(
                                  directions.firstWhere((x) => x == 'N'));
                              bloc.changeDirection(directions);
                            }
                          },
                        ),
                        FilterChip(
                          label: Text(
                            'Southbound',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          selected: (directions.contains('S')) ? true : false,
                          onSelected: (bool value) {
                            if (value == true) {
                              directions.add('S');
                              bloc.changeDirection(directions);
                            } else {
                              directions.remove(directions.firstWhere((x) =>
                                  x ==
                                  'S')); // Simple directions.remove('S') also works.
                              bloc.changeDirection(directions);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
