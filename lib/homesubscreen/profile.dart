import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_app/Service/UserService.dart';
import 'package:travel_app/models/UserDto.dart';
import 'package:travel_app/realm/realm_services.dart';
import 'package:travel_app/screens/logiinscreen.dart';
import 'package:travel_app/screens/notificationscreen.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  bool loading = false;
  bool isLogin = false;
  UserDto? _loggedInUser;


  void isuserLogin() async {
    final realmServices = Provider.of<RealmServices>(context, listen: false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? logintoken = prefs.getString('userloginornot');

    if (logintoken != null &&
        realmServices.currentUser != null &&
        realmServices.currentUser!.provider != AuthProviderType.anonymous) {
      // If logged in, get the loggedInUser details
      _loggedInUser = UserService.loggedInUser;

      setState(() {
        isLogin = _loggedInUser != null; // Update isLogin based on loggedInUser
      });

      if (_loggedInUser != null) {
        // You can use the loggedInUser data as needed
        print('Loggedd in user: ${_loggedInUser!.username}');
      }
    } else {
      setState(() {
        isLogin = false;
      });
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> _logOut() async {
    final realmServices = Provider.of<RealmServices>(context, listen: false);
    await realmServices.logout();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("userloginornot");

    // After logging out, set isLogin to false
    setState(() {
      UserService.isLogins = false;
      _loggedInUser = null;
      isLogin = false;
    });
  }

  Future<void> _fetchLoginUser() async {
    try {
      // Fetch the user details without logging in again
      _loggedInUser = UserService.loggedInUser;

      setState(() {
        if (_loggedInUser != null) {
          print("_loggedInUser username: ${_loggedInUser?.username}");
        } else {
          print("_loggedInUser is null");
        }
      });
    } catch (e) {
      print("Error fetching logged-in user data: $e");
    }
  }

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    _fetchLoginUser();
    isuserLogin();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : UserService.isLogins
          ? SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 19, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 34,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Profile",
                              style: TextStyle(
                                fontSize: 27,
                                fontFamily: "Roboto",
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) {
                                    return const NotificationScreen();
                                  },
                                ));
                              },
                              icon: const Icon(
                                Icons.notifications,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.pink,
                                          maxRadius: 25,
                                          minRadius: 25,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _loggedInUser?.username ?? "Guest",
                                                style: TextStyle(fontSize: 17),
                                              ),
                                              // Text(
                                              //   "Show profile",
                                              //   style: TextStyle(fontFamily: "Quicksand"),
                                              // ),
                                              Text(
                                                _loggedInUser?.email ?? "N/A",
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Text(
                                                _loggedInUser?.phone ?? "N/A",
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        )

                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 26,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        Container(
                          height: 1,
                          color: Colors.grey[200]!,
                        ),
                        SizedBox(
                          height: 140,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Card(
                              shadowColor: Colors.white,
                              surfaceTintColor:
                                  const Color.fromRGBO(102, 221, 111, 0.3),
                              child: Container(),
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey[200]!,
                        ),
                        InkWell(
                          onTap: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shadowColor: Colors.white,
                                  title: const Text(
                                    "Are you sure you want logout?",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("NO")),
                                    TextButton(
                                        onPressed: () async {
                                          await _logOut();
                                          await Future.delayed(const Duration(seconds: 1));
                                          if (!context.mounted) return;
                                          Navigator.of(context).pop();

                                          // Navigate to LoginScreen after logging out
                                          Navigator.of(context).pushReplacement(
                                            CupertinoModalPopupRoute(
                                              builder: (context) {
                                                return const LoginScreen();
                                              },
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "YES",
                                          style: TextStyle(color: Colors.red),
                                        )),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Padding(
                            padding:
                                EdgeInsets.only(top: 20, left: 5, bottom: 20),
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "Logout",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Quicksand",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey[200]!,
                        ),
                      ],
                    ),
                  ))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 19, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text('Username: '),
                        // Text('Email: ${_loggedInUser?.email ?? "N/A"}'),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          _loggedInUser?.username ?? "Guest",
                          style: TextStyle(
                            fontSize: 27,
                            fontFamily: "Roboto",
                          ),
                        ),
                        const Text("Login to start planning your next trip."),
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: TextButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: Colors.orange,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onPressed: isLogin
                                ? () {
                                    // Handle profile or other actions for logged-in user
                                  }
                                : () {
                                    Navigator.of(context).push(
                                      CupertinoModalPopupRoute(
                                        builder: (context) {
                                          return const LoginScreen();
                                        },
                                      ),
                                    );
                                  },
                            child: Text(
                              isLogin ? "Profile" : "Login",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
