// import 'package:travel_app/Service/UserService.dart';
// import 'package:travel_app/models/UserDto.dart';
// import 'package:flutter/material.dart';
//
// class Usersss extends StatefulWidget {
//   const Usersss({super.key});
//   @override
//   _UsersssState createState() => _UsersssState();
// }
//
// class _UsersssState extends State<Usersss> {
//   final UserService userService = UserService();
//   late Future<List<UserDto>> users;
//
//   @override
//   void initState() {
//     super.initState();
//     users = userService.getAllUsers();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User List'),
//       ),
//       body: FutureBuilder<List<UserDto>>(
//         future: users,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 UserDto user = snapshot.data![index];
//                 return ListTile(
//                   title: Text(user.username),
//                   subtitle: Text(user.email),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }