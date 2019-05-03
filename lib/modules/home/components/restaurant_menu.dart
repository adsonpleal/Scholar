import 'package:app_tcc/models/restaurant.dart';
import 'package:flutter/widgets.dart';

import 'menu_item.dart';

class RestaurantMenu extends StatelessWidget {
  final Restaurant restaurant;
  final _pageController = PageController();

  RestaurantMenu({Key key, this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (restaurant == null) return Container();
    final hasDinner = restaurant.menuDinner != null;
    final height = MediaQuery.of(context).size.height - 190;
    return Column(
      children: <Widget>[
        Visibility(
          visible: hasDinner,
          child: Text('Toggle dinner'),
        ),
        SizedBox(
          height: height,
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            children: restaurant.menu.map((menuEntry) {
              final index = restaurant.menu.indexOf(menuEntry);
              return MenuItem(
                showNext: index != restaurant.menu.length - 1,
                showPrevious: index != 0,
                menuEntry: menuEntry,
                onNext: _showNextPage,
                onPrevious: _showPreviousPage,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showNextPage() {
    _pageController.nextPage(
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _showPreviousPage() {
    _pageController.previousPage(
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }
}
