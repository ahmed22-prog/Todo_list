import 'package:aaa/modules/archived_Tasks/archived_Task.dart';
import 'package:aaa/modules/doneTasks/doneTask.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/constants.dart';
import '../modules/new_Tasks/new_Tasks.dart';
import 'package:sqflite/sqflite.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  List<Widget> screens=[
     newtask(),
     doneTask(),
     archivedTask(),
  ];
  List<String> titles=[
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  late Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  int currentIndex=0;
  bool isBottomSheetShown = false;
  late IconData fabIcon=Icons.edit;
  var titleController =TextEditingController();
  var timeController =TextEditingController();
  var dateController =TextEditingController();
  @override
  void initState(){
    super.initState();
    createDatabase();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      body: tasks.isEmpty ? const Center(child: CircularProgressIndicator()): screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () //async
        {
          if (isBottomSheetShown)
          {
            if(formKey.currentState!.validate()){
              insertDatabase(
                title: titleController.text,
                date: dateController.text,
                time: timeController.text,
              ).then((value) {
                getDataFromDatabase(database).then((value) {
                  Navigator.pop(context);
                  setState((){
                    isBottomSheetShown=false;
                    fabIcon=Icons.edit;
                  });
                  tasks = value;
                  print(tasks);
                });
              });
            }
          }
          else
          {
            scaffoldKey.currentState?.showBottomSheet(
                  (context) => Container(
                    color: Colors.grey[100],
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            // onTap: (){
                            //   print('timing taped');
                            // },
                            keyboardType: TextInputType.text,
                            validator: ( value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                            }
                            return null;
                          },
                            controller: titleController,
                        decoration: const InputDecoration(labelText: 'task title',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title,),
                          ),
                          ),
               //        defaultFormField(
               // controller: titleController,
               // type: TextInputType.text,
               // validate: (String value){
               //   if(value.isEmpty){
               //     return 'title must not be empty';
               //   }
               //   return null;
               // },
               // label: 'task title',
               // prefix:Icons.title,),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            onTap: (){
                              showTimePicker(context: context, initialTime: TimeOfDay.now(),).then((value) {
                                setState(() {
                                  timeController.text = value!.format(context);
                                });
                                print(value?.format(context));
                              });
                            },
                            keyboardType: TextInputType.datetime,
                            validator: ( value) {
                              if (value == null || value.isEmpty) {
                                return 'time must not be empty ';
                              }
                              return null;
                            },
                            controller: timeController,
                            decoration: const InputDecoration(labelText: 'task time ',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.watch_later_outlined,),
                            ),
                          ),
                          //        defaultFormField(
                          // controller: titleController,
                          // type: TextInputType.text,
                          // validate: (String value){
                          //   if(value.isEmpty){
                          //     return 'title must not be empty';
                          //   }
                          //   return null;
                          // },
                          // label: 'task title',
                          // prefix:Icons.title,),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            onTap: (){
                        showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.parse('2022-09-29'),).then((value)
                        {
                          print(DateFormat.yMMMd().format(value!));
                          dateController.text=DateFormat.yMMMd().format(value!);
                        });
                            },
                            keyboardType: TextInputType.datetime,
                            validator: ( value) {
                              if (value == null || value.isEmpty) {
                                return 'date must not be empty ';
                              }
                              return null;
                            },
                            controller: dateController,
                            decoration: const InputDecoration(labelText: 'task date ',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_today,),
                            ),
                          ),
              ],
            ),
                    ),
                  ),
              elevation: 10.0,
            ).closed.then((value) {
              isBottomSheetShown=false;
              setState(()
              {
                fabIcon=Icons.edit;
              });
            });
            isBottomSheetShown=true;
            setState((){
              fabIcon=Icons.add;
            }
            );
          }
//           try{
//             var name = await getName();
//             print(name);
//             print('ahmed');
//             throw('error occurred');
//           }catch{
// print('error ${error.toString()}');
// //           }
//           getName().then((value) {
//             print(value);
//             print('ahmed');
//             // throw('error occurred');
//           }).catchError((error){
//            print('error is ${error.toString()}');
//           }
//           );
        },
        child :  Icon(
          fabIcon,
         ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index){
          setState((){
            currentIndex=index;
          });

        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu
          ),
            label: 'Task',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline,),
         label:'Done',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.archive_outlined,),
            label: 'Archived',
          ),

        ],
      ),
    );
  }

  // Future <String> getName() async{
  //   return 'Ahmed Samy';
  // }
  void createDatabase() async{
 database = await openDatabase('todo.db',
version: 1,
  onCreate: (database, version){
  print ('database created');
  },
  onOpen: (database){
   getDataFromDatabase(database).then((value) {
     tasks = value;
     print(tasks);
   });
    print ('database opened');
    database.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)').then((value){
      print('table created');
    }).catchError((error){
      print('error occurred when creating table ${error.toString()}');
    });
  },
);
  }
  Future insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async{
   return await database.transaction((txn) async {
      txn.rawInsert('INSERT INTO tasks(title, date, time, status)VALUES("$title","$date","$time","New")').then((value) {
        print('$value inserted successfully');
      }).catchError((error){
        print('error occurred when inserting in database ${error.toString()}');
      });
      return null;
    });
  }
  Future<List<Map>> getDataFromDatabase(database) async{
   return  await database.rawQuery('SELECT * FROM tasks');

  }
}
