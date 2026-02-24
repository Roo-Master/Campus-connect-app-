import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/building_model.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<BuildingModel> _buildings = BuildingModel.getMockBuildings();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredBuildings = _buildings.where((building) {
      if (_searchQuery.isEmpty) return true;
      return building.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          building.code.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Map'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.my_location),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search buildings, rooms...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                // Map Placeholder
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.grey.shade200,
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.map,
                                size: 80,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Interactive Map',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Integrate Google Maps SDK',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Building markers
                        ..._buildings.map((building) => Positioned(
                          left: 50.0 + _buildings.indexOf(building) * 60.0,
                          top: 80.0 + _buildings.indexOf(building) * 40.0,
                          child: GestureDetector(
                            onTap: () => _showBuildingDetails(context, building),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                // Buildings List
                Container(
                  width: 200,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        color: Colors.grey.shade100,
                        child: const Text(
                          'Buildings',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredBuildings.length,
                          itemBuilder: (context, index) {
                            final building = filteredBuildings[index];
                            return ListTile(
                              title: Text(building.name),
                              subtitle: Text(building.code),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                              ),
                              onTap: () => _showBuildingDetails(context, building),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.directions),
        label: const Text('Navigate'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _showBuildingDetails(BuildContext context, BuildingModel building) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Center(
                        child: Container(
                        width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.business,
                              color: AppTheme.primary,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  building.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  building.code,
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        building.description,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 20),
                      _buildInfoRow(Icons.access_time, 'Hours',
                          '${building.openingTime} - ${building.closingTime}'),
                      _buildInfoRow(
                          Icons.layers, 'Floors', '${building.floors} floors'),
                      _buildInfoRow(Icons.accessible, 'Accessible',
                          building.isAccessible ? 'Yes' : 'No'),
                      const SizedBox(height: 16),
                      const Text(
                        'Facilities',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: building.facilities
                            .map((facility) => Chip(
                          label: Text(facility),
                          backgroundColor: Colors.grey.shade100,
                        ))
                            .toList(),
                      ),
                      if (building.rooms.isNotEmpty) ...[
                  const SizedBox(height: 16),
              const Text(
              'Rooms',
              style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              ),
              ),
              const SizedBox(height: 8),
              ...building.rooms.map((room) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
              leading: const Icon(Icons.meeting_room),
              title: Text('${room.type} ${room.number}'),
              subtitle: Text('Floor ${room.floor} • Capacity: ${room.capacity}'),
                trailing: const Icon(Icons.directions),
                onTap: () {},
              ),
              )),
                      ],
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.directions),
                                label: const Text('Get Directions'),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.share),
                                label: const Text('Share Location'),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ),
              );
            },
        ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}