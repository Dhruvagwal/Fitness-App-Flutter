import 'package:flutter/material.dart';
import 'package:xrun/shared/colors.dart';

class MarathonCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String image;
  final Function() onTap;
  const MarathonCard({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: xrunBlue.withOpacity(0.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.asset(
                  image,
                  height: 150,
                  width: 300,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: xrunWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: xrunWhite,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        date,
                        style: const TextStyle(
                          color: xrunWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: xrunWhite,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        location,
                        style: const TextStyle(
                          color: xrunWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
