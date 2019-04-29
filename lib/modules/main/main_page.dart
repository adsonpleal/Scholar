import 'package:app_tcc/modules/agenda/agenda_page.dart';
import 'package:app_tcc/modules/home/home_page.dart';
import 'package:app_tcc/modules/profile/profile_page.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/routes.dart' as Routes;
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// TODO: refactor this file to use blocs
class Tab {
  final String title;
  final Widget Function() page;
  final String route;
  final IconData icon;

  const Tab({this.icon, this.title, this.page, this.route});

  BottomNavigationBarItem asNavItem() =>
      BottomNavigationBarItem(icon: Icon(icon), title: Text(title));
}

final tabs = [
  Tab(
    page: HomePage.instantiate,
    title: Strings.home,
    route: Routes.home,
    icon: Icons.home,
  ),
  Tab(
    page: AgendaPage.instantiate,
    title: Strings.agenda,
    route: Routes.agenda,
    icon: Icons.date_range,
  ),
  Tab(
    page: ProfilePage.instantiate,
    title: Strings.profile,
    route: Routes.profile,
    icon: Icons.person,
  ),
];

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin, RouteAware {
  final FirebaseAnalyticsObserver _observer = inject();
  final _firebaseMessaging = FirebaseMessaging();
  int _selectedIndex = 0;

  @override
  void initState() {
    _firebaseMessaging.configure(
      onResume: _processNotificationClick,
      onLaunch: _processNotificationClick,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _observer.subscribe(this, ModalRoute.of(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: tabs.map((tab) => tab.asNavItem()).toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> _processNotificationClick(Map<String, dynamic> message) async {
    final data = message['data'] ?? {};
    final destination = data['destination'];
    final index = tabs.indexWhere((tab) => tab.route == destination);
    if (index != -1) {
      _onItemTapped(index);
    }
  }

  _currentPage() => Stack(
        children: tabs.map((tab) {
          final isSelected = tabs.indexOf(tab) == _selectedIndex;
          return IgnorePointer(
            ignoring: !isSelected,
            child: Opacity(
              opacity: isSelected ? 1 : 0,
              child: tab.page(),
            ),
          );
        }).toList(),
      );

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _sendCurrentTabToAnalytics();
    }
  }

  @override
  void dispose() {
    _observer.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _sendCurrentTabToAnalytics();
  }

  @override
  void didPopNext() {
    _sendCurrentTabToAnalytics();
  }

  void _sendCurrentTabToAnalytics() {
    _observer.analytics.setCurrentScreen(
      screenName: 'mainPage${tabs[_selectedIndex].route}',
    );
  }
}
