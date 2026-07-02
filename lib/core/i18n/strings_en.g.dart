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
	@override late final _Translations$auth$en auth = _Translations$auth$en._(_root);
	@override late final _Translations$onboarding$en onboarding = _Translations$onboarding$en._(_root);
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
	@override String get cache => 'An error occurred while accessing the cache.';
}

// Path: auth
class _Translations$auth$en implements Translations$auth$ar {
	_Translations$auth$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get emailAlreadyExists => 'Email is already registered.';
	@override String get emailNotVerified => 'Please verify your email first.';
	@override String get emailUnverifiedExists => 'This email exists but is not verified. Redirecting to verification...';
	@override String get invalidCredentials => 'Invalid login credentials.';
	@override String get invalidOtp => 'Invalid verification code.';
	@override String get otpExpired => 'Verification code has expired.';
	@override late final _Translations$auth$deleteAccount$en deleteAccount = _Translations$auth$deleteAccount$en._(_root);
	@override late final _Translations$auth$signUp$en signUp = _Translations$auth$signUp$en._(_root);
	@override late final _Translations$auth$login$en login = _Translations$auth$login$en._(_root);
	@override late final _Translations$auth$verifyEmail$en verifyEmail = _Translations$auth$verifyEmail$en._(_root);
	@override late final _Translations$auth$verifyPhone$en verifyPhone = _Translations$auth$verifyPhone$en._(_root);
	@override late final _Translations$auth$welcome$en welcome = _Translations$auth$welcome$en._(_root);
	@override late final _Translations$auth$forgotPassword$en forgotPassword = _Translations$auth$forgotPassword$en._(_root);
	@override late final _Translations$auth$socialLogin$en socialLogin = _Translations$auth$socialLogin$en._(_root);
	@override late final _Translations$auth$profilePicture$en profilePicture = _Translations$auth$profilePicture$en._(_root);
}

// Path: onboarding
class _Translations$onboarding$en implements Translations$onboarding$ar {
	_Translations$onboarding$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override late final _Translations$onboarding$slide1$en slide1 = _Translations$onboarding$slide1$en._(_root);
	@override late final _Translations$onboarding$slide2$en slide2 = _Translations$onboarding$slide2$en._(_root);
	@override late final _Translations$onboarding$slide3$en slide3 = _Translations$onboarding$slide3$en._(_root);
	@override String get skip => 'Skip';
	@override String get next => 'Next';
	@override String get getStarted => 'Get Started';
}

// Path: auth.deleteAccount
class _Translations$auth$deleteAccount$en implements Translations$auth$deleteAccount$ar {
	_Translations$auth$deleteAccount$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get confirmPhrase => 'DELETE';
	@override String get title => 'Delete Account';
	@override String get warning => 'This action is irreversible. All your data will be permanently deleted.';
	@override String get typeToConfirm => 'Type DELETE to confirm:';
	@override String get deleteButton => 'Delete';
	@override String get cancel => 'Cancel';
}

// Path: auth.signUp
class _Translations$auth$signUp$en implements Translations$auth$signUp$ar {
	_Translations$auth$signUp$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Create Account';
	@override String get fullName => 'Full Name';
	@override String get username => 'Username';
	@override String get email => 'Email';
	@override String get invalidEmail => 'Please enter a valid email address';
	@override String get password => 'Password';
	@override String get passwordHint => 'Enter your password';
	@override String get confirmPassword => 'Confirm Password';
	@override String get confirmPasswordHint => 'Re-enter your password';
	@override String get passwordMismatch => 'Passwords do not match';
	@override String get passwordUppercase => 'At least one uppercase letter';
	@override String get passwordLowercase => 'At least one lowercase letter';
	@override String get passwordNumber => 'At least one number';
	@override String get passwordMinLength => 'At least 8 characters';
	@override String get passwordSpecial => 'At least one special character';
	@override String get passwordWeak => 'Password does not meet all requirements';
	@override String get usernameTaken => 'This username is already taken';
	@override String get usernameCheckPending => 'Please wait while we check the username availability';
	@override String get phone => 'Phone';
	@override String get submit => 'Create Account';
	@override String get success => 'Account created successfully';
	@override String get haveAccount => 'Already have an account?';
}

// Path: auth.login
class _Translations$auth$login$en implements Translations$auth$login$ar {
	_Translations$auth$login$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Log In';
	@override String get email => 'Email';
	@override String get password => 'Password';
	@override String get passwordHint => 'Enter your password';
	@override String get submit => 'Log In';
	@override String get forgotPassword => 'Forgot Password?';
	@override String get dontHaveAccount => 'Don\'t have an account?';
}

// Path: auth.verifyEmail
class _Translations$auth$verifyEmail$en implements Translations$auth$verifyEmail$ar {
	_Translations$auth$verifyEmail$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Verify Email';
	@override String get description => 'Enter the code sent to your email';
	@override String get otpLabel => 'Verification Code';
	@override String get verify => 'Verify';
	@override String get resend => 'Resend Code';
	@override String get noResendsLeft => 'No resends left';
	@override String get maxAttemptsReached => 'Maximum resend attempts reached.';
}

// Path: auth.verifyPhone
class _Translations$auth$verifyPhone$en implements Translations$auth$verifyPhone$ar {
	_Translations$auth$verifyPhone$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Verify Phone';
	@override String get description => 'Enter the code sent to your phone';
	@override String get skip => 'Skip for Now';
	@override String get verify => 'Verify';
}

// Path: auth.welcome
class _Translations$auth$welcome$en implements Translations$auth$welcome$ar {
	_Translations$auth$welcome$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Welcome to Moto Orbito';
	@override String get subtitle => 'Ride Together, Stay in Orbit';
	@override String get google => 'Continue with Google';
	@override String get facebook => 'Continue with Facebook';
	@override String get or => 'or';
	@override String get signUp => 'Sign Up';
	@override String get logIn => 'Log In';
}

// Path: auth.forgotPassword
class _Translations$auth$forgotPassword$en implements Translations$auth$forgotPassword$ar {
	_Translations$auth$forgotPassword$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Reset Password';
	@override String get description => 'Enter your email to receive a password reset link.';
	@override String get email => 'Email';
	@override String get send => 'Send Reset Link';
	@override String get success => 'Check your email for the reset link.';
}

// Path: auth.socialLogin
class _Translations$auth$socialLogin$en implements Translations$auth$socialLogin$ar {
	_Translations$auth$socialLogin$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get googleError => 'Google sign-in failed. Please try again.';
	@override String get facebookError => 'Facebook sign-in failed. Please try again.';
}

// Path: auth.profilePicture
class _Translations$auth$profilePicture$en implements Translations$auth$profilePicture$ar {
	_Translations$auth$profilePicture$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get pickPhoto => 'Pick Profile Photo';
	@override String get changePhoto => 'Change Photo';
	@override String get camera => 'Camera';
	@override String get gallery => 'Gallery';
	@override String get removePhoto => 'Remove Photo';
}

// Path: onboarding.slide1
class _Translations$onboarding$slide1$en implements Translations$onboarding$slide1$ar {
	_Translations$onboarding$slide1$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ride Together';
	@override String get description => 'Connect with fellow riders and explore new routes together.';
}

// Path: onboarding.slide2
class _Translations$onboarding$slide2$en implements Translations$onboarding$slide2$ar {
	_Translations$onboarding$slide2$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Stay in Orbit';
	@override String get description => 'Track your rides, monitor performance, and stay connected.';
}

// Path: onboarding.slide3
class _Translations$onboarding$slide3$en implements Translations$onboarding$slide3$ar {
	_Translations$onboarding$slide3$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ride Smarter';
	@override String get description => 'Get AI-powered insights and maintenance reminders.';
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
			'errors.cache' => 'An error occurred while accessing the cache.',
			'auth.emailAlreadyExists' => 'Email is already registered.',
			'auth.emailNotVerified' => 'Please verify your email first.',
			'auth.emailUnverifiedExists' => 'This email exists but is not verified. Redirecting to verification...',
			'auth.invalidCredentials' => 'Invalid login credentials.',
			'auth.invalidOtp' => 'Invalid verification code.',
			'auth.otpExpired' => 'Verification code has expired.',
			'auth.deleteAccount.confirmPhrase' => 'DELETE',
			'auth.deleteAccount.title' => 'Delete Account',
			'auth.deleteAccount.warning' => 'This action is irreversible. All your data will be permanently deleted.',
			'auth.deleteAccount.typeToConfirm' => 'Type DELETE to confirm:',
			'auth.deleteAccount.deleteButton' => 'Delete',
			'auth.deleteAccount.cancel' => 'Cancel',
			'auth.signUp.title' => 'Create Account',
			'auth.signUp.fullName' => 'Full Name',
			'auth.signUp.username' => 'Username',
			'auth.signUp.email' => 'Email',
			'auth.signUp.invalidEmail' => 'Please enter a valid email address',
			'auth.signUp.password' => 'Password',
			'auth.signUp.passwordHint' => 'Enter your password',
			'auth.signUp.confirmPassword' => 'Confirm Password',
			'auth.signUp.confirmPasswordHint' => 'Re-enter your password',
			'auth.signUp.passwordMismatch' => 'Passwords do not match',
			'auth.signUp.passwordUppercase' => 'At least one uppercase letter',
			'auth.signUp.passwordLowercase' => 'At least one lowercase letter',
			'auth.signUp.passwordNumber' => 'At least one number',
			'auth.signUp.passwordMinLength' => 'At least 8 characters',
			'auth.signUp.passwordSpecial' => 'At least one special character',
			'auth.signUp.passwordWeak' => 'Password does not meet all requirements',
			'auth.signUp.usernameTaken' => 'This username is already taken',
			'auth.signUp.usernameCheckPending' => 'Please wait while we check the username availability',
			'auth.signUp.phone' => 'Phone',
			'auth.signUp.submit' => 'Create Account',
			'auth.signUp.success' => 'Account created successfully',
			'auth.signUp.haveAccount' => 'Already have an account?',
			'auth.login.title' => 'Log In',
			'auth.login.email' => 'Email',
			'auth.login.password' => 'Password',
			'auth.login.passwordHint' => 'Enter your password',
			'auth.login.submit' => 'Log In',
			'auth.login.forgotPassword' => 'Forgot Password?',
			'auth.login.dontHaveAccount' => 'Don\'t have an account?',
			'auth.verifyEmail.title' => 'Verify Email',
			'auth.verifyEmail.description' => 'Enter the code sent to your email',
			'auth.verifyEmail.otpLabel' => 'Verification Code',
			'auth.verifyEmail.verify' => 'Verify',
			'auth.verifyEmail.resend' => 'Resend Code',
			'auth.verifyEmail.noResendsLeft' => 'No resends left',
			'auth.verifyEmail.maxAttemptsReached' => 'Maximum resend attempts reached.',
			'auth.verifyPhone.title' => 'Verify Phone',
			'auth.verifyPhone.description' => 'Enter the code sent to your phone',
			'auth.verifyPhone.skip' => 'Skip for Now',
			'auth.verifyPhone.verify' => 'Verify',
			'auth.welcome.title' => 'Welcome to Moto Orbito',
			'auth.welcome.subtitle' => 'Ride Together, Stay in Orbit',
			'auth.welcome.google' => 'Continue with Google',
			'auth.welcome.facebook' => 'Continue with Facebook',
			'auth.welcome.or' => 'or',
			'auth.welcome.signUp' => 'Sign Up',
			'auth.welcome.logIn' => 'Log In',
			'auth.forgotPassword.title' => 'Reset Password',
			'auth.forgotPassword.description' => 'Enter your email to receive a password reset link.',
			'auth.forgotPassword.email' => 'Email',
			'auth.forgotPassword.send' => 'Send Reset Link',
			'auth.forgotPassword.success' => 'Check your email for the reset link.',
			'auth.socialLogin.googleError' => 'Google sign-in failed. Please try again.',
			'auth.socialLogin.facebookError' => 'Facebook sign-in failed. Please try again.',
			'auth.profilePicture.pickPhoto' => 'Pick Profile Photo',
			'auth.profilePicture.changePhoto' => 'Change Photo',
			'auth.profilePicture.camera' => 'Camera',
			'auth.profilePicture.gallery' => 'Gallery',
			'auth.profilePicture.removePhoto' => 'Remove Photo',
			'onboarding.slide1.title' => 'Ride Together',
			'onboarding.slide1.description' => 'Connect with fellow riders and explore new routes together.',
			'onboarding.slide2.title' => 'Stay in Orbit',
			'onboarding.slide2.description' => 'Track your rides, monitor performance, and stay connected.',
			'onboarding.slide3.title' => 'Ride Smarter',
			'onboarding.slide3.description' => 'Get AI-powered insights and maintenance reminders.',
			'onboarding.skip' => 'Skip',
			'onboarding.next' => 'Next',
			'onboarding.getStarted' => 'Get Started',
			_ => null,
		};
	}
}
