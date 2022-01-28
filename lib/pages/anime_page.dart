import 'package:anime_reviewers/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimePage extends StatefulWidget {
  const AnimePage({
    Key? key,
    required this.selectedAnime,
    required this.selectedImage,
  }) : super(key: key);
  final Anime selectedAnime;
  final String selectedImage;

  @override
  _AnimePageState createState() => _AnimePageState();
}

class _AnimePageState extends State<AnimePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アニメ詳細'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
          left: 5.0,
          right: 5.0,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 0.0,
                bottom: 5.0,
                right: 5.0,
              ),
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('images/${widget.selectedImage}'),
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 3.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(widget.selectedAnime.title),
                    )
                  ],
                ),
              ),
            ),
            const Divider(
              thickness: 5.0,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 100,
              child: Center(
                child: Text("あらすじ:\n何とかかんとかが何とかかんとかで云々かんぬんである"),
              ),
            ),
            SizedBox(
              height: 100,
              child: GestureDetector(
                onTap: _launchURL,
                child: Text('公式サイト:\n${widget.selectedAnime.publicUrl}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL() async {
    if (!await launch(widget.selectedAnime.publicUrl)) throw 'ページが開けませんでした';
  }

}
