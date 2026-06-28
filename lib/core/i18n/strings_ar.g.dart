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
	late final Translations$auth$ar auth = Translations$auth$ar._(_root);
	late final Translations$onboarding$ar onboarding = Translations$onboarding$ar._(_root);
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

// Path: auth
class Translations$auth$ar {
	Translations$auth$ar._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// ar: 'البريد الإلكتروني مسجل بالفعل.'
	String get emailAlreadyExists => 'البريد الإلكتروني مسجل بالفعل.';

	/// ar: 'يرجى تأكيد بريدك الإلكتروني أولاً.'
	String get emailNotVerified => 'يرجى تأكيد بريدك الإلكتروني أولاً.';

	/// ar: 'بيانات تسجيل الدخول غير صحيحة.'
	String get invalidCredentials => 'بيانات تسجيل الدخول غير صحيحة.';

	/// ar: 'رمز التحقق غير صحيح.'
	String get invalidOtp => 'رمز التحقق غير صحيح.';

	/// ar: 'انتهت صلاحية رمز التحقق.'
	String get otpExpired => 'انتهت صلاحية رمز التحقق.';

	late final Translations$auth$deleteAccount$ar deleteAccount = Translations$auth$deleteAccount$ar._(_root);
	late final Translations$auth$signUp$ar signUp = Translations$auth$signUp$ar._(_root);
	late final Translations$auth$login$ar login = Translations$auth$login$ar._(_root);
	late final Translations$auth$verifyEmail$ar verifyEmail = Translations$auth$verifyEmail$ar._(_root);
	late final Translations$auth$verifyPhone$ar verifyPhone = Translations$auth$verifyPhone$ar._(_root);
	late final Translations$auth$welcome$ar welcome = Translations$auth$welcome$ar._(_root);
	late final Translations$auth$forgotPassword$ar forgotPassword = Translations$auth$forgotPassword$ar._(_root);
	late final Translations$auth$socialLogin$ar socialLogin = Translations$auth$socialLogin$ar._(_root);
}

// Path: onboarding
class Translations$onboarding$ar {
	Translations$onboarding$ar._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$onboarding$slide1$ar slide1 = Translations$onboarding$slide1$ar._(_root);
	late final Translations$onboarding$slide2$ar slide2 = Translations$onboarding$slide2$ar._(_root);
	late final Translations$onboarding$slide3$ar slide3 = Translations$onboarding$slide3$ar._(_root);

	/// ar: 'تخطي'
	String get skip => 'تخطي';

	/// ar: 'التالي'
	String get next => 'التالي';

	/// ar: 'ابدأ الآن'
	String get getStarted => 'ابدأ الآن';
}

// Path: auth.deleteAccount
class Translations$auth$deleteAccount$ar {
	Translations$auth$deleteAccount$ar._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// ar: 'DELETE'
	String get confirmPhrase => 'DELETE';

	/// ar: 'حذف الحساب'
	String get title => 'حذف الحساب';

	/// ar: 'هذا الإجراء لا يمكن التراجع عنه. سيتم حذف جميع بياناتك نهائياً.'
	String get warning => 'هذا الإجراء لا يمكن التراجع عنه. سيتم حذف جميع بياناتك نهائياً.';

	/// ar: 'اكتب DELETE للتأكيد:'
	String get typeToConfirm => 'اكتب DELETE للتأكيد:';

	/// ar: 'حذف'
	String get deleteButton => 'حذف';

	/// ar: 'إلغاء'
	String get cancel => 'إلغاء';
}

// Path: auth.signUp
class Translations$auth$signUp$ar {
	Translations$auth$signUp$ar._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// ar: 'إنشاء حساب'
	String get title => 'إنشاء حساب';

	/// ar: 'الاسم الكامل'
	String get fullName => 'الاسم الكامل';

	/// ar: 'البريد الإلكتروني'
	String get email => 'البريد الإلكتروني';

	/// ar: 'كلمة المرور'
	String get password => 'كلمة المرور';

	/// ar: 'رقم الهاتف'
	String get phone => 'رقم الهاتف';

	/// ar: 'إنشاء حساب'
	String get submit => 'إنشاء حساب';

	/// ar: 'تم إنشاء الحساب بنجاح'
	String get success => 'تم إنشاء الحساب بنجاح';
}

// Path: auth.login
class Translations$auth$login$ar {
	Translations$auth$login$ar._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// ar: 'تسجيل الدخول'
	String get title => 'تسجيل الدخول';

	/// ar: 'البريد الإلكتروني'
	String get email => 'البريد الإلكتروني';

	/// ar: 'كلمة المرور'
	String get password => 'كلمة المرور';

	/// ar: 'تسجيل الدخول'
	String get submit => 'تسجيل الدخول';

	/// ar: 'نسيت كلمة المرور؟'
	String get forgotPassword => 'نسيت كلمة المرور؟';
}

// Path: auth.verifyEmail
class Translations$auth$verifyEmail$ar {
	Translations$auth$verifyEmail$ar._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// ar: 'تأكيد البريد الإلكتروني'
	String get title => 'تأكيد البريد الإلكتروني';

	/// ar: 'أدخل الرمز المرسل إلى بريدك الإلكتروني'
	String get description => 'أدخل الرمز المرسل إلى بريدك الإلكتروني';

	/// ar: 'رمز التحقق'
	String get otpLabel => 'رمز التحقق';

	/// ar: 'تأكيد'
	String get verify => 'تأكيد';

	/// ar: 'إعادة إرسال الرمز'
	String get resend => 'إعادة إرسال الرمز';

	/// ar: 'لا توجد محاولات متبقية'
	String get noResendsLeft => 'لا توجد محاولات متبقية';

	/// ar: 'تم الوصول إلى الحد الأقصى من المحاولات.'
	String get maxAttemptsReached => 'تم الوصول إلى الحد الأقصى من المحاولات.';
}

// Path: auth.verifyPhone
class Translations$auth$verifyPhone$ar {
	Translations$auth$verifyPhone$ar._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// ar: 'تأكيد رقم الهاتف'
	String get title => 'تأكيد رقم الهاتف';

	/// ar: 'أدخل الرمز المرسل إلى هاتفك'
	String get description => 'أدخل الرمز المرسل إلى هاتفك';

	/// ar: 'تخطي الآن'
	String get skip => 'تخطي الآن';

	/// ar: 'تأكيد'
	String get verify => 'تأكيد';
}

// Path: auth.welcome
class Translations$auth$welcome$ar {
	Translations$auth$welcome$ar._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// ar: 'مرحباً بك في موتو أوربيتو'
	String get title => 'مرحباً بك في موتو أوربيتو';

	/// ar: 'اركب معاً، ابق في المدار'
	String get subtitle => 'اركب معاً، ابق في المدار';

	/// ar: 'المتابعة عبر Google'
	String get google => 'المتابعة عبر Google';

	/// ar: 'المتابعة عبر Facebook'
	String get facebook => 'المتابعة عبر Facebook';

	/// ar: 'أو'
	String get or => 'أو';

	/// ar: 'إنشاء حساب'
	String get signUp => 'إنشاء حساب';

	/// ar: 'تسجيل الدخول'
	String get logIn => 'تسجيل الدخول';
}

// Path: auth.forgotPassword
class Translations$auth$forgotPassword$ar {
	Translations$auth$forgotPassword$ar._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// ar: 'إعادة تعيين كلمة المرور'
	String get title => 'إعادة تعيين كلمة المرور';

	/// ar: 'أدخل بريدك الإلكتروني لاستلام رابط إعادة التعيين'
	String get description => 'أدخل بريدك الإلكتروني لاستلام رابط إعادة التعيين';

	/// ar: 'البريد الإلكتروني'
	String get email => 'البريد الإلكتروني';

	/// ar: 'إرسال رابط إعادة التعيين'
	String get send => 'إرسال رابط إعادة التعيين';

	/// ar: 'تحقق من بريدك الإلكتروني لاستلام رابط إعادة التعيين.'
	String get success => 'تحقق من بريدك الإلكتروني لاستلام رابط إعادة التعيين.';
}

// Path: auth.socialLogin
class Translations$auth$socialLogin$ar {
	Translations$auth$socialLogin$ar._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// ar: 'فشل تسجيل الدخول عبر Google. حاول مرة أخرى.'
	String get googleError => 'فشل تسجيل الدخول عبر Google. حاول مرة أخرى.';

	/// ar: 'فشل تسجيل الدخول عبر Facebook. حاول مرة أخرى.'
	String get facebookError => 'فشل تسجيل الدخول عبر Facebook. حاول مرة أخرى.';
}

// Path: onboarding.slide1
class Translations$onboarding$slide1$ar {
	Translations$onboarding$slide1$ar._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// ar: 'اركب معاً'
	String get title => 'اركب معاً';

	/// ar: 'تواصل مع زملائك الدراجين واستكشف طرقاً جديدة معاً.'
	String get description => 'تواصل مع زملائك الدراجين واستكشف طرقاً جديدة معاً.';
}

// Path: onboarding.slide2
class Translations$onboarding$slide2$ar {
	Translations$onboarding$slide2$ar._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// ar: 'ابق في المدار'
	String get title => 'ابق في المدار';

	/// ar: 'تتبع رحلاتك، وراقب أدائك، وابق على اتصال.'
	String get description => 'تتبع رحلاتك، وراقب أدائك، وابق على اتصال.';
}

// Path: onboarding.slide3
class Translations$onboarding$slide3$ar {
	Translations$onboarding$slide3$ar._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// ar: 'قد بذكاء'
	String get title => 'قد بذكاء';

	/// ar: 'احصل على تحليلات ذكية وتذكيرات صيانة.'
	String get description => 'احصل على تحليلات ذكية وتذكيرات صيانة.';
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
			'auth.emailAlreadyExists' => 'البريد الإلكتروني مسجل بالفعل.',
			'auth.emailNotVerified' => 'يرجى تأكيد بريدك الإلكتروني أولاً.',
			'auth.invalidCredentials' => 'بيانات تسجيل الدخول غير صحيحة.',
			'auth.invalidOtp' => 'رمز التحقق غير صحيح.',
			'auth.otpExpired' => 'انتهت صلاحية رمز التحقق.',
			'auth.deleteAccount.confirmPhrase' => 'DELETE',
			'auth.deleteAccount.title' => 'حذف الحساب',
			'auth.deleteAccount.warning' => 'هذا الإجراء لا يمكن التراجع عنه. سيتم حذف جميع بياناتك نهائياً.',
			'auth.deleteAccount.typeToConfirm' => 'اكتب DELETE للتأكيد:',
			'auth.deleteAccount.deleteButton' => 'حذف',
			'auth.deleteAccount.cancel' => 'إلغاء',
			'auth.signUp.title' => 'إنشاء حساب',
			'auth.signUp.fullName' => 'الاسم الكامل',
			'auth.signUp.email' => 'البريد الإلكتروني',
			'auth.signUp.password' => 'كلمة المرور',
			'auth.signUp.phone' => 'رقم الهاتف',
			'auth.signUp.submit' => 'إنشاء حساب',
			'auth.signUp.success' => 'تم إنشاء الحساب بنجاح',
			'auth.login.title' => 'تسجيل الدخول',
			'auth.login.email' => 'البريد الإلكتروني',
			'auth.login.password' => 'كلمة المرور',
			'auth.login.submit' => 'تسجيل الدخول',
			'auth.login.forgotPassword' => 'نسيت كلمة المرور؟',
			'auth.verifyEmail.title' => 'تأكيد البريد الإلكتروني',
			'auth.verifyEmail.description' => 'أدخل الرمز المرسل إلى بريدك الإلكتروني',
			'auth.verifyEmail.otpLabel' => 'رمز التحقق',
			'auth.verifyEmail.verify' => 'تأكيد',
			'auth.verifyEmail.resend' => 'إعادة إرسال الرمز',
			'auth.verifyEmail.noResendsLeft' => 'لا توجد محاولات متبقية',
			'auth.verifyEmail.maxAttemptsReached' => 'تم الوصول إلى الحد الأقصى من المحاولات.',
			'auth.verifyPhone.title' => 'تأكيد رقم الهاتف',
			'auth.verifyPhone.description' => 'أدخل الرمز المرسل إلى هاتفك',
			'auth.verifyPhone.skip' => 'تخطي الآن',
			'auth.verifyPhone.verify' => 'تأكيد',
			'auth.welcome.title' => 'مرحباً بك في موتو أوربيتو',
			'auth.welcome.subtitle' => 'اركب معاً، ابق في المدار',
			'auth.welcome.google' => 'المتابعة عبر Google',
			'auth.welcome.facebook' => 'المتابعة عبر Facebook',
			'auth.welcome.or' => 'أو',
			'auth.welcome.signUp' => 'إنشاء حساب',
			'auth.welcome.logIn' => 'تسجيل الدخول',
			'auth.forgotPassword.title' => 'إعادة تعيين كلمة المرور',
			'auth.forgotPassword.description' => 'أدخل بريدك الإلكتروني لاستلام رابط إعادة التعيين',
			'auth.forgotPassword.email' => 'البريد الإلكتروني',
			'auth.forgotPassword.send' => 'إرسال رابط إعادة التعيين',
			'auth.forgotPassword.success' => 'تحقق من بريدك الإلكتروني لاستلام رابط إعادة التعيين.',
			'auth.socialLogin.googleError' => 'فشل تسجيل الدخول عبر Google. حاول مرة أخرى.',
			'auth.socialLogin.facebookError' => 'فشل تسجيل الدخول عبر Facebook. حاول مرة أخرى.',
			'onboarding.slide1.title' => 'اركب معاً',
			'onboarding.slide1.description' => 'تواصل مع زملائك الدراجين واستكشف طرقاً جديدة معاً.',
			'onboarding.slide2.title' => 'ابق في المدار',
			'onboarding.slide2.description' => 'تتبع رحلاتك، وراقب أدائك، وابق على اتصال.',
			'onboarding.slide3.title' => 'قد بذكاء',
			'onboarding.slide3.description' => 'احصل على تحليلات ذكية وتذكيرات صيانة.',
			'onboarding.skip' => 'تخطي',
			'onboarding.next' => 'التالي',
			'onboarding.getStarted' => 'ابدأ الآن',
			_ => null,
		};
	}
}
