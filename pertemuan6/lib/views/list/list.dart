import 'package:flutter/material.dart';
import 'package:pertemuan6/models/anime_model.dart';
import 'package:pertemuan6/presenters/anime_presenter.dart';
import 'package:pertemuan6/views/detail/anime_detail.dart';

class AnimeListScreen extends StatefulWidget {
  const AnimeListScreen({super.key});

  @override
  State<AnimeListScreen> createState() => _AnimeListScreenState();
}

class _AnimeListScreenState extends State<AnimeListScreen>
    implements AnimeView {
  late AnimePresenter _presenter;
  bool _isLoading = false;
  List<Anime> _animeList = [];
  String? _errorMessage;
  String _currentEndpoint = 'akatsuki';

  @override
  void initState() {
    super.initState();
    _presenter = AnimePresenter(this);
    _presenter.loadAnimeData(_currentEndpoint);
  }

  void _fetchData(String endpoint) {
    setState(() {
      _currentEndpoint = endpoint;
      _presenter.loadAnimeData(endpoint);
    });
  }

  @override
  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showAnimeList(List<Anime> animeList) {
    setState(() {
      _animeList = animeList;
    });
  }

  @override
  void showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anime List"),
        backgroundColor: Color.fromARGB(255, 72, 192, 248),
        elevation: 0,
      ),
      
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFFE3F2FD)], // Pastel blue gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Anime...",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ), //search nya gaada fungsi kak, baru tampilan aja hehe
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  _buildCategoryButton("Akatsuki", "akatsuki"),
                  const SizedBox(width: 10),
                  _buildCategoryButton("Kara", "kara"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : _errorMessage != null
                      ? Center(child: Text("Error: $_errorMessage", style: const TextStyle(color: Colors.white)))
                      : ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: _animeList.length,
                          itemBuilder: (context, index) {
                            final anime = _animeList[index];
                            return _buildAnimeCard(anime);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String title, String endpoint) {
    return ElevatedButton(
      onPressed: () => _fetchData(endpoint),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: _currentEndpoint == endpoint
            ? Color.fromARGB(255, 72, 192, 248)
            : Colors.white,
        foregroundColor: _currentEndpoint == endpoint
            ? Colors.white
            :Color.fromARGB(255, 72, 192, 248),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: _currentEndpoint == endpoint ? 5 : 0,
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
    
  }

  
  Widget _buildAnimeCard(Anime anime) {
  return Card(
    color: Colors.white,
    shadowColor: Colors.blueAccent.withOpacity(0.3), // Bayangan lebih kuat
    elevation: 8, // Meningkatkan ketinggian bayangan agar lebih timbul
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: anime.imageUrl.isNotEmpty
            ? Image.network(
                anime.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              )
            : Image.network(
                'https://placehold.co/600x400',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
      ),
      title: Text(
        anime.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        'Family: ${anime.familyCreator}',
        style: const TextStyle(color: Colors.black54),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              id: anime.id,
              endpoint: _currentEndpoint,
            ),
          ),
        );
      },
    ),
  );
}

}
