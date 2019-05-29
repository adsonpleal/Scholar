import 'dart:async';
import 'dart:convert';

import 'package:app_tcc/modules/notifications/notifications_service.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:http/http.dart' as http;
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ufsc_decoders.dart';

const _clientId = 'tccleal';
const _redirectUri = 'tccleal://tccleal.setic_oauth.ufsc.br';
const _responseType = 'code';
const _state = 'E3ZYKC1T6H2yP4z';
const _clientSecret = 'midMosocIbCenodnoiclUtItsyoirs';
const _ufscCas = 'https://sistemas.ufsc.br';
const _authorizationUrl =
    "$_ufscCas/oauth2.0/authorize?client_id=$_clientId&redirect_uri=$_redirectUri&response_type=$_responseType&state=$_state";
const _accessTokenUrl = "$_ufscCas/oauth2.0/accessToken";
const _apiUrl = 'https://ws.ufsc.br/rest/CAGRUsuarioService/';
const _userTimeGrid = 'getGradeHorarioAluno';

class UfscService {
  final UserDataRepository _userData = inject();
  final NotificationsService _notifications = inject();

  Future<void> launchAuthorization() async {
    await launch(_authorizationUrl);
    final url = await getLinksStream().first;
    final code = Uri.parse(url).queryParameters['code'];
    _fetchSubjects(code);
  }

  Uri _buildAccessTokenUri(String code) => Uri.parse(
      "$_accessTokenUrl?grant_type=authorization_code&code=$code&client_id=$_clientId&redirect_uri=$_redirectUri&client_secret=$_clientSecret");

  void dispose() {
    _notifications.dispose();
  }

  Future<dynamic> _performGet(String path, String authToken) async {
    final response = await http.get(
      "$_apiUrl$path",
      headers: {
        'Authorization': "Bearer $authToken",
      },
    );
    return json.decode(response.body);
  }

  Future<void> _fetchSubjects(String code) async {
    final accessUri = _buildAccessTokenUri(code);
    final response = await http.get(accessUri);
    final accessToken = _parseAccessToken(response.body);
    final timeGrid = await _performGet(_userTimeGrid, accessToken);
    final subjects = decodeSubjects(timeGrid);
    _userData.replaceSubjects(subjects);
    final settings = await _userData.settings;
    if (settings.allowNotifications) {
      _notifications.addNotifications(subjects);
    }
    await _userData.saveSettings(
      settings.rebuild((b) => b..restaurantId = 'trindade'),
    );
  }

  String _parseAccessToken(String str) =>
      RegExp(r"access_token=(.*)&").firstMatch(str).group(1);
}