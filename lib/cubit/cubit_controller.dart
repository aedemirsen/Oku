import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:yazilar/config/config.dart' as conf;
import 'package:yazilar/config/config.dart';
import 'package:yazilar/core/caching/IHiveController.dart';
import 'package:yazilar/core/model/opinion.dart';
import 'package:yazilar/core/model/user.dart';
import 'package:yazilar/core/service/IService.dart';
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

  ///authors
  List<String> authors = [];

  ///groups
  List<String> groups = [];

  //filters
  List<String> selectedCategories = [];

  List<String> selectedAuthors = [];

  List<String> selectedGroups = [];

  ///last reached data's id - for paging
  int cursor = -1;

  ///order by id - last articles id is the biggest
  ///Default = last article show at first
  String orderBy = 'desc';

  ///is there any data left to get from server?
  bool hasMoreData = true;

  ///--------- END OF API RELATED VARIABLES ---------///

  ///notifications on-off
  bool notificationsOn = true;

  ///filter screen visibility
  bool isFilterScreenVisible = false;

  ///article open/closed
  bool isArticleOpen = false;

  ///selected page - default --> home page
  int pageIndex = 0;

  ///data loading
  bool articlesLoading = false;

  ///opinion share loading
  bool opinionLoading = false;

  ///notification preference is loading
  bool notificationSettingsLoading = false;

  ///categories loading
  bool categoriesLoading = false;

  ///authors loading
  bool authorsLoading = false;

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

  ///get user
  Future<void> getUserNotificationPref(String id) async {
    //check connectivity
    if (isConnected()) {
      var data = await service.getUser(id);
      if (data != null) {
        //get notification preference
        notificationsOn = data.notificationStatus!;
        emit(NotifyPipe());
      } else {
        //user does not exists, then post user
        await service.postUser(
            User(id: conf.AppConfig.deviceId, notificationStatus: true));
      }
    } else {
      emit(ConnectivityFail());
    }
  }

  ///get articles
  Future<void> getArticles() async {
    //check connectivity
    if (isConnected()) {
      changeArticlesLoading(true);
      final data = await service.getArticles({
        'category': selectedCategories,
        'group': selectedGroups,
        'author': selectedAuthors,
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
    } else {
      emit(ConnectivityFail());
    }
  }

  ///add opinion
  Future<void> addOpinion(Opinion opinion) async {
    if (isConnected()) {
      changeOpinionLoadingState(true);
      final data = await service.postOpinion(opinion);
      if (data) {
        emit(NotifyPipe());
      }
      changeOpinionLoadingState(false);
    } else {}
  }

  ///get articles on scroll
  void getArticlesOnScroll() async {
    if (isConnected()) {
      if (hasMoreData &&
          conf.Session.controller!.position.extentAfter < 300 &&
          articlesLoadingScroll == false) {
        changeArticlesScrollLoading(true);
        final data = await service.getArticles({
          'category': selectedCategories,
          'group': selectedGroups,
          'author': selectedAuthors,
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
    } else {}
  }

  ///get all categories - run at startup
  Future<void> getCategories() async {
    if (isConnected()) {
      changeCategoriesLoading(true);
      final data = await service.getAllCategories();
      changeCategoriesLoading(false);
      if (data.isNotEmpty) {
        categories = data as List<String>;
      }
    } else {}
  }

  ///get all authors - run at startup
  Future<void> getAuthors() async {
    if (isConnected()) {
      changeAuthorsLoading(true);
      final data = await service.getAllAuthors();
      changeAuthorsLoading(false);
      if (data.isNotEmpty) {
        authors = data as List<String>;
      }
    } else {}
  }

  ///get all groups - run at startup
  Future<void> getGroups() async {
    if (isConnected()) {
      changeGroupsLoading(true);
      final data = await service.getAllGroups();
      changeGroupsLoading(false);
      if (data.isNotEmpty) {
        groups = data as List<String>;
      }
    } else {}
  }

  ///search by filter
  void searchByFilter() async {
    cursor = -1;
    articles = [];
    hasMoreData = true;
    await getArticles();
  }

  ///change order
  void changeOrder() async {
    cursor = -1;
    orderBy = orderBy == 'asc' ? 'desc' : 'asc';
    articles = [];
    hasMoreData = true;
    await getArticles();
  }

  ///check connectivity
  bool isConnected() {
    return true;
  }

  ///-------------- SERVICE CALLS END ------------------

  /// ------------- GUI CHANGES -------------------
  ///add selected category
  void addSelectedCategories(String s) {
    selectedCategories.contains(s)
        ? removeCategory(s)
        : selectedCategories.add(s);
    emit(FilterUpdated());
  }

  ///add selected author
  void addSelectedAuthors(String s) {
    selectedAuthors.contains(s) ? removeAuthor(s) : selectedAuthors.add(s);
    emit(FilterUpdated());
  }

  ///remove selected category
  void removeCategory(String s) {
    selectedCategories.remove(s);
    emit(FilterUpdated());
  }

  ///remove selected author
  void removeAuthor(String s) {
    selectedAuthors.remove(s);
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

  ///clear authors
  void clearAuthors() {
    selectedAuthors.clear();
    emit(FilterUpdated());
  }

  ///clear groups
  void clearGroups() {
    selectedGroups.clear();
    emit(FilterUpdated());
  }

  /// ------------- GUI CHANGES END-------------------

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

  ///get font size
  void getFontSize() {
    selectedFontSize = hive.getFontSize() ?? 16;
    emit(NotifyPipe());
  }

  ///add font size
  void addFontSize(double fontSize) {
    hive.addFontSize(fontSize);
    emit(NotifyPipe());
  }

  ///-------------- HIVE OPERATIONS END ------------------

  ///change page
  void changePage(int i) {
    pageIndex = i;
    emit(PageChangedState(pageIndex));
  }

  void changeNotificationOption(bool b) async {
    changeNotificationSettingsLoading(true);
    notificationsOn = await service
        .updateUser(User(notificationStatus: b, id: AppConfig.deviceId));
    notificationsOn
        ? showToastMessage(
            'Bildirimler aktifleştirildi. Yeni bir yazı eklendiğinde bildirim alacaksın.')
        : showToastMessage(
            'Bildirimler kapatıldı. Yeni bir yazı eklendiğinde bildirim almayacaksın.');
    changeNotificationSettingsLoading(false);
    emit(NotifyPipe());
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
  void changeFontSettingsVisibility(bool b) {
    fontSettingsVisible = b;
    emit(NotifyPipe());
  }

  ///change font size
  void changeFontSize(double size) {
    selectedFontSize = size;
    addFontSize(size);
    emit(NotifyPipe());
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

  ///article loading state change
  void changeOpinionLoadingState(bool b) {
    opinionLoading = b;
    emit(NotifyPipe());
  }

  ///notification settings loading state change
  void changeNotificationSettingsLoading(bool b) {
    notificationSettingsLoading = b;
    emit(NotifyPipe());
  }

  ///categories loading state change
  void changeCategoriesLoading(bool b) {
    categoriesLoading = b;
    emit(CategoriesLoadingState(categoriesLoading));
  }

  ///authors loading state change
  void changeAuthorsLoading(bool b) {
    authorsLoading = b;
    emit(CategoriesLoadingState(authorsLoading));
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

class ConnectivityFail extends AppState {}

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
