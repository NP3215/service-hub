import 'package:flutter/material.dart';

import '../models/workshop_models.dart';
import '../services/workshop_services.dart';
import '../widgets/category_chip.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/home_header.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/section_header.dart';
import '../widgets/workshop_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WorkshopService workshopService = WorkshopService();
  List<WorkshopModel> workshops = [];
  List<WorkshopModel> filteredWorkshops = [];
  bool isLoading = true;

  String selectedCategory = "Semua";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    loadWorkshops();
  }

  Future<void> loadWorkshops() async {
    try {
      workshops = await workshopService.getWorkshops();

      filteredWorkshops = workshops;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  void applyFilters() {
    List<WorkshopModel> result = [...workshops];

    if (selectedCategory == "Populer") {
      result = result.where((w) => w.badge.toLowerCase() == "populer").toList();
    }

    if (selectedCategory == "Terdekat") {
      result.sort((a, b) => a.distance.compareTo(b.distance));
    }

    if (searchQuery.isNotEmpty) {
      result = result.where((w) {
        return w.name.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    setState(() {
      filteredWorkshops = result;
    });
  }

  void searchWorkshops(String query) {
    searchQuery = query;
    applyFilters();
  }

  void filterWorkshops(String category) {
    selectedCategory = category;
    applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F8),

      bottomNavigationBar: const CustomBottomNav(selectedIndex: 0),

      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : workshops.isEmpty
            ? const Center(child: Text("No workshops found"))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const HomeHeader(showBackButton: false),
                    SearchBarWidget(onSearch: searchWorkshops),
                    CategoryChips(
                      selectedCategory: selectedCategory,
                      onCategorySelected: filterWorkshops,
                    ),
                    const SectionHeader(),

                    ...filteredWorkshops.map(
                      (workshop) => WorkshopCard(workshop: workshop),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
