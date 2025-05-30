import 'package:flutter/material.dart';
import '../models/film_model.dart';
import '../utils/local_favorite.dart';
import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Film> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => isLoading = true);

    final favs = await LocalFavorite.getFavorites();

    setState(() {
      favorites = favs;
      isLoading = false;
    });
  }

  Future<void> _removeFavorite(String id) async {
    await LocalFavorite.removeFavorite(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Berhasil menghapus dari favorit'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ),
    );
    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Film Favorit')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : favorites.isEmpty
              ? const Center(child: Text('Belum ada film favorit'))
              : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final f = favorites[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          f.imgUrl,
                          width: 60,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                width: 60,
                                height: 90,
                                color: Colors.grey,
                                child: const Icon(Icons.broken_image),
                              ),
                        ),
                      ),
                      title: Text(
                        f.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text('Rilis: ${f.releaseDate}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeFavorite(f.id),
                        tooltip: 'Hapus dari favorit',
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPage(film: f),
                          ),
                        ).then((_) => _loadFavorites());
                      },
                    ),
                  );
                },
              ),
    );
  }
}
