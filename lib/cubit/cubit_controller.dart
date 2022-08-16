import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/core/service/IService.dart';
import 'package:yazilar/local_db/IHiveController.dart';
import 'package:yazilar/utility/toast.dart';

import '../core/model/article.dart';

class CubitController extends Cubit<AppState> {
  //service
  final IService service;
  //hive
  final IHiveController hive;

  CubitController({required this.service, required this.hive})
      : super(InitState()) {
    conf.Session.controller!.addListener(getArticlesOnScroll);
  }

  ///---------------- API related variables ----------------- ///

  //received data
  List<Article> articles = [];

  ///favorite articles (library)
  Map<dynamic, Article> favorites = {};

  ///categories
  List<String> categories = [];

  ///groups
  List<String> groups = [];

  //filters
  List<String> selectedCategories = [];

  List<String> selectedGroups = [];

  ///last reached data's id - for paging
  int cursor = -1;

  ///order by id - last articles id is the biggest
  ///Default = last article show at first
  String orderBy = 'desc';

  ///is there any data left to get from server?
  bool hasMoreData = true;

  ///--------- END OF API RELATED VARIABLES ---------///

  ///filter screen visibility
  bool isFilterScreenVisible = false;

  ///article open/closed
  bool isArticleOpen = false;

  ///selected page - default --> home page
  int pageIndex = 0;

  ///data loading
  bool articlesLoading = false;

  ///categories loading
  bool categoriesLoading = false;

  ///groups loading
  bool groupsLoading = false;

  ///scroll loading
  bool articlesLoadingScroll = false;

  ///search bar visible
  bool searchBarVisible = false;

  ///font settings visible
  bool fontSettingsVisible = false;

  ///selected font size
  double selectedFontSize = 16; // default small

  ///selected font color
  Color fontColor = conf.defaultFontColor;

  ///--------------SERVICE CALLS------------------
  Future<void> getArticles() async {
    changeArticlesLoading(true);
    final data = await service.getArticles({
      'category': selectedCategories,
      'group': selectedGroups,
      'orderby': orderBy,
      'start': cursor == 0 && orderBy == 'desc' ? -1 : cursor,
      'limit': conf.AppConfig.requestedDataQuantity,
    });
    changeArticlesLoading(false);
    if (data.isNotEmpty) {
      articles.addAll(data);
      cursor = articles.last.id!;
      emit(ArticlesSuccess(data));
      if (data.length < conf.AppConfig.requestedDataQuantity) {
        changeMoreDataStatus(false);
      }
    } else {
      emit(ArticlesFail());
    }
  }

  ///get articles on scroll
  void getArticlesOnScroll() async {
    if (hasMoreData &&
        conf.Session.controller!.position.extentAfter < 300 &&
        articlesLoadingScroll == false) {
      changeArticlesScrollLoading(true);
      final data = await service.getArticles({
        'category': selectedCategories,
        'group': selectedGroups,
        'orderby': orderBy,
        'start': cursor,
        'limit': conf.AppConfig.requestedDataQuantity,
      });
      changeArticlesScrollLoading(false);
      if (data.isNotEmpty) {
        articles.addAll(data);
        cursor = articles.last.id ?? 0;
        emit(ArticlesSuccess(data));
        if (data.length < conf.AppConfig.requestedDataQuantity) {
          changeMoreDataStatus(false);
        }
      }
    }
  }

  ///get all categories - run at startup
  Future<void> getCategories() async {
    changeCategoriesLoading(true);
    final data = await service.getAllCategories();
    changeCategoriesLoading(false);
    if (data.isNotEmpty) {
      categories = data as List<String>;
    }
  }

  ///get all groups - run at startup
  Future<void> getGroups() async {
    changeGroupsLoading(true);
    final data = await service.getAllGroups();
    changeGroupsLoading(false);
    if (data.isNotEmpty) {
      groups = data as List<String>;
    }
  }

  ///search by filter
  void searchByFilter() async {
    cursor = -1;
    articles = [];
    hasMoreData = true;
    await getArticles();
  }

  ///add selected category
  void addSelectedCategories(String s) {
    selectedCategories.contains(s)
        ? removeCategory(s)
        : selectedCategories.add(s);
    emit(FilterUpdated());
  }

  ///remove selected category
  void removeCategory(String s) {
    selectedCategories.remove(s);
    emit(FilterUpdated());
  }

  ///add selected group
  void addSelectedGroups(String s) {
    selectedGroups.contains(s) ? removeGroup(s) : selectedGroups.add(s);
    emit(FilterUpdated());
  }

  ///remove selected group
  void removeGroup(String s) {
    selectedGroups.remove(s);
    emit(FilterUpdated());
  }

  ///clear categories
  void clearCategories() {
    selectedCategories.clear();
    emit(FilterUpdated());
  }

  ///clear groups
  void clearGroups() {
    selectedGroups.clear();
    emit(FilterUpdated());
  }

  ///change order
  void changeOrder() async {
    cursor = -1;
    orderBy = orderBy == 'asc' ? 'desc' : 'asc';
    articles = [];
    hasMoreData = true;
    await getArticles();
  }

  ///-------------- SERVICE CALLS END ------------------

  ///-------------- HIVE OPERATIONS --------------------
  ///get all favorite articles
  void getAllFavoriteArticles() {
    favorites.clear();
    favorites = hive.getArticles();
    emit(FavoritesUpdated());
  }

  ///get a favorite articles
  Article? getFavoriteArticle(int id) {
    return hive.getArticle(id);
  }

  ///add to favorite
  void addToFavorites(Article article) {
    hive.addArticle(article);
    favorites.putIfAbsent(article.id, () => article);
    showToastMessage(conf.addedToFav);
    emit(FavoritesUpdated());
  }

  ///remove from favorites
  void removeFromFavorites(int? id) {
    hive.deleteArticle(id!);
    favorites.remove(id);
    showToastMessage(conf.removeFromFav);
    emit(FavoritesUpdated());
  }

  ///-------------- HIVE OPERATIONS END ------------------

  ///change page
  void changePage(int i) {
    pageIndex = i;
    emit(PageChangedState(pageIndex));
  }

  ///filter screen change visibility
  void changeFilterScreenVisibility(bool b) {
    isFilterScreenVisible = b;
    emit(FilterScreenVisibility(isFilterScreenVisible));
  }

  ///change hasMoreData property
  void changeMoreDataStatus(bool b) {
    hasMoreData = b;
    emit(HasMoreData(hasMoreData));
  }

  ///change search bar visibility
  void changeSearchBarVisibility() {
    searchBarVisible = !searchBarVisible;
    emit(NotifyPipe());
  }

  ///change font settings visibility
  void changeFontSettingsVisibility() {
    fontSettingsVisible = !fontSettingsVisible;
    emit(NotifyPipe());
  }

  ///change font size
  void changeFontSize(double size) {
    selectedFontSize = size;
    changeFontSettingsVisibility();
  }

  //article open state change
  void changeArticleState(bool b) {
    isArticleOpen = b;
    emit(ArticleStateChanged(isArticleOpen));
  }

  ///article loading state change
  void changeArticlesLoading(bool b) {
    articlesLoading = b;
    emit(ArticlesLoadingState(articlesLoading));
  }

  ///categories loading state change
  void changeCategoriesLoading(bool b) {
    categoriesLoading = b;
    emit(CategoriesLoadingState(categoriesLoading));
  }

  ///groups loading state change
  void changeGroupsLoading(bool b) {
    groupsLoading = b;
    emit(GroupsLoadingState(groupsLoading));
  }

  ///article scroll loading state change
  void changeArticlesScrollLoading(bool b) {
    articlesLoadingScroll = b;
    emit(ArticlesLoadingScrollState(articlesLoadingScroll));
  }
}

abstract class AppState {}

class NotifyPipe extends AppState {}

class InitState extends AppState {}

///page state
class PageChangedState extends AppState {
  final int pageIndex;

  PageChangedState(this.pageIndex);
}

///visibility states
class FilterScreenVisibility extends AppState {
  final bool isVisible;

  FilterScreenVisibility(this.isVisible);
}

///Filter selected
class FilterUpdated extends AppState {}

///article state
class ArticleStateChanged extends AppState {
  final bool isArticleOpen;

  ArticleStateChanged(this.isArticleOpen);
}

///articles loading state
class ArticlesLoadingState extends AppState {
  final bool isLoading;

  ArticlesLoadingState(this.isLoading);
}

///categories loading state
class CategoriesLoadingState extends AppState {
  final bool isLoading;

  CategoriesLoadingState(this.isLoading);
}

///groups loading state
class GroupsLoadingState extends AppState {
  final bool isLoading;

  GroupsLoadingState(this.isLoading);
}

///articles loading state
class ArticlesLoadingScrollState extends AppState {
  final bool isLoading;

  ArticlesLoadingScrollState(this.isLoading);
}

///articles get success
class ArticlesSuccess extends AppState {
  final List<Article> articles;

  ArticlesSuccess(this.articles);
}

///articles get fails
class ArticlesFail extends AppState {}

///Has more data on server
class HasMoreData extends AppState {
  final bool hasMoreData;

  HasMoreData(this.hasMoreData);
}

///Order Changed State
class OrderChangedState extends AppState {
  final String orderBy;

  OrderChangedState(this.orderBy);
}

///favorite article added
class FavoritesUpdated extends AppState {}
