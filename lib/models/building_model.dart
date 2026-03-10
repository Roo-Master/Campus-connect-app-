
class BuildingModel {
  final String id;
  final String name;
  final String code;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final List<String> facilities;
  final String openingTime;
  final String closingTime;
  final bool isAccessible;
  final int floors;
  final List<RoomModel> rooms;

  BuildingModel({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.facilities,
    required this.openingTime,
    required this.closingTime,
    required this.isAccessible,
    required this.floors,
    required this.rooms,
  });

  // Mock Data
  static List<BuildingModel> getMockBuildings() {
    return [
      BuildingModel(
        id: 'b001',
        name: 'School of Law',
        code: 'SOL',
        description: 'Law School Lecture Halls Location',
        imageUrl: '',
        latitude: 40.7128,
        longitude: -74.0060,
        facilities: ['Classrooms', 'Labs', 'Faculty Offices', 'Washrooms'],
        openingTime: '7:00 AM',
        closingTime: '9:00 PM',
        isAccessible: true,
        floors: 4,
        rooms: [
          RoomModel(id: 'LH27', number: '27', floor: 0, type: 'Lecture Hall', capacity: 60),
          RoomModel(id: 'LH20', number: '20', floor: 1, type: 'Lecture Hall', capacity: 30),
          RoomModel(id: 'LH26', number: '26', floor: 0, type: 'Lecture Hall', capacity: 100),
          RoomModel(id: 'LH25', number: '25', floor: 0, type: 'Lecture Hall', capacity: 15),
        ],
      ),
      BuildingModel(
        id: 'b002',
        name: 'Tuition Complex',
        code: 'TC',
        description: 'The TC building Block Lecture Halls',
        imageUrl: '',
        latitude: 40.7130,
        longitude: -74.0062,
        facilities: ['Practical Labs', 'Lecture Halls', 'Student Meeting Areas'],
        openingTime: '7:00 AM',
        closingTime: '10:00 PM',
        isAccessible: true,
        floors: 3,
        rooms: [
          RoomModel(id: 'TCG1', number: 'TCG1', floor: 0, type: 'Chemistry Practical Lab', capacity: 50),
          RoomModel(id: 'TCG2', number: 'TCG2', floor: 0, type: 'Lecture Hall', capacity: 40),
          RoomModel(id: 'TCG3', number: 'TCG3', floor: 0, type: 'Chemistry Practical Lab', capacity: 80),
          RoomModel(id: 'TCG4', number: 'TCG4', floor: 0, type: 'Lecture Hall', capacity: 50),
          RoomModel(id: 'TCG5', number: 'TCG5', floor: 0, type: 'Lecture Hall', capacity: 40),
          RoomModel(id: 'TC11', number: 'TC11', floor: 1, type: 'Lecture Hall', capacity: 80),
          RoomModel(id: 'TC12', number: 'TC12', floor: 1, type: 'Lecture Hall', capacity: 50),
          RoomModel(id: 'TC13', number: 'TC13', floor: 1, type: 'Lecture Hall', capacity: 40),
          RoomModel(id: 'TC14', number: 'TC14', floor: 1, type: 'Lecture Hall', capacity: 80),
          RoomModel(id: 'TC15', number: 'TC15', floor: 1, type: 'Lecture Hall', capacity: 50),
          RoomModel(id: 'TC21', number: 'TC21', floor: 2, type: 'Lecture Hall', capacity: 40),
          RoomModel(id: 'TC22', number: 'TC22', floor: 2, type: 'Lecture Hall', capacity: 80),
          RoomModel(id: 'TC23', number: 'TC23', floor: 2, type: 'Lecture Hall', capacity: 50),
          RoomModel(id: 'TC24', number: 'TC24', floor: 2, type: 'Lecture Hall', capacity: 40),
          RoomModel(id: 'TC25', number: 'TC25', floor: 2, type: 'Lecture Hall', capacity: 80),
          RoomModel(id: 'TC31', number: 'TC31', floor: 3, type: 'Lecture Hall', capacity: 50),
          RoomModel(id: 'TC32', number: 'TC32', floor: 3, type: 'Lecture Hall', capacity: 40),
          RoomModel(id: 'TC33', number: 'TC33', floor: 3, type: 'Lecture Hall', capacity: 80),
          RoomModel(id: 'TC34', number: 'TC34', floor: 3, type: 'Lecture Hall', capacity: 50),
          RoomModel(id: 'TC35', number: 'TC35', floor: 3, type: 'Lecture Hall', capacity: 40),
          RoomModel(id: 'TC41', number: 'TC41', floor: 4, type: 'Lecture Hall', capacity: 80),
          RoomModel(id: 'TC42', number: 'TC42', floor: 4, type: 'Lecture Hall', capacity: 50),
          RoomModel(id: 'TC43', number: 'TC43', floor: 4, type: 'Lecture Hall', capacity: 40),
          RoomModel(id: 'TC44', number: 'TC44', floor: 4, type: 'Lecture Hall', capacity: 80),
        ],
      ),
      BuildingModel(
        id: 'b003',
        name: 'Main Library',
        code: 'Library',
        description: '',
        imageUrl: '',
        latitude: 40.7135,
        longitude: -74.0058,
        facilities: ['Reading Rooms', 'Digital Library', 'Discussion Rooms', 'Cafe'],
        openingTime: '8:00 AM',
        closingTime: '11:00 PM',
        isAccessible: true,
        floors: 3,
        rooms: [],
      ),
      BuildingModel(
        id: 'b004',
        name: 'Student Center',
        code: 'SC',
        description: 'Hub for student activities, clubs, and recreation',
        imageUrl: '',
        latitude: 40.7140,
        longitude: -74.0065,
        facilities: ['Food Court', 'Game Room', 'Club Rooms', 'Auditorium'],
        openingTime: '8:00 AM',
        closingTime: '12:00 AM',
        isAccessible: true,
        floors: 3,
        rooms: [],
      ),
      BuildingModel(
        id: 'b005',
        name: 'Chancellors Pavilion',
        code: 'PV',
        description: 'Chancellors Kisii university stadium view point',
        imageUrl: '',
        latitude: 40.7145,
        longitude: -74.0070,
        facilities: ['Lectures ', 'Event Hosting', 'Sports viewing'],
        openingTime: '6:00 AM',
        closingTime: '10:00 PM',
        isAccessible: true,
        floors: 3,
        rooms: [

          RoomModel(id: 'PVG', number: 'PVG', floor: 0, type: 'Lecture Hall', capacity: 100),
          RoomModel(id: 'PV1', number: 'PV1', floor: 1, type: 'Lecture Hall', capacity: 100),
          RoomModel(id: 'PV2', number: 'PV2', floor: 2, type: 'Lecture Hall', capacity: 100),
        ],
      ),
      BuildingModel(
        id: 'b006',
        name: 'ICT Block A',
        code: 'Block A',
        description: 'ICT block for School of Information Science and Technology (SIST)',
        imageUrl: '',
        latitude: 40.7140,
        longitude: -74.0065,
        facilities: ['Lecture Halls', 'COD Office (sist)', 'Lecture Lounge', 'Student Meetings'],
        openingTime: '8:00 AM',
        closingTime: '12:00 AM',
        isAccessible: true,
        floors: 3,
        rooms: [
          RoomModel(id: '', number: '', floor: 0, type: 'Lecture Hall', capacity: 100),
          RoomModel(id: '', number: '', floor: 1, type: 'Lecture Hall', capacity: 100),
          RoomModel(id: '', number: '', floor: 2, type: 'Lecture Hall', capacity: 100),
        ],
      ),
    ];
  }
}

class RoomModel {
  final String id;
  final String number;
  final int floor;
  final String type;
  final int capacity;

  RoomModel({
    required this.id,
    required this.number,
    required this.floor,
    required this.type,
    required this.capacity,
  });
}