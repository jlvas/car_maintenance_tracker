import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:current_location/utilities/services/file_controller.dart';

class CarHistory extends StatefulWidget {
  static const routeName = '/screens/car_history';
  const CarHistory({Key? key}) : super(key: key);

  @override
  State<CarHistory> createState() => _CarHistoryState();
}

class _CarHistoryState extends State<CarHistory> {
  // List<String> testingList = ['test 1', 'test 2', 'test 3', 'test 4', 'test 5', 'test 6', 'test 7', 'test 8', 'test 9'];

  @override
  Widget build(BuildContext context) {
    final fileController = Provider.of<FileController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Car History'),
      ),
      body: fileController.car.serviceList.isEmpty
          ? const Center(child: Text('There is no History'))
          : ListView.builder(
              itemCount: fileController.car.serviceList.length,
              itemBuilder: (context, index) {
                return Slidable(

                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context){
                          fileController.car.serviceList.removeAt(index);
                          fileController.write();
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      SlidableAction(
                        onPressed: (context){
                          fileController.car.serviceList[index].hasBeenDone = true;
                          fileController.write();
                        },
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.check,
                        label: 'Completed',
                      ),
                    ],
                  ),
                  child: ListTile(
                    enabled: true,
                    leading: const Icon(
                      Icons.car_repair,
                    ),
                    title: Text(
                        'Maintenance: ${fileController.car.serviceList[index].serviceName}'),
                    subtitle: fileController.car.serviceList[index].hasBeenDone
                        ? Text('Car Mileage: ${fileController.car.currentMileage}')
                        : const Text('Not Repaired Yet'),
                    trailing: fileController.car.serviceList[index].hasBeenDone
                        ? const Icon(Icons.done_outline_sharp,
                            color: Colors.blue)
                        : const Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                          ),
                  ),
                );
              },
            ),
    );
  }
}
