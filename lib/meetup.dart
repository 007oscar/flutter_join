import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Meetup {
  String nombre;
  String creatorId;
  String descripcion;
  Timestamp fecha;
  GeoPoint ubicacion;

  Meetup(this.nombre, this.creatorId, this.descripcion, this.fecha, this.ubicacion);
}

class MeetupRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meetups")),
      body: MeetupList(),
    );
  }
}

class MeetupList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('meetups').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['nombre']),
                  subtitle: new Text(document['descripcion']),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeetupDetails(document['nombre'], document['descripcion'])
                        )
                    );
                  }
                );
              }).toList(),
            );
        }
      },
    );
  }

  MeetupList();
}

class MeetupDetails extends StatelessWidget {
  String name;
  String descripcion;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meetup details')),
      body: Column(children: <Widget>[
        Text(this.name),
        Text(this.descripcion),
        Row(children: <Widget>[
          RaisedButton(
            onPressed: () => {},
            child: Text(
                'Asistiré',
            ),
          ),
          RaisedButton(
            onPressed: () => {},
            child: Text(
              'No asistiré',
            ),
          ),
        ])
      ])
    );
  }

  MeetupDetails(this.name, this.descripcion);
}