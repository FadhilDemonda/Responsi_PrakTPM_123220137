import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import '../models/film_model.dart';
import '../utils/local_favorite.dart';

class DetailPage extends StatefulWidget {
  final Film film;
  const DetailPage({super.key, required this.film});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    bool fav = await LocalFavorite.isFavorite(widget.film.id);
    setState(() {
      isFavorite = fav;
    });
  }

  void _toggleFavorite() async {
    if (isFavorite) {
      await LocalFavorite.removeFavorite(widget.film.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dihapus dari favorit'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      await LocalFavorite.addFavorite(widget.film);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ditambahkan ke favorit'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final film = widget.film;

    return Scaffold(
      appBar: AppBar(
        title: Text(film.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
            tooltip: isFavorite ? 'Hapus dari favorit' : 'Tambah ke favorit',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                film.imgUrl,
                height: 450,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 250,
                      color: Colors.grey,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, size: 60),
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    film.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(film.rating, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey[400],
                        size: 28,
                      ),
                      onPressed: _toggleFavorite,
                      tooltip:
                          isFavorite
                              ? 'Hapus dari favorit'
                              : 'Tambah ke favorit',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  film.genre
                      .map(
                        (g) => Chip(
                          label: Text(g),
                          backgroundColor: Colors.blue.shade100,
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 16),
            _infoRow('Tanggal Rilis', film.releaseDate),
            _infoRow('Sutradara', film.director),
            _infoRow('Pemain', film.cast.join(', ')),
            _infoRow('Bahasa', film.language),
            _infoRow('Durasi', film.duration),
            const SizedBox(height: 16),
            const Text(
              'Deskripsi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              film.description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
