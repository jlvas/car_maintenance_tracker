import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../utilities/dataObject/car.dart';

class CarHistory extends StatefulWidget {
  static const routeName = '/screens/car_history';
  const CarHistory({Key? key}) : super(key: key);

  @override
  State<CarHistory> createState() => _CarHistoryState();
}

class _CarHistoryState extends State<CarHistory> {

  @override
  Widget build(BuildContext context) {
    final car = Provider.of<Car>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Car History'),
      ),
      body: car.serviceList.isEmpty
          ? const Center(child: Text('There is no History'))
          : ListView.builder(
              itemCount: car.serviceList.length,
              itemBuilder: (context, index) {
                return Slidable(

                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context){
                          car.serviceList.removeAt(index);
                          car.writeFile(car);
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      SlidableAction(
                        onPressed: (context){
                          car.serviceList[index].hasBeenDone = true;
                          car.writeFile(car);
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
                        'Maintenance: ${car.serviceList[index].serviceName}'),
                    subtitle:car.serviceList[index].hasBeenDone
                        ? Text('Car Mileage: ${car.currentMileage}')
                        : const Text('Not Repaired Yet'),
                    trailing: car.serviceList[index].hasBeenDone
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
