// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Submit Ad`
  String get submitAd {
    return Intl.message('Submit Ad', name: 'submitAd', desc: '', args: []);
  }

  /// `Category Types`
  String get categoryTypes {
    return Intl.message(
      'Category Types',
      name: 'categoryTypes',
      desc: '',
      args: [],
    );
  }

  /// `Equipment`
  String get equipment {
    return Intl.message('Equipment', name: 'equipment', desc: '', args: []);
  }

  /// `Horse`
  String get horse {
    return Intl.message('Horse', name: 'horse', desc: '', args: []);
  }

  /// `Event`
  String get event {
    return Intl.message('Event', name: 'event', desc: '', args: []);
  }

  /// `Describe Fully`
  String get describeFully {
    return Intl.message(
      'Describe Fully',
      name: 'describeFully',
      desc: '',
      args: [],
    );
  }

  /// `Add Photo`
  String get addPhoto {
    return Intl.message('Add Photo', name: 'addPhoto', desc: '', args: []);
  }

  /// `Ad Name`
  String get adName {
    return Intl.message('Ad Name', name: 'adName', desc: '', args: []);
  }

  /// `Short Description`
  String get shortDescription {
    return Intl.message(
      'Short Description',
      name: 'shortDescription',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Описание', name: 'description');
  }

  /// `Event Date`
  String get eventDate {
    return Intl.message('Event Date', name: 'eventDate', desc: '', args: []);
  }

  /// `Event Location`
  String get eventLocation {
    return Intl.message(
      'Event Location',
      name: 'eventLocation',
      desc: '',
      args: [],
    );
  }

  /// `Prize Fund`
  String get prizeFund {
    return Intl.message('Prize Fund', name: 'prizeFund', desc: '', args: []);
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Preview`
  String get preview {
    return Intl.message('Preview', name: 'preview', desc: '', args: []);
  }

  /// `Publish`
  String get publish {
    return Intl.message('Publish', name: 'publish', desc: '', args: []);
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Settlement`
  String get settlement {
    return Intl.message('Settlement', name: 'settlement', desc: '', args: []);
  }

  /// `Negotiable`
  String get negotiable {
    return Intl.message('Negotiable', name: 'negotiable', desc: '', args: []);
  }

  /// `Condition`
  String get condition {
    return Intl.message('Condition', name: 'condition', desc: '', args: []);
  }

  /// `International`
  String get international {
    return Intl.message(
      'International',
      name: 'international',
      desc: '',
      args: [],
    );
  }

  /// `Regional`
  String get regional {
    return Intl.message('Regional', name: 'regional', desc: '', args: []);
  }

  /// `State`
  String get state {
    return Intl.message('State', name: 'state', desc: '', args: []);
  }

  /// `Rural`
  String get rural {
    return Intl.message('Rural', name: 'rural', desc: '', args: []);
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message('Change', name: 'change', desc: '', args: []);
  }

  /// `Change Name`
  String get changeName {
    return Intl.message('Change Name', name: 'changeName', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `My Ads`
  String get myAds {
    return Intl.message('My Ads', name: 'myAds', desc: '', args: []);
  }

  /// `Information`
  String get information {
    return Intl.message('Information', name: 'information', desc: '', args: []);
  }

  /// `Horse Harness`
  String get horseHarness {
    return Intl.message(
      'Horse Harness',
      name: 'horseHarness',
      desc: '',
      args: [],
    );
  }

  /// `Saddle`
  String get saddle {
    return Intl.message('Saddle', name: 'saddle', desc: '', args: []);
  }

  /// `Halter`
  String get halter {
    return Intl.message('Halter', name: 'halter', desc: '', args: []);
  }

  /// `Bridle`
  String get bridle {
    return Intl.message('Bridle', name: 'bridle', desc: '', args: []);
  }

  /// `Stirrup`
  String get stirrup {
    return Intl.message('Stirrup', name: 'stirrup', desc: '', args: []);
  }

  /// `Horseshoe`
  String get horseshoe {
    return Intl.message('Horseshoe', name: 'horseshoe', desc: '', args: []);
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `Horse Care`
  String get horseCare {
    return Intl.message('Horse Care', name: 'horseCare', desc: '', args: []);
  }

  /// `Horseshoe Stand`
  String get horseshoeStand {
    return Intl.message(
      'Horseshoe Stand',
      name: 'horseshoeStand',
      desc: '',
      args: [],
    );
  }

  /// `Brushes`
  String get brushes {
    return Intl.message('Brushes', name: 'brushes', desc: '', args: []);
  }

  /// `Feed/Grass`
  String get feedGrass {
    return Intl.message('Feed/Grass', name: 'feedGrass', desc: '', args: []);
  }

  /// `Care Tools`
  String get careTools {
    return Intl.message('Care Tools', name: 'careTools', desc: '', args: []);
  }

  /// `For Rider`
  String get forRider {
    return Intl.message('For Rider', name: 'forRider', desc: '', args: []);
  }

  /// `Shoes`
  String get shoes {
    return Intl.message('Shoes', name: 'shoes', desc: '', args: []);
  }

  /// `Whip`
  String get whip {
    return Intl.message('Whip', name: 'whip', desc: '', args: []);
  }

  /// `Headgear`
  String get headgear {
    return Intl.message('Headgear', name: 'headgear', desc: '', args: []);
  }

  /// `Clothing`
  String get clothing {
    return Intl.message('Clothing', name: 'clothing', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Send SMS code`
  String get sendSMSCode {
    return Intl.message(
      'Send SMS code',
      name: 'sendSMSCode',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Last name`
  String get lastName {
    return Intl.message('Last name', name: 'lastName', desc: '', args: []);
  }

  /// `City`
  String get city {
    return Intl.message('City', name: 'city', desc: '', args: []);
  }

  /// `Already registered`
  String get alreadyRegistered {
    return Intl.message(
      'Already registered',
      name: 'alreadyRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Resend code`
  String get resendCode {
    return Intl.message('Resend code', name: 'resendCode', desc: '', args: []);
  }

  /// `Events`
  String get events {
    return Intl.message('Events', name: 'events', desc: '', args: []);
  }

  /// `Ads`
  String get ads {
    return Intl.message('Ads', name: 'ads', desc: '', args: []);
  }

  /// `Types of advertisements`
  String get typesAdvertisements {
    return Intl.message(
      'Types of advertisements',
      name: 'typesAdvertisements',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Favorites`
  String get favorites {
    return Intl.message('Favorites', name: 'favorites', desc: '', args: []);
  }

  /// `New ad`
  String get newAd {
    return Intl.message('New ad', name: 'newAd', desc: '', args: []);
  }

  /// `Featured events will be displayed here`
  String get featuredEventsWillBeDisplayedHere {
    return Intl.message(
      'Featured events will be displayed here',
      name: 'featuredEventsWillBeDisplayedHere',
      desc: '',
      args: [],
    );
  }

  /// `Featured ads will be displayed here`
  String get featuredAdsWillBeDisplayedHere {
    return Intl.message(
      'Featured ads will be displayed here',
      name: 'featuredAdsWillBeDisplayedHere',
      desc: '',
      args: [],
    );
  }

  /// `Select categories`
  String get selectCategories {
    return Intl.message(
      'Select categories',
      name: 'selectCategories',
      desc: '',
      args: [],
    );
  }

  /// `Select Subcategories`
  String get selectSubCategories {
    return Intl.message(
      'Select Subcategories',
      name: 'selectSubCategories',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message('Share', name: 'share', desc: '', args: []);
  }

  /// `Feedback`
  String get feedback {
    return Intl.message('Feedback', name: 'feedback', desc: '', args: []);
  }

  /// `Rate Us`
  String get rateUs {
    return Intl.message('Rate Us', name: 'rateUs', desc: '', args: []);
  }

  /// `Edit photo`
  String get editPhoto {
    return Intl.message('Edit photo', name: 'editPhoto', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Delete account`
  String get deleteAccount {
    return Intl.message(
      'Delete account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Region`
  String get region {
    return Intl.message('Region', name: 'region', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Required field`
  String get requiredField {
    return Intl.message(
      'Required field',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `Contact Seller`
  String get contactSeller {
    return Intl.message('Связаться с продавцом', name: 'contactSeller');
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'kk'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
