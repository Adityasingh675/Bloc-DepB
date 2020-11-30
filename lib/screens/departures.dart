import 'dart:ui';

import 'package:bloc_departure/models/train.dart';
import 'package:bloc_departure/providers/septa_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Departures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SeptaProvider>(context).bloc;
    return Scaffold(
      appBar: AppBar(
        title: Text('Station'),
        actions: [
          FlatButton(
            child: Text(
              'Change',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            onPressed: () {
              // TODO To Settings
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
            return ListView.builder(
              itemCount: snapshot.data.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildHeader(context);
                } else {
                  return Container();
                }
              },
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
          height: 10.0,
        ),
        Row(
          children: [
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Text(
                'Time',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              flex: 1,
            ),
            Expanded(
              child: Text(
                'Destination',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              flex: 3,
            ),
            Expanded(
              child: Text(
                'Time',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              flex: 1,
            ),
            Expanded(
              child: Text(
                'Time',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              flex: 1,
            ),
          ],
        ),
      ],
    );
  }
}
