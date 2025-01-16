import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xrun/shared/action_builder.dart';
import 'package:xrun/shared/cards/marathon_card.dart';
import 'package:xrun/shared/colors.dart';
import 'package:xrun/shared/components/view_all_component.dart';

class HomeScreenListView extends StatelessWidget {
  const HomeScreenListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Happy to see you , Ronex',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: xrunWhite,
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                      ),
                    ),
                    const SizedBox(height: 15),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Run',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: xrunBlue,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.085,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                          ),
                          TextSpan(
                            text: ' your Way\nStay ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: xrunWhite,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.085,
                            ),
                          ),
                          TextSpan(
                            text: 'Fit & Healthy',
                            style: TextStyle(
                              color: xrunBlue,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.085,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: xrunLightGreen,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: xrunBlue,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.notifications,
                        color: xrunWhite,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: xrunLightGreen,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: xrunBlue,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.settings,
                        color: xrunWhite,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ActionBuilder(
                    onTap: () {},
                    icon: Icons.event,
                    label: 'Events',
                  ),
                  const SizedBox(width: 15),
                  ActionBuilder(
                    onTap: () {},
                    icon: Icons.list_alt,
                    label: 'Results',
                  ),
                  const SizedBox(width: 15),
                  ActionBuilder(
                    onTap: () {},
                    icon: Icons.person,
                    label: 'Coaches',
                  ),
                  const SizedBox(width: 15),
                  ActionBuilder(
                    onTap: () {},
                    icon: Icons.fitness_center,
                    label: 'Trainers',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            ViewAllComponent(
              eventTitle: 'Marathon Events',
              buttonText: 'View all',
              onTap: () {},
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  MarathonCard(
                    onTap: () {},
                    title: 'Full Marathon',
                    date: '18 Dec 2024',
                    location: 'Malta, Valletta',
                    image: 'assets/home/girl.png',
                  ),
                  const SizedBox(width: 15),
                  MarathonCard(
                    onTap: () {},
                    title: 'Half Marathon',
                    date: '18 Dec 2024',
                    location: 'Malta, Valletta',
                    image: 'assets/home/girl.png',
                  ),
                  const SizedBox(width: 15),
                  MarathonCard(
                    onTap: () {},
                    title: 'Half Marathon',
                    date: '18 Dec 2024',
                    location: 'Malta, Valletta',
                    image: 'assets/home/girl.png',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            ViewAllComponent(
              eventTitle: 'Hyrox',
              buttonText: 'View all',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
