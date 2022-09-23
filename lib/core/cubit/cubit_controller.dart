import 'package:Oku/view/filter/author.dart';
import 'package:Oku/view/filter/category.dart';
import 'package:Oku/view/filter/group.dart';
import 'package:Oku/view/home_page.dart';
import 'package:Oku/view/settings/index.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:Oku/config/config.dart' as conf;
import 'package:Oku/config/config.dart';
import 'package:Oku/core/caching/IHiveController.dart';
import 'package:Oku/core/model/article.dart';
import 'package:Oku/core/model/opinion.dart';
import 'package:Oku/core/model/user.dart';
import 'package:Oku/core/network/connectivity_change.dart';
import 'package:Oku/core/service/IService.dart';
import 'package:Oku/utility/toast.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CubitController extends Cubit<AppState> {
  //service
  final IService service;
  //hive
  final IHiveController hive;
  //network
  bool isConnected = true;
  final INetworkChangeManager _networkChange = NetworkChangeManager();
  //current page id -- default is home page
  int currentPage = 0;

  //need update
  bool needUpdate = false;

  CubitController({required this.service, required this.hive})
      : super(InitState()) {
    conf.Session.controller!.addListener(getArticlesOnScroll);
    conf.Session.controllerTitle!.addListener(getTitlesOnScroll);

    _networkChange.handleNetworkChange((result) {
      updateOnConnectivity(result);
    });
  }

  ///Network Listen
  void updateOnConnectivity(NetworkResult result) async {
    if (result == NetworkResult.on) {
      //get current version of app from firebase
      String? currentVersion = await service.getVersion();

      //get installed app info
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      AppConfig.appName = packageInfo.appName;
      AppConfig.packageName = packageInfo.packageName;
      AppConfig.buildNumber = packageInfo.buildNumber;
      AppConfig.version = packageInfo.version;

      if (currentVersion != AppConfig.version) {
        changeNeedUpdate(true);
      }

      isConnected = true;
      if (articles.isEmpty && currentPage == HomePage.id) {
        getArticles();
      }
      if (allTitles.isEmpty && currentPage == IndexPage.id) {
        getTitles();
      }
      if (categories.isEmpty && currentPage == Category.id) {
        getCategories();
      }
      if (groups.isEmpty && currentPage == Group.id) {
        getGroups();
      }
      if (authors.isEmpty && currentPage == Author.id) {
        getAuthors();
      }
      emit(ConnectivitySuccess());
    } else {
      isConnected = false;
      emit(ConnectivityFail());
    }
  }

  ///

  ///---------------- API related variables ----------------- ///

  //received data
  List<Article> articles = [];
  List<String> allTitles = [];

  //selected read article
  List<Article> selectedReadArticle = [];

  ///favorite articles (library)
  Map<dynamic, Article> favorites = {};

  //read articles
  Map<int, String> readArticles = {};

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
  String titlesCursor = '';

  ///order by id - last articles id is the biggest
  ///Default = last article show at first
  String orderBy = 'desc';

  ///is there any data left to get from server?
  bool hasMoreData = true;
  bool hasMoreTitleData = true;

  ///--------- END OF API RELATED VARIABLES ---------///

  ///notifications on-off
  bool notificationsOn = true;

  ///up visible
  bool upVisible = false;

  ///filter screen visibility
  bool isFilterScreenVisible = false;

  ///article open/closed
  bool isArticleOpen = false;

  ///selected page - default --> home page
  int pageIndex = 0;

  ///data loading
  bool articlesLoading = false;
  bool titlesLoading = false;

  ///read article loading
  bool readArticleLoading = false;

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

  ///scroll loading
  bool titlesLoadingScroll = false;

  ///search bar visible
  bool searchBarVisible = false;

  ///font settings visible
  bool fontSettingsVisible = false;

  ///show read articles
  bool showReadArticles = true;

  ///selected font size
  double selectedFontSize = 16; // default small

  ///selected font color
  Color fontColor = conf.defaultFontColor;

  ///--------------SERVICE / NETWORK CALLS------------------

  ///get user
  Future<void> getUserNotificationPref(String id) async {
    //check connectivity
    if (isConnected) {
      var data = await service.getUser(id);
      if (data != null) {
        //get notification preference
        notificationsOn = data.notificationStatus!;
        emit(NotifyPipe());
      } else {
        //user does not exists, then post user
        await service.postUser(
          User(
            id: conf.AppConfig.deviceId,
            notificationStatus: true,
            device: conf.AppConfig.device,
          ),
        );
      }
    }
  }

  ///get current version
  Future<String> getCurrentVersion() async {
    if (isConnected) {
      var data = await service.getVersion();
      if (data != null) {
        return data;
      }
    }
    return '-1';
  }

  ///get articles
  Future<void> getArticles() async {
    //check connectivity
    if (isConnected && articles.isEmpty) {
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
        var ids = articles.map((e) => e.id).toList();
        for (var element in data) {
          if (!ids.contains(element.id)) {
            articles.add(element);
          }
        }
        //articles.addAll(data);
        cursor = articles.last.id!;
        emit(ArticlesSuccess(data));
        if (data.length < conf.AppConfig.requestedDataQuantity) {
          changeMoreDataStatus(false);
        }
      } else {
        emit(ArticlesFail());
      }
    }
  }

  ///get articles
  Future<void> getTitles() async {
    //check connectivity
    if (isConnected) {
      if (allTitles.isEmpty) {
        changeTitlesLoading(true);
        final data = await service.getTitles({
          'orderby': 'asc',
          'start': titlesCursor,
          'limit': conf.AppConfig.titlesRequestedDataQuantity,
        });
        changeTitlesLoading(false);
        if (data.isNotEmpty) {
          allTitles.addAll(data);
          titlesCursor = allTitles.last;
          emit(NotifyPipe());
          if (data.length < conf.AppConfig.titlesRequestedDataQuantity) {
            changeMoreDataStatus(false);
          }
        } else {
          emit(TitlesFail());
        }
      }
    }
  }

  ///get specified article
  Future<void> getArticle(int id) async {
    //check connectivity
    if (isConnected) {
      var article =
          selectedReadArticle.where((element) => element.id == id).toList();
      if (article.isEmpty) {
        changeReadArticlesLoading(true);
        final data = await service.getArticle(id);
        changeReadArticlesLoading(false);
        if (data != null) {
          selectedReadArticle.add(data);
        } else {
          emit(ArticlesFail());
        }
      } else {
        emit(NotifyPipe());
      }
    }
  }

  ///add opinion
  Future<void> addOpinion(Opinion opinion) async {
    if (isConnected) {
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
    double pos = conf.Session.controller!.position.pixels;
    if (pos > 1000) {
      changeUpVisible(true);
    } else {
      changeUpVisible(false);
    }
    if (isConnected) {
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
    emit(NotifyPipe());
  }

  ///get articles on scroll
  void getTitlesOnScroll() async {
    if (isConnected) {
      if (hasMoreTitleData &&
          conf.Session.controllerTitle!.position.extentAfter < 300 &&
          titlesLoadingScroll == false) {
        changeTitlesScrollLoading(true);
        final data = await service.getTitles({
          'orderby': 'asc',
          'start': titlesCursor,
          'limit': conf.AppConfig.titlesRequestedDataQuantity,
        });
        changeTitlesScrollLoading(false);
        if (data.isNotEmpty) {
          allTitles.addAll(data);
          titlesCursor = allTitles.last;
          emit(NotifyPipe());
          if (data.length < conf.AppConfig.titlesRequestedDataQuantity) {
            changeMoreDataStatusTitle(false);
          }
        }
      }
    } else {}
  }

  ///get all categories - run at startup
  Future<void> getCategories() async {
    if (isConnected && categories.isEmpty) {
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
    if (isConnected || authors.isEmpty) {
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
    if (isConnected && groups.isEmpty) {
      changeGroupsLoading(true);
      final data = await service.getAllGroups();
      changeGroupsLoading(false);
      if (data.isNotEmpty) {
        groups = data as List<String>;
      }
    } else {}
  }

  ///search by filter
  void resetAndSearch() async {
    if (isConnected) {
      changeUpVisible(false);
      cursor = -1;
      articles = [];
      hasMoreData = true;
      await getArticles();
    }
  }

  void changeUpVisible(bool b) {
    upVisible = b;
    emit(NotifyPipe());
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

  /// ------------- GUI CHANGES -------------------

  ///change current page id
  void changeCurrentPage(int id) {
    currentPage = id;
    emit(NotifyPipe());
  }

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

  ///get font size
  void getReadArticlesVisibility() {
    showReadArticles = hive.getReadArticlesVisibility();
    emit(NotifyPipe());
  }

  ///add font size
  void toggleReadArticlesVisibility() {
    hive.toggleReadArticlesVisibility(!showReadArticles);
    changeReadArticlesVisibility();
    emit(NotifyPipe());
  }

  //add read article id
  void addToReadArticles(int id, String title) {
    hive.addReadArticle(id, title);
    readArticles.putIfAbsent(id, () => title);
    showToastMessage(conf.addedToReadArticles);
    emit(NotifyPipe());
  }

  ///remove from read articles
  void removeFromReadArticles(int id) {
    hive.removeFromReadArticle(id);
    readArticles.remove(id);
    showToastMessage(conf.removeFromReadArticles);
    emit(NotifyPipe());
  }

  ///get all read articles
  void getAllReadArticles() {
    readArticles.clear();
    var readArticleTemp = hive.getReadArticles();
    readArticles =
        readArticleTemp.map((key, value) => MapEntry(key as int, value));
    emit(NotifyPipe());
  }

  ///get all read articles
  void clearReadArticles() {
    readArticles.clear();
    hive.clearReadArticles();
    showToastMessage('Okunan Yazılar Listesi Temizlendi.');
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

  ///change title hasMoreData property
  void changeMoreDataStatusTitle(bool b) {
    hasMoreTitleData = b;
    emit(NotifyPipe());
  }

  ///change search bar visibility
  void changeSearchBarVisibility() {
    searchBarVisible = !searchBarVisible;
    emit(NotifyPipe());
  }

  ///change read articles visibility
  void changeReadArticlesVisibility() {
    showReadArticles = !showReadArticles;
    showReadArticles
        ? showToastMessage(conf.showReadArticles)
        : showToastMessage(conf.dontShowReadArticles);
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

  ///change need update status
  void changeNeedUpdate(bool b) {
    needUpdate = b;
    emit(NotifyPipe());
  }

  ///article loading state change
  void changeArticlesLoading(bool b) {
    articlesLoading = b;
    emit(ArticlesLoadingState(articlesLoading));
  }

  ///titles loading state change
  void changeTitlesLoading(bool b) {
    titlesLoading = b;
    emit(NotifyPipe());
  }

  ///read article loading state change
  void changeReadArticlesLoading(bool b) {
    readArticleLoading = b;
    emit(NotifyPipe());
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

  ///title scroll loading state change
  void changeTitlesScrollLoading(bool b) {
    titlesLoadingScroll = b;
    emit(NotifyPipe());
  }
}

abstract class AppState {}

class NotifyPipe extends AppState {}

class ConnectivityFail extends AppState {}

class ConnectivitySuccess extends AppState {}

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

///article get success
class ArticleGetSuccess extends AppState {
  final Article article;

  ArticleGetSuccess(this.article);
}

///articles get fails
class ArticlesFail extends AppState {}

///titles get fails
class TitlesFail extends AppState {}

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
