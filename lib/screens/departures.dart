import 'dart:ui';

import 'package:bloc_departure/models/train.dart';
import 'package:bloc_departure/providers/septa_provider.dart';
import 'package:bloc_departure/screens/settings.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Departures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SeptaProvider>(context).bloc;
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
            stream: bloc.station,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              return Text(
                snapshot.data,
                style: Theme.of(context).textTheme.headline6,
              );
            }),
        actions: [
          FlatButton(
            child: Text(
              'Change',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Settings()));
            },
          )
        ],
      ),
      body: StreamBuilder<List<Train>>(
          stream: bloc.trains,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            return RefreshIndicator(
              onRefresh: bloc.refreshDepartures,
              child: ListView.builder(
                itemCount: snapshot.data.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildHeader(context);
                  } else {
                    return _buildDeparture(context, snapshot.data[index - 1]);
                  }
                },
              ),
            );
          }),
    );
  }

  _buildHeader(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 15.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 25.0,
            ),
            Text(
              'Departures',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          children: [
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Text(
                'Time',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              flex: 1,
            ),
            Expanded(
              child: Text(
                'Destination',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              flex: 3,
            ),
            Expanded(
              child: Text(
                'Track',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              flex: 1,
            ),
            Expanded(
              child: Text(
                'Status',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              flex: 1,
            ),
          ],
        ),
      ],
    );
  }

  _buildDeparture(BuildContext context, Train train) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Text(
                formatDate(train.departTime, [hh, ':', nn]),
                style: Theme.of(context).textTheme.bodyText2,
              ),
              flex: 1,
            ),
            Expanded(
              child: Text(
                train.destination,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              flex: 3,
            ),
            Expanded(
              child: Text(
                train.track,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              flex: 1,
            ),
            Expanded(
              child: Text(
                train.status,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              flex: 1,
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
