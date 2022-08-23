import 'types.dart';

/// Base class for all Link configurations alternatives.
abstract class LinkConfiguration {
  Map<String, dynamic> toJson();
}

/// The LinkConfiguration only needs a link_token which is a new type of token that is created by your app's
/// server and passed to your app's client to initialize Link. The Link configuration parameters that were
/// previously set within Link itself are now set via parameters passed to /link/token/create and conveyed
/// to Link via the link_token. (https://plaid.com/docs/link/link-token-migration-guide)
class LinkTokenConfiguration implements LinkConfiguration {
  final String token;

  final bool noLoadingState;

  final String? receivedRedirectUri;

  LinkTokenConfiguration(
      {required this.token,
      this.noLoadingState = false,
      this.receivedRedirectUri = null});

  /// Returns a representation of this object as a JSON object.
  Map<String, dynamic> toJson() {
    if (receivedRedirectUri != null && receivedRedirectUri!.length > 0) {
      return <String, dynamic>{
        'token': token,
        'noLoadingState': noLoadingState,
        'receivedRedirectUri': receivedRedirectUri,
      };
    }

    return <String, dynamic>{
      'token': token,
      'noLoadingState': noLoadingState,
    };
  }
}

/// The LegacyLinkConfiguration class defines properties to support the
/// old Plaid flow that required a static [publicKey]
class LegacyLinkConfiguration implements LinkConfiguration {
  /// Create a LinkLegacyConfiguration.
  LegacyLinkConfiguration({
    required this.publicKey,
    this.token,
    this.clientName,
    this.environment,
    this.products,
    this.webhook,
    this.linkCustomizationName,
    this.language,
    this.countryCodes,
    this.userLegalName,
    this.userEmailAddress,
    this.userPhoneNumber,
    this.accountSubtypes,
    this.oauthConfiguration,
  });

  /// Your Plaid public_key available from the Plaid dashboard (https://dashboard.plaid.com/team/keys).
  ///
  /// The [publicKey] is deprecated. To upgrade to the new link_token flow check the following link: https://plaid.com/docs/upgrade-to-link-tokens/
  final String publicKey;

  /// Token can take 3 different formats:
  /// * [public_token] to launch Link in update mode for a particular Item.
  /// * [payment_token] to Link initialization to enter the payment initiation flow
  /// * [deposit_switch_token] to enable the deposit switch feature.
  final String? token;

  /// Displayed to the user once they have successfully linked their account
  final String? clientName;

  /// The API environment to use. Selects the Plaid servers with which LinkKit communicates.
  final LinkEnvironment? environment;

  /// The webhook will receive notifications once a userʼs transactions have been processed and are ready for use.
  final String? webhook;

  /// The list of Plaid products you would like to use.
  final List<LinkProduct>? products;

  /// By default, Link will only display account types that are compatible with all products
  /// supplied in the product parameter. You can further limit the accounts shown in Link by
  /// using accountSubtypes to specify the account subtypes to be shown in Link.
  /// Only the specified subtypes will be shown.
  final List<LinkAccountSubtype>? accountSubtypes;

  /// Allows non default customization to be retrieved by name.
  final String? linkCustomizationName;

  /// Plaid-supported language to localize Link. English will be used by default.
  final String? language;

  /// A list of Plaid-supported country codes using the ISO-3166-1 alpha-2 country code standard.
  final List<String>? countryCodes;

  /// The legal name of the end-user, necessary for microdeposit support.
  final String? userLegalName;

  /// The email address of the end-user, necessary for microdeposit support.
  final String? userEmailAddress;

  /// The phone number of the end-user, used for returning user experience.
  final String? userPhoneNumber;

  /// Values used to configure the application for OAuth
  final LinkOAuthConfiguration? oauthConfiguration;

  /// Returns a representation of this object as a JSON object.
  Map<String, dynamic> toJson() {
    List<String> productsArray =
        products?.map((p) => p.toString().split('.').last).toList() ?? [];
    List<Map<String, String>> accountSubtypesArray =
        accountSubtypes?.map((a) => a.toJson()).toList() ?? [];

    return <String, dynamic>{
      'token': token,
      'publicKey': publicKey,
      'clientName': clientName,
      'webhook': webhook,
      'environment': environment.toString().split('.').last,
      'linkCustomizationName': linkCustomizationName,
      'language': language,
      'userLegalName': userLegalName,
      'userEmailAddress': userEmailAddress,
      'userPhoneNumber': userPhoneNumber,
      'countryCodes': countryCodes,
      'oauthRedirectUri': oauthConfiguration?.redirectUri,
      'oauthNonce': oauthConfiguration?.nonce,
      'products': productsArray,
      'accountSubtypes': accountSubtypesArray,
    };
  }
}
