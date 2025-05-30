class Film {
  final String id;
  final String title;
  final String releaseDate;
  final String imgUrl;
  final String rating;
  final List<String> genre;
  final String createdAt;
  final String description;
  final String director;
  final List<String> cast;
  final String language;
  final String duration;

  Film({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.imgUrl,
    required this.rating,
    required this.genre,
    required this.createdAt,
    required this.description,
    required this.director,
    required this.cast,
    required this.language,
    required this.duration,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      releaseDate: json['release_date'] ?? '',
      imgUrl: json['imgUrl'] ?? '',
      rating: json['rating'].toString(),
      genre: List<String>.from(json['genre'] ?? []),
      createdAt: json['created_at'] ?? '',
      description: json['description'] ?? '',
      director: json['director'] ?? '',
      cast: List<String>.from(json['cast'] ?? []),
      language: json['language'] ?? '',
      duration: json['duration'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'release_date': releaseDate,
      'imgUrl': imgUrl,
      'rating': rating,
      'genre': genre,
      'created_at': createdAt,
      'description': description,
      'director': director,
      'cast': cast,
      'language': language,
      'duration': duration,
    };
  }
}
