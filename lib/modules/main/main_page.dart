import 'package:app_tcc/modules/agenda/agenda_page.dart';
import 'package:app_tcc/modules/home/home_page.dart';
import 'package:app_tcc/modules/main/main_bloc.dart';
import 'package:app_tcc/modules/main/main_state.dart';
import 'package:app_tcc/modules/profile/profile_page.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/routes.dart' as Routes;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final MainBloc _mainBloc = inject();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _mainBloc,
        builder: (context, MainState state) {
          if (state.settings == null) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state.settings.connected) {
            return Scaffold(
                body: _currentPage(),
                bottomNavigationBar: BottomNavigationBar(
                  items: tabs.map((tab) => tab.asNavItem()).toList(),
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ));
          }
          return Scaffold(
            body: tabs.last.page(),
          );
        });
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
    }
  }

  @override
  void dispose() {
    _mainBloc.dispose();
    super.dispose();
  }
}
