import 'package:app_tcc/modules/agenda/agenda_page.dart';
import 'package:app_tcc/modules/home/home_page.dart';
import 'package:app_tcc/modules/profile/profile_page.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class Tab {
  final String title;
  final Function page;
  final String route;
  final IconData icon;

  const Tab({this.icon, this.title, this.page, this.route});

  asNavItem() => BottomNavigationBarItem(icon: Icon(icon), title: Text(title));
}

const tabs = [
  Tab(
      page: HomePage.instantiate,
      title: Strings.home,
      route: "home",
      icon: Icons.home),
  Tab(
      page: AgendaPage.instantiate,
      title: Strings.agenda,
      route: "agenda",
      icon: Icons.date_range),
  Tab(
      page: ProfilePage.instantiate,
      title: Strings.profile,
      route: "profile",
      icon: Icons.person),
];

class MainPage extends StatefulWidget {
  final FirebaseAnalyticsObserver _observer;

  const MainPage(this._observer);

  @override
  _MainPageState createState() => _MainPageState(_observer);
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin, RouteAware {
  final FirebaseAnalyticsObserver _observer;
  int _selectedIndex = 0;

  _MainPageState(this._observer);

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

  _currentPage() => tabs[_selectedIndex].page();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _sendCurrentTabToAnalytics();
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
      screenName: 'mainPage/${tabs[_selectedIndex].route}',
    );
  }
}
