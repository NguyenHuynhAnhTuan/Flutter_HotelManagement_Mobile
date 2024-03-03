import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/homesubscreen/Usersss.dart';
import 'package:travel_app/homesubscreen/booking.dart';
import 'package:travel_app/homesubscreen/explore.dart';
import 'package:travel_app/homesubscreen/favourites.dart';
import 'package:travel_app/homesubscreen/mytrip.dart';
import 'package:travel_app/homesubscreen/profile.dart';
import 'package:travel_app/providers/global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _showTripPageIndex = 0;

  int _currentIndex = 0;

  final List<Widget> _screenoption = <Widget>[
    const Explorepage(),
    const Bookingpage(),
    const Mytrippage(),
    // const Favouritepage(),
    const Profilepage(),
    // const Usersss(),
  ];

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }
  
  int? getCurrentIndex(int value) {
    if(value == 0) {
      return _currentIndex;
    }
    else {
      _currentIndex = value;
    }
  }

  @override
  Widget build(BuildContext context) {

    final getArgumentToGoToTripPage = ModalRoute.of(context)!.settings.arguments == null ? 0 : ModalRoute.of(context)!.settings.arguments as int;
    if(getArgumentToGoToTripPage != null || getArgumentToGoToTripPage != 0) {
      _showTripPageIndex = getArgumentToGoToTripPage;
    }

    // final globalProvider = Provider.of<GlobalValue>(context, listen: false);
    return Scaffold(
      // key: globalProvider.scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: const Drawer(
        elevation: 0,
        backgroundColor: Colors.white,
        shape: Border.fromBorderSide(BorderSide.none),
      ),
      body: IndexedStack(
        index: _showTripPageIndex == 0 ? _currentIndex : _showTripPageIndex,
        children: _screenoption,
      ),
      bottomNavigationBar: BottomAppBar(
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: "Explore",
              activeIcon: Icon(Icons.explore),
              icon: Icon(
                Icons.explore_outlined,
              ),
              tooltip: "Explore",
            ),
            BottomNavigationBarItem(
              label: "Rooms",
              activeIcon: Icon(Icons.book_online),
              icon: Icon(
                Icons.book_online_outlined,
              ),
              tooltip: "Rooms",
            ),
            BottomNavigationBarItem(
              label: "My Booking",
              activeIcon: Icon(Icons.home_repair_service_rounded),
              icon: Icon(
                Icons.home_repair_service_outlined,
              ),
              tooltip: "My Booking",
            ),
            // BottomNavigationBarItem(
            //   label: "Favourites",
            //   activeIcon: Icon(Icons.favorite),
            //   icon: Icon(
            //     Icons.favorite_border,
            //   ),
            //   tooltip: "Favourites",
            // ),
            BottomNavigationBarItem(
              label: "Profile",
              activeIcon: Icon(Icons.person),
              icon: Icon(
                Icons.person_outline,
              ),
              tooltip: "Profile",
            ),
            // BottomNavigationBarItem(
            //   label: "Users",
            //   activeIcon: Icon(Icons.group), // Set the desired icon for the active state
            //   icon: Icon(
            //     Icons.group_outlined, // Set the desired icon for the inactive state
            //   ),
            //   tooltip: "Users",
            // ),
          ],
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.secondary,
          selectedLabelStyle: const TextStyle(fontSize: 10),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
        ),
      ),
    );
  }
}
