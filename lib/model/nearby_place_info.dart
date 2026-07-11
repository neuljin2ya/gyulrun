class NearbyPlaceInfo {
  const NearbyPlaceInfo({
    required this.name,
    required this.address,
    this.imageUrl,
  });

  final String name;
  final String address;
  final String? imageUrl;
}
