///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsEn with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsEn _root = this; // ignore: unused_field

	@override 
	TranslationsEn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEn(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$common$en common = _Translations$common$en._(_root);
	@override late final _Translations$errors$en errors = _Translations$errors$en._(_root);
}

// Path: common
class _Translations$common$en implements Translations$common$ar {
	_Translations$common$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get appName => 'Moto Orbito';
	@override String get retry => 'Retry';
	@override String get cancel => 'Cancel';
	@override String get confirm => 'Confirm';
	@override String get save => 'Save';
	@override String get loading => 'Loading';
	@override String get dashboard => 'Dashboard';
	@override String get groups => 'Groups';
	@override String get liveMap => 'Live Map';
	@override String get maintenance => 'Maintenance';
	@override String get profile => 'Profile';
	@override String get noConnectionTitle => 'No connection';
	@override String get noConnectionMessage => 'The service could not be reached. Check your network and try again.';
	@override String get emptyTitle => 'No data yet';
	@override String get emptyMessage => 'Items will appear here when they are available.';
}

// Path: errors
class _Translations$errors$en implements Translations$errors$ar {
	_Translations$errors$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get network => 'Could not connect to the network. Try again.';
	@override String get server => 'A server error occurred. Try again later.';
	@override String get auth => 'Your session expired or you are not authorized.';
	@override String get notFound => 'The requested item was not found.';
	@override String get permission => 'You do not have the required permission.';
	@override String get storage => 'The requested file could not be processed.';
	@override String get unexpected => 'An unexpected error occurred.';
	@override String get fieldRequired => 'This field is required.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEn {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.appName' => 'Moto Orbito',
			'common.retry' => 'Retry',
			'common.cancel' => 'Cancel',
			'common.confirm' => 'Confirm',
			'common.save' => 'Save',
			'common.loading' => 'Loading',
			'common.dashboard' => 'Dashboard',
			'common.groups' => 'Groups',
			'common.liveMap' => 'Live Map',
			'common.maintenance' => 'Maintenance',
			'common.profile' => 'Profile',
			'common.noConnectionTitle' => 'No connection',
			'common.noConnectionMessage' => 'The service could not be reached. Check your network and try again.',
			'common.emptyTitle' => 'No data yet',
			'common.emptyMessage' => 'Items will appear here when they are available.',
			'errors.network' => 'Could not connect to the network. Try again.',
			'errors.server' => 'A server error occurred. Try again later.',
			'errors.auth' => 'Your session expired or you are not authorized.',
			'errors.notFound' => 'The requested item was not found.',
			'errors.permission' => 'You do not have the required permission.',
			'errors.storage' => 'The requested file could not be processed.',
			'errors.unexpected' => 'An unexpected error occurred.',
			'errors.fieldRequired' => 'This field is required.',
			_ => null,
		};
	}
}
