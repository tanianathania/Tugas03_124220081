class Anime{
  final int id;
  final String name;
  final String tittle;
  final String imageUrl;
  final String familyCreator;

  Anime({
    required this.id,
    required this.name,
    required this.tittle,
    required this.imageUrl,
    required this.familyCreator, 
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json ['id'] ?? 0, //kalo misal datanya nol kasih ?? 0
      name: json ['name'] ?? "", 
      tittle: json ['tittle'] ?? "",
      imageUrl: (json ['images'] != null && json ['images'].isNotEmpty) ? 
        json['images'] [0] : 'https://placehold.co/600x400', 
      familyCreator: (json ['family'] != null) ? 
        (json['family']['creator'] ?? 
          "Family Creator Empty") : "gaada keluarga"
    );
  }
}
