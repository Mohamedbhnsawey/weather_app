import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/controller/homeController/homeStates.dart';
import 'package:weather/model/currrentModel.dart';
import 'package:weather/model/forcastModel.dart';
import 'package:weather/model/searchModel.dart';
import 'package:weather/network/endpoint.dart';
import 'package:weather/network/remote/dio_helper.dart';
import 'package:geolocator/geolocator.dart';

class Homecontroller extends Cubit<Homestates> {
  Homecontroller() : super(HomeInitstates());

  static Homecontroller get(context) => BlocProvider.of(context);
  final apikey = 'b975bc54c92d48e5ba084357241007';
  final PageController pageController = PageController();
  int currentPage = 0;
  
  onPageChanged(int index) {
    currentPage = index;
    emit(changePageStates());
  }

  currentModel? currentmodel;
  bool isTxtFormVisiable = false;
  void changeTxtForm() {
    isTxtFormVisiable = true;
    emit(changeTxtFormStates());
  }

  void changeTxtForm2() {
    isTxtFormVisiable = false;
    emit(changeTxtFormStates2());
  }

  bool isTxtFormEmpty = true;

  TextEditingController SearchController = TextEditingController();

  Future<currentModel> getCurrent2({required String location}) async {
    return diohelper.getdata(url: CurrentTemp, query: {
      'q': location,
      'key': apikey,
    }).then((value) {
      return currentModel.fromJson(value!.data);
    }).catchError((onError) {
      // Handle the error here, e.g., throw an exception
      throw Exception('Failed to get current weather');
    });
  }

  // forcastModel? formastmodel2;
  Future<forcastModel> getForcast2(
      {required String location, int day = 10}) async {
    // getLocation();

    return diohelper.getdata(url: forcastTemp, query: {
      'q': location,
      'key': apikey,
      'days': day,
    }).then((value) {
      return forcastModel.fromJson(value!.data);
    }).catchError((onError) {
      // Handle the error here, e.g., throw an exception
      throw Exception('Failed to get forecast weather');
    });
  }

  Future<List<dynamic>> fetchDataParallel({required String location}) async {
    final futures = [
      getCurrent2(location: location),
      getForcast2(location: location)
    ];
    return Future.wait(futures);
  }

  var searchmodel = [];
  void getSearch() {
    if (SearchController.text.isEmpty) {
      isTxtFormEmpty = true;
    } else {
      isTxtFormEmpty = false;
    }
    emit(getsearchLoadingStates());
    diohelper.getdata(url: searchTemp, query: {
      'q': SearchController.text,
      'key': apikey,
    }).then((value) {
      searchmodel = value!.data as List<dynamic>;
      searchmodel
          .map((e) => searchModel.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(getsearchSuccessStates());
    }).catchError((onError) {
      emit(getsearchErrorStates());
    });
  }

  String myLocation = '';

  void getLocation2() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      myLocation = "${position.latitude},${position.longitude}";
      emit(mylocationStates());
      // fetchDataParallel(location: "${position.latitude},${position.longitude}");
    } catch (e) {}
  }
}
