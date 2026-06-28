///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsAr = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ar,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ar>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$common$ar common = Translations$common$ar._(_root);
	late final Translations$errors$ar errors = Translations$errors$ar._(_root);
}

// Path: common
class Translations$common$ar {
	Translations$common$ar._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// ar: 'موتو أوربيتو'
	String get appName => 'موتو أوربيتو';

	/// ar: 'إعادة المحاولة'
	String get retry => 'إعادة المحاولة';

	/// ar: 'إلغاء'
	String get cancel => 'إلغاء';

	/// ar: 'تأكيد'
	String get confirm => 'تأكيد';

	/// ar: 'حفظ'
	String get save => 'حفظ';

	/// ar: 'جار التحميل'
	String get loading => 'جار التحميل';

	/// ar: 'الرئيسية'
	String get dashboard => 'الرئيسية';

	/// ar: 'المجموعات'
	String get groups => 'المجموعات';

	/// ar: 'الخريطة المباشرة'
	String get liveMap => 'الخريطة المباشرة';

	/// ar: 'الصيانة'
	String get maintenance => 'الصيانة';

	/// ar: 'الملف الشخصي'
	String get profile => 'الملف الشخصي';

	/// ar: 'لا يوجد اتصال'
	String get noConnectionTitle => 'لا يوجد اتصال';

	/// ar: 'تعذر الاتصال بالخدمة. تحقق من الشبكة ثم حاول مرة أخرى.'
	String get noConnectionMessage => 'تعذر الاتصال بالخدمة. تحقق من الشبكة ثم حاول مرة أخرى.';

	/// ar: 'لا توجد بيانات'
	String get emptyTitle => 'لا توجد بيانات';

	/// ar: 'ستظهر العناصر هنا عند توفرها.'
	String get emptyMessage => 'ستظهر العناصر هنا عند توفرها.';
}

// Path: errors
class Translations$errors$ar {
	Translations$errors$ar._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// ar: 'تعذر الاتصال بالشبكة. حاول مرة أخرى.'
	String get network => 'تعذر الاتصال بالشبكة. حاول مرة أخرى.';

	/// ar: 'حدث خطأ في الخادم. حاول لاحقا.'
	String get server => 'حدث خطأ في الخادم. حاول لاحقا.';

	/// ar: 'انتهت الجلسة أو غير مصرح لك.'
	String get auth => 'انتهت الجلسة أو غير مصرح لك.';

	/// ar: 'العنصر المطلوب غير موجود.'
	String get notFound => 'العنصر المطلوب غير موجود.';

	/// ar: 'لا تملك الصلاحية المطلوبة.'
	String get permission => 'لا تملك الصلاحية المطلوبة.';

	/// ar: 'تعذر معالجة الملف المطلوب.'
	String get storage => 'تعذر معالجة الملف المطلوب.';

	/// ar: 'حدث خطأ غير متوقع.'
	String get unexpected => 'حدث خطأ غير متوقع.';

	/// ar: 'هذا الحقل مطلوب.'
	String get fieldRequired => 'هذا الحقل مطلوب.';
}

/// The flat map containing all translations for locale <ar>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.appName' => 'موتو أوربيتو',
			'common.retry' => 'إعادة المحاولة',
			'common.cancel' => 'إلغاء',
			'common.confirm' => 'تأكيد',
			'common.save' => 'حفظ',
			'common.loading' => 'جار التحميل',
			'common.dashboard' => 'الرئيسية',
			'common.groups' => 'المجموعات',
			'common.liveMap' => 'الخريطة المباشرة',
			'common.maintenance' => 'الصيانة',
			'common.profile' => 'الملف الشخصي',
			'common.noConnectionTitle' => 'لا يوجد اتصال',
			'common.noConnectionMessage' => 'تعذر الاتصال بالخدمة. تحقق من الشبكة ثم حاول مرة أخرى.',
			'common.emptyTitle' => 'لا توجد بيانات',
			'common.emptyMessage' => 'ستظهر العناصر هنا عند توفرها.',
			'errors.network' => 'تعذر الاتصال بالشبكة. حاول مرة أخرى.',
			'errors.server' => 'حدث خطأ في الخادم. حاول لاحقا.',
			'errors.auth' => 'انتهت الجلسة أو غير مصرح لك.',
			'errors.notFound' => 'العنصر المطلوب غير موجود.',
			'errors.permission' => 'لا تملك الصلاحية المطلوبة.',
			'errors.storage' => 'تعذر معالجة الملف المطلوب.',
			'errors.unexpected' => 'حدث خطأ غير متوقع.',
			'errors.fieldRequired' => 'هذا الحقل مطلوب.',
			_ => null,
		};
	}
}
