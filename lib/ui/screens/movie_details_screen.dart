import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../data/Constants.dart';
import '../../data/model/credits.dart';
import '../../data/network/api_service.dart';
import '../../data/model/trending_movies.dart';


class MovieDetailsScreen extends StatefulWidget {

  final Results results;

  const MovieDetailsScreen({super.key, required this.results});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {

  Map<int, String> genresMap = {};
  List<Crew> crewList = [];
  List<Cast> castList = [];

  @override
  void initState() {
    super.initState();
    fetchGenres();
    fetchCreditData();
  }

  fetchCreditData() async {
    var responseBody = await ApiService().fetchCredit(widget.results.id.toString());
    setState(() {
      List<dynamic> castData = responseBody['cast'];
      List<dynamic> crewData = responseBody['crew'];
      castList = castData.map((json) => Cast.fromJson(json)).toList();
      crewList = crewData.map((json) => Crew.fromJson(json)).toList();
    });
  }

  fetchGenres() async {
    var genreList = await ApiService().fetchGenres();
    var genre = genreList.map((e) => e.toJson());
    setState(() {
      genresMap = getGenreNamesByIds(genre, widget.results.genreIds);
    });
  }

  String? getTechnicianNameByJob(List<Crew> crewList,String job) {
    final director = crewList.firstWhere(
          (crew) => crew.job == job,
      orElse: () => Crew(
        adult: false,
        gender: 0,
        id: 0,
        knownForDepartment: '',
        name: '',
        originalName: '',
        popularity: 0.0,
        profilePath: '',
        creditId: '',
        department: '',
        job: '',
      ),
    );

    return director.name ?? '';
  }

  Map<int, String> getGenreNamesByIds(
      Iterable<Map<String, dynamic>> genresData, List<int>? genreIds) {
    Map<int, String> genreNames = {};

    if (genreIds == null) {
      return genreNames; // Return an empty map if genreIds is null.
    }

    for (int genreId in genreIds) {
      for (Map<String, dynamic> genre in genresData) {
        if (genre['id'] == genreId) {
          genreNames[genreId] = genre['name'];
          break;
        }
      }
    }

    return genreNames;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            SizedBox(
              height: MediaQuery.of(context).viewPadding.top,
            ),
            movieBackDrop(context),
            const SizedBox(height: 20,),
            movieTitle(),
            movieReleaseYear(),
            const SizedBox(
              height: 20,
            ),
            movieGenre(),
            movieOverview(),
            movieCrew(),
            movieCast()
          ],
        ),
      ),
    );
  }

  Widget movieTitle() {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 240,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            widget.results.title.toString(),
            textAlign: TextAlign.right,
            style:const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }

  Widget movieReleaseYear() {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 250,
        child: Text(
          "(${widget.results.releaseDate.toString().substring(0,4)})",
          textAlign: TextAlign.right,
          style:const TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontStyle: FontStyle.italic
          ),
        ),
      ),
    );
  }

  Widget movieGenre() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Genre',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),),
          const SizedBox(
            height: 20,
          ),
          Text(
            genresMap.values.join(" • "),
            textAlign: TextAlign.justify,
            style:const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget movieOverview() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Overview',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),
          const SizedBox(
            height: 20,
          ),
          Text(
            widget.results.overview.toString(),
            textAlign: TextAlign.justify,
            style:const TextStyle(
                fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget moviePoster(String posterPath) {
    return Card(
      elevation: 8,
      child: Container(
        height: 200,
        width: 140,
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(
                "$imageUrl$posterPath"),
          ),
        ),
      ),
    );
  }

  Widget movieBackDrop(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(color: Theme
          .of(context)
          .colorScheme
          .background),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(clipBehavior: Clip.none, children: <Widget>[
            cardBackGround(widget.results.backdropPath.toString()),
            cardGradient(context),

            Positioned(top: 10.0,left: 10.0, child: GestureDetector(
              onTap: (){Navigator.of(context).pop();},
              child: backButton(context),
            )),

            Positioned(bottom: -80.0, left: 10.0,
              child: moviePoster(widget.results.posterPath.toString()),
            ),

            Positioned(bottom: 0.0, right: 0.0,
              child: movieRating(context),
            ),
          ]),
        ],
      ),
    );
  }

  Widget backButton(BuildContext context) {
    return Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back,color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
  }


  Widget cardGradient(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Colors.transparent,
                Theme
                    .of(context)
                    .colorScheme
                    .surface,
              ],
              stops: const [
                0.0,
                1.0
              ])),
    );
  }

  Widget cardBackGround(String posterPath) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(
              "$imageUrl$posterPath"),
        ),
      ),
    );
  }

  Widget movieRating(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 100,
      child: Center(
        child: CircularPercentIndicator(
          radius: 40,
          lineWidth: 10,
          footer: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "User Score",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),),
          ),
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          progressColor: movieRatingProgressColor(widget.results.voteAverage ?? 0.0),
          percent: movieRatingPercentage(widget.results.voteAverage ?? 0.0),
          center: Text(
            movieRatingPercentageLabel(widget.results.voteAverage ?? 0.0),
            style: TextStyle(fontSize: 20, color: Theme
                .of(context)
                .colorScheme
                .onSurface),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          animation: false,
          animationDuration: 2000,
        ),
      ),
    );
  }

  Widget movieCrew() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Crew',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),

          const SizedBox(
            height: 20,
          ),

          crewInfo(getTechnicianNameByJob(crewList, 'Director').toString(), 'Director'),
        ],
      ),
    );
  }

  Widget crewInfo(String name, String job) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            name,
          style: const TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        Text(job)
      ],
    );
  }

  Widget movieCast() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text('Cast',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),

          const SizedBox(
            height: 20,
          ),

          SizedBox(
            height: 150,
            child: Center(
              child: ListView.separated(
                  itemBuilder: (snapshot,itemIndex) {
                    return castInfo(context, itemIndex);
                  },
                  separatorBuilder: (context, int index) {
                    return const SizedBox(width: 10,);
                  },
                  itemCount: castList.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget castInfo(BuildContext context,int itemIndex) {

    String? imagePath = castList[itemIndex].profilePath;

    if(imagePath != null) {
      return Column(
        children: [
          CircleAvatar(
            radius: 30, // Adjust the radius as needed
            foregroundImage: NetworkImage('$imageUrl$imagePath'),
            backgroundColor: Colors.transparent,
          ),

          const SizedBox(
            height: 8,
          ),

          SizedBox(
            width: 100,
            child: Text(
              castList[itemIndex].name.toString(),
              textAlign: TextAlign.center,
            ),
          )
        ],
      );
    }
    return Container();
  }


  Color movieRatingProgressColor(num voteAverage) {
    final sealedVoteAverage = voteAverage.toInt();
    if(sealedVoteAverage >= 7) {
      return Colors.green;
    } else if(sealedVoteAverage < 7 && sealedVoteAverage > 5) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  double movieRatingPercentage(num voteAverage) {
    return voteAverage/10;
  }

  String movieRatingPercentageLabel(num voteAverage) {
    int percentageValue = (voteAverage * 10).toInt();
    return '$percentageValue%';
  }


}



