import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/features/home/bloc/home_bloc.dart';
import 'package:movies/features/home/ui/movie_card_list.dart';
import 'package:movies/repository/constants.dart';
import '../../../di/get_it.dart';
import '../data/movie_section_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final HomeBloc homeBloc = locator<HomeBloc>();

  @override
  void initState() {
    homeBloc.add(HomeOnLoadEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    homeBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .surface,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Movie Master', style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
        ),),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: homeBloc,
        listenWhen: (previous,current) => current is HomeActionState,
        buildWhen: (previous,current) => current is !HomeActionState,
        listener: (context, state) {

        },
        builder: (context, state) {
          switch(state.runtimeType) {
            case HomeInitial:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case HomeOnLoadedSuccessState:
              final successState = state as HomeOnLoadedSuccessState;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(child: _movieSection(successState.movieSectionList)),
                  ),
                );
            case HomeOnErrorState:
              return const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Image(
                        image:  AssetImage("assets/error.png"),
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        child: Text(
                          errorNetworkMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _movieSection(List<MovieSectionData> movieSectionList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(movieSectionList.length, (index) => MovieCardList(movieSection: movieSectionList[index],)),
    );
  }
}