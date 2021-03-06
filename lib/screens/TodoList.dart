import 'package:Todos/common/colors.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
// import 'package:todo_app_production/navigation_service.dart';
import '../providers/todo_provider.dart';

import '../models/todo_model.dart';

class TodoList extends StatefulWidget {
  final List<Todos> todo;
  final Function deleteTd;

  TodoList(this.todo, this.deleteTd);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  void initState() {
    Provider.of<TodoProvider>(context, listen: false).getTodos();
    super.initState();
  }

  void _showSnackBar() {
    Get.snackbar(
      'Todo has been deleted',
      '',
      backgroundColor: AppColors.primaryColor,
      dismissDirection: SnackDismissDirection.HORIZONTAL,
      duration: Duration(seconds: 1),
      snackPosition: SnackPosition.BOTTOM,
      colorText: AppColors.lightBlueColor,
      animationDuration: Duration(seconds: 1),
      isDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                return todoProvider.todoListItems.isEmpty
                    ? Center(
                        child: Text('Add your Todo',
                            style: TextStyle(
                                color: Color(0xff1e88e5),
                                fontWeight: FontWeight.bold,
                                fontSize: 30)))
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: todoProvider.todoListItems.length,
                        itemBuilder: (ctx, index) {
                          return Card(
                            color: AppColors.primaryColor,
                            shadowColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            elevation: 5,
                            margin: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 5,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.lightBlueColor,
                                radius: 30,
                                child: Padding(
                                  padding: EdgeInsets.all(6),
                                  child: FittedBox(
                                    child: Text(
                                      todoProvider.todoListItems[index].title !=
                                              ""
                                          ? '${todoProvider.todoListItems[index].title.substring(0, 1).toUpperCase()}'
                                          : "~",
                                      style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 25),
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                todoProvider.todoListItems[index].title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.lightBlueColor),
                              ),
                              subtitle: Text(
                                '${todoProvider.todoListItems[index].date}',
                                // DateFormat.yMd().format(todo[index].date),
                                style:
                                    TextStyle(color: AppColors.lightBlueColor),
                              ),
                              trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: AppColors.lightBlueColor,
                                  ),
                                  onPressed: () {
                                    widget.deleteTd(
                                        todoProvider.todoListItems[index].id);
                                    _showSnackBar();
                                  }),
                            ),
                          );
                        },
                      );
              },
            ),
    );
  }
}
