import 'package:app_tcc/models/subject.dart';
import 'package:flutter/material.dart';

class SubjectItem extends StatelessWidget {
  final Subject subject;
  final Function onAdd;
  final Function onRemove;

  const SubjectItem({
    Key key,
    this.subject,
    this.onAdd,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                subject.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 22.0),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Faltas ${subject.absenceCount}/${subject.maxAbsence}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 22.0),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove),
                    tooltip: 'Remover uma falta',
                    onPressed: onRemove,
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    tooltip: 'Adicionar uma falta',
                    onPressed: onAdd,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
