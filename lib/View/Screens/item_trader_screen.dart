import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_slider/Model/hive_class.dart';

final array1Prov = StateProvider<List<int>>((ref) => []);
final array2Prov = StateProvider<List<int>>((ref) => []);

class ItemTraderScreen extends ConsumerWidget {
  const ItemTraderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final array1 = ref.watch(array1Prov);
    final array2 = ref.watch(array2Prov);

    // Load Hive data after widget has finished building
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Check if data is already loaded before initializing
      if (array1.isEmpty && array2.isEmpty) {
        final data = await HiveFunctions.readData(key: 9);
        if (data != null) {
          // Initialize arrays with data from Hive
          ref.read(array1Prov.notifier).state = List<int>.from(data[0]);
          ref.read(array2Prov.notifier).state = List<int>.from(data[1]);
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[200], // Light grey background
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildColumn(array1, (item) async {
              ref.read(array1Prov.notifier).state = List.from(array1)..remove(item);
              ref.read(array2Prov.notifier).state = List.from(array2)..add(item);
              await HiveFunctions.saveData(key: 9, value: [array1, array2]);
              print("SWAPPED!");
            }),
            const SizedBox(width: 50), // Space between columns
            buildColumn(array2, (item) async {
              ref.read(array2Prov.notifier).state = List.from(array2)..remove(item);
              ref.read(array1Prov.notifier).state = List.from(array1)..add(item);
              await HiveFunctions.saveData(key: 9, value: [
                ref.watch(array1Prov), ref.watch(array2Prov)]);
              print("SWAPPED!");
            }),
          ],
        ),
      ),
    );
  }


  Widget buildColumn(List<int> items, void Function(int) onItemTap) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => onItemTap(item),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 60.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                item.toString(),
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
