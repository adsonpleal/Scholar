import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;

const MAIN_URL = 'https://cagr.sistemas.ufsc.br/relatorios/aluno';
const CURRICULAR_CONTROL = "$MAIN_URL/controleCurricular?download";
const REGISTRATION_CERTIFICATE = "$MAIN_URL/atestadoMatricula?download";
const COURSE_CURRICULUM = "$MAIN_URL/curriculoCurso?download";

class Files extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: false,
      title: Text(Strings.files),
      children: <Widget>[
        ListTile(
          title: Text(Strings.curricularControl),
          onTap: _openUrl(CURRICULAR_CONTROL),
        ),
        ListTile(
          title: Text(Strings.registrationCertificate),
          onTap: _openUrl(REGISTRATION_CERTIFICATE),
        ),
        ListTile(
          title: Text(Strings.courseCurriculum),
          onTap: _openUrl(COURSE_CURRICULUM),
        ),
      ],
    );
  }

  Function _openUrl(String url) => () async => await launch(url);
}
