import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_trailer/src/bloc/moviebloc/movie_bloc.dart';
import 'package:movie_trailer/src/bloc/moviebloc/movie_bloc_event.dart';
import 'package:movie_trailer/src/bloc/moviebloc/movie_bloc_state.dart';
import 'package:movie_trailer/src/bloc/person/person_bloc.dart';
import 'package:movie_trailer/src/bloc/person/person_bloc_event.dart';
import 'package:movie_trailer/src/bloc/person/person_bloc_state.dart';
import 'package:movie_trailer/src/model/movie.dart';
import 'package:movie_trailer/src/model/person.dart';
import 'package:movie_trailer/src/ui/movie_detail_screen.dart';

import 'category_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
          create: (_) => MovieBloc()..add(const MovieEventStarted(0, '')),
        ),
        BlocProvider<PersonBloc>(
          create: (_) => PersonBloc()..add(PersonEventStarted()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Icon(
            Icons.menu,
            color: Colors.black45,
          ),
          title: Text(
            'Movies-db'.toUpperCase(),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 15),
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/poster.jpeg'),
              ),
            ),
          ],
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BlocBuilder<MovieBloc, MovieState>(
                  builder: (context, state) {
                    if (state is MovieLoading) {
                      return Center(
                        child: Platform.isAndroid
                            ? const CircularProgressIndicator()
                            : const CupertinoActivityIndicator(),
                      );
                    } else if (state is MovieLoaded) {
                      List<Movie> movies = state.movieList;
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CarouselSlider.builder(
                              itemCount: movies.length,
                              itemBuilder: (context, index, realIndex) {
                                Movie movie = movies[index];
                                String title = movie.title;
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> MovieDetailScreen(movie: movie,)));
                                  },
                                  child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: <Widget>[
                                        ClipRRect(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                3,
                                            width:
                                                MediaQuery.of(context).size.width,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Platform
                                                    .isAndroid
                                                ? const CircularProgressIndicator()
                                                : const CupertinoActivityIndicator(),
                                            errorWidget: (context, url, error) =>
                                                Container(
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/poster.jpeg'),
                                                ),
                                              ),
                                            ),
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Text(
                                              title,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                              overflow: TextOverflow.ellipsis,
                                            ))
                                      ]),
                                );
                              },
                              options: CarouselOptions(
                                enableInfiniteScroll: true,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 5),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                pauseAutoPlayOnTouch: true,
                                viewportFraction: 0.8,
                                enlargeCenterPage: true,
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    SizedBox(height: 12),
                                    BuildWidgetCategory()
                                  ],
                                ))
                          ]);
                    } else {
                      return const Text('Something went wrong!!!');
                    }
                  },
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text('Person Trending'.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 10),
                        BlocBuilder<PersonBloc, PersonState>(
                          builder: (context, state) {
                            if (state is PersonLoading) {
                              return Center(
                                child: Platform.isAndroid
                                    ? const CircularProgressIndicator()
                                    : const CupertinoActivityIndicator(),
                              );
                            } else if (state is PersonLoaded) {
                              List<Person> personList = state.personList;
                              return SizedBox(
                                height: 110,
                                child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      Person person = personList[index];
                                      return Container(
                                        child: Column(children: [
                                          Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              elevation: 3,
                                              child: ClipRRect(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      'https://image.tmdb.org/t/p/w200${person.profilePath}',
                                                  imageBuilder:
                                                      (context, imageProvider) {
                                                    return Container(
                                                        height: 80,
                                                        width: 80,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius.circular(
                                                                        100)),
                                                            image: DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover)));
                                                  },
                                                  placeholder: (context, url) =>
                                                      SizedBox(
                                                    width: 80,
                                                    height: 80,
                                                    child: Center(
                                                      child: Platform.isAndroid
                                                          ? const CircularProgressIndicator()
                                                          : const CupertinoActivityIndicator(),
                                                    ),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Container(
                                                          height: 80,
                                                          width: 80,
                                                          decoration: const BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      'assets/images/poster.jpeg')))),
                                                ),
                                              )),
                                          Center(
                                            child: Text(
                                              person.name.toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.black45,
                                                fontSize: 8,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              person.knowForDepartment
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.black45,
                                                fontSize: 8,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const VerticalDivider(
                                            width: 5,
                                            color: Colors.transparent),
                                    itemCount: personList.length),
                              );
                            } else {
                              return const Center(
                                child: Text('err'),
                              );
                            }
                          },
                        )
                      ],
                    )),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
