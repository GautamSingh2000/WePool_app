class PlaceSuggestionDto {
  final String description;
  final String placeId;

  PlaceSuggestionDto({required this.description, required this.placeId});

  factory PlaceSuggestionDto.fromJson(Map<String, dynamic> json) {
    return PlaceSuggestionDto(
      description: json['description'],
      placeId: json['place_id'],
    );
  }
}
