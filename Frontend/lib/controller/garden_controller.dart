class GardenController {
  static final GardenController instance =
      GardenController._privateConstructor();

  GardenController._privateConstructor();

  Map<int, Map<String, dynamic>> spots = {};

  void removePlantFromSpot(int spotIndex) {
    spots.remove(spotIndex);
  }
}
