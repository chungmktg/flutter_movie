import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_trailer/src/bloc/genrebloc/genre_bloc.dart';
import 'package:movie_trailer/src/bloc/genrebloc/genre_bloc_event.dart';
import 'package:movie_trailer/src/bloc/genrebloc/genre_bloc_state.dart';
import 'package:movie_trailer/src/bloc/moviebloc/movie_bloc.dart';
import 'package:movie_trailer/src/bloc/moviebloc/movie_bloc_event.dart';
import 'package:movie_trailer/src/bloc/moviebloc/movie_bloc_state.dart';
import 'package:movie_trailer/src/model/genre.dart';
import 'package:movie_trailer/src/model/movie.dart';

class BuildWidgetCategory extends StatefulWidget {
  final int selectedGenre;

  const BuildWidgetCategory({Key? key, this.selectedGenre = 28})
      : super(key: key);

  @override
  _BuildWidgetCategoryState createState() => _BuildWidgetCategoryState();
}

class _BuildWidgetCategoryState extends State<BuildWidgetCategory> {
  late int selectedGenre;

  @override
  void initState() {
    super.initState();
    selectedGenre = widget.selectedGenre;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GenreBloc>(
          create: (_) => GenreBloc()..add(GenreEventStarted()),
        ),
        BlocProvider<MovieBloc>(
          create: (_) => MovieBloc()..add(MovieEventStarted(selectedGenre, '')),
        ),
      ],
      child: _buildGenre(context),
    );
  }

  Widget _buildGenre(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      BlocBuilder<GenreBloc, GenreState>(builder: (context, state) {
        if (state is GenreLoading) {
          return Center(
            child: Platform.isAndroid
                ? const CircularProgressIndicator()
                : const CupertinoActivityIndicator(),
          );
        } else if (state is GenreLoaded) {
          List<Genre> genres = state.genreList;
          return SizedBox(
            height: 45,
            child: ListView.separated(
                itemBuilder: (context, index) {
                  Genre genre = genres[index];
                  return Column(
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              Genre genre = genres[index];
                              selectedGenre = genre.id;
                              context
                                  .read<MovieBloc>()
                                  .add(MovieEventStarted(selectedGenre, ''));
                            });
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black45,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(25),
                                ),
                                color: (genre.id == selectedGenre)
                                    ? Colors.black45
                                    : Colors.white,
                              ),
                              child: Text(
                                genre.name.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: genre.id == selectedGenre
                                        ? Colors.white
                                        : Colors.black45),
                              ))),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const VerticalDivider(
                      color: Colors.transparent,
                      width: 5,
                    ),
                scrollDirection: Axis.horizontal,
                itemCount: genres.length),
          );
        } else {
          return const Text('error');
        }
      }),
      const SizedBox(height: 10),
      Text('New Playing'.toUpperCase(),
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black45)),
      const SizedBox(height: 10),
      BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return Center(
              child: Platform.isAndroid
                  ? const CircularProgressIndicator()
                  : const CupertinoActivityIndicator(),
            );
          } else if (state is MovieLoaded) {
             List<Movie> movieList = state.movieList;

              return SizedBox(
                height: 300,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const VerticalDivider(
                    color: Colors.transparent,
                    width: 15,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: movieList.length,
                  itemBuilder: (context, index) {
                    Movie movie = movieList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                           
                          },
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  width: 180,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              placeholder: (context, url) => SizedBox(
                                width: 180,
                                height: 250,
                                child: Center(
                                  child: Platform.isAndroid
                                      ? const CircularProgressIndicator()
                                      : const CupertinoActivityIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 180,
                                height: 250,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/img_not_found.jpg'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 180,
                          child: Text(
                            movie.title.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'muli',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 14,
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 14,
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 14,
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 14,
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 14,
                            ),
                            Text(
                              movie.voteAverage,
                              style: const TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              );
          } else {
            return const Center(
              child: Text('error'),
            );
          }
        },
      )
    ]);
  }
}
