import 'package:anime_reviewers/pages/anime_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Anime>> animeList;

  // 画像の権利的に公式のアニメ画像をアプリ内で使っていいか分からなかったので、いらすとやの画像を使った
  final List<String> imageList = [
    "butai_2_5jigen.png",
    "cool_japan.png",
    "idol_2_5jigen.png",
    "kyodai_robot.png",
    "renai2_school.png",
    "obake.png",
    "kids_chuunibyou_boy.png",
    "yumekawa_tanabata_couple.png",
  ];

  @override
  void initState() {
    super.initState();
    animeList = fetchAnime();
  }

  @override
  Widget build(BuildContext context) {
    // ボトムナビゲーションバーのタブを残したままの遷移を実現するためにNavigatorを入れた
    // 途中まで上手くいっていたが、色々触っているうちにいつの間にかうまく動かなくなっていた
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('ホーム'),
              ),
              body: FutureBuilder<List<Anime>>(
                future: animeList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CustomScrollView(
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              left: 5.0,
                              bottom: 5.0,
                              right: 5.0,
                            ),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 10.0),
                              height: 50.0,
                              child: const Text(
                                'ランキング',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: FractionalOffset.bottomLeft,
                                  end: FractionalOffset.topRight,
                                  colors: [
                                    const Color(0xffec407a).withOpacity(0.6),
                                    const Color(0xffbbdefb).withOpacity(0.6),
                                  ],
                                  stops: const [
                                    0.0, 0.9,
                                  ],
                                ),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.6),
                                    width: 3.0
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SizedBox(
                              height: 100,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return AnimePage(
                                              selectedAnime: snapshot.data![index],
                                              selectedImage: imageList[index % 8],
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 100.0,
                                      child: Stack(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 70,
                                                child: Image.asset('images/${imageList[index % 8]}'),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                                child: RatingStar(starSize: 15.0),
                                              ),
                                            ],
                                          ),
                                          Positioned(
                                            top: 0.0,
                                            left: 5.0,
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: FractionalOffset.bottomLeft,
                                          end: FractionalOffset.topRight,
                                          colors: [
                                            const Color(0xfffffde7).withOpacity(0.6),
                                            const Color(0xfff1f8e9).withOpacity(0.6),
                                          ],
                                          stops: const [
                                            0.0, 0.9,
                                          ],
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.6),
                                          width: 3.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                                scrollDirection: Axis.horizontal,
                                itemCount: 10,
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 10.0),
                              height: 50.0,
                              child: const Text(
                                '新着レビュー',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: FractionalOffset.bottomLeft,
                                  end: FractionalOffset.topRight,
                                  colors: [
                                    const Color(0xffec407a).withOpacity(0.6),
                                    const Color(0xffbbdefb).withOpacity(0.6),
                                  ],
                                  stops: const [
                                    0.0, 0.9,
                                  ],
                                ),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.6),
                                    width: 3.0
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  child: Container(
                                    child: Stack(
                                      children: [
                                        Image.asset("images/${imageList[index % 8]}"),
                                        Text(
                                          snapshot.data![index].title,
                                          style: const TextStyle(
                                            fontFamily: 'Mochiy Pop P One'
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: FractionalOffset.bottomLeft,
                                        end: FractionalOffset.topRight,
                                        colors: [
                                          const Color(0xfffffde7).withOpacity(0.6),
                                          const Color(0xfff1f8e9).withOpacity(0.6),
                                        ],
                                        stops: const [
                                          0.0, 0.9,
                                        ],
                                      ),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.6),
                                        width: 3.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return AnimePage(
                                            selectedAnime: snapshot.data![index],
                                            selectedImage: imageList[index % 8],
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            childCount: snapshot.data!.length,
                          ),
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200.0,
                            mainAxisSpacing: 0.0,
                            crossAxisSpacing: 0.0,
                            childAspectRatio: 1.0,
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}

// アニメクラス　本当はproviderを使ってhome_model.dartなどの中に入れる予定だった
// providerが時間内に理解しきれなかったので諦めた
// twitterAccountもAPIから取得しているがどこにも使われていない
class Anime {
  final String title;
  final String publicUrl;
  final String twitterAccount;

  const Anime({
    required this.title,
    required this.publicUrl,
    required this.twitterAccount,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      title: json['title'],
      publicUrl: json['public_url'],
      twitterAccount: json['twitter_account'],
    );
  }
}

Future<List<Anime>> fetchAnime() async {
  final response = await http
      .get(Uri.parse('http://api.moemoe.tokyo/anime/v1/master/2022/1'));
  if (response.statusCode == 200) {
    return parseAnime(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

List<Anime> parseAnime(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Anime>((json) => Anime.fromJson(json)).toList();
}

//　レーティング用のスター　home.dart以外からも使われる予定だった
//　もっとスマートなスターになる予定だったが、時間がなかったので星4.5で固定
class RatingStar extends StatelessWidget {
  const RatingStar({
    Key? key,
    required this.starSize,
  }) : super(key: key);

  final double starSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: starSize,
        ),
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: starSize,
        ),
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: starSize,
        ),
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: starSize,
        ),
        Icon(
          Icons.star_half,
          color: Colors.yellow,
          size: starSize,
        ),
      ],
    );
  }
}
