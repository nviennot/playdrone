##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'

module GooglePlay
  
  ##
  # Message Classes
  #
  class AckNotificationResponse < ::Protobuf::Message; end
  class AndroidAppDeliveryData < ::Protobuf::Message; end
  class AndroidAppPatchData < ::Protobuf::Message; end
  class AppFileMetadata < ::Protobuf::Message; end
  class EncryptionParams < ::Protobuf::Message; end
  class HttpCookie < ::Protobuf::Message; end
  class Address < ::Protobuf::Message; end
  class BookAuthor < ::Protobuf::Message; end
  class BookDetails < ::Protobuf::Message
    class Identifier < ::Protobuf::Message; end
  end
  class BookSubject < ::Protobuf::Message; end
  class BrowseLink < ::Protobuf::Message; end
  class BrowseResponse < ::Protobuf::Message; end
  class AddressChallenge < ::Protobuf::Message; end
  class AuthenticationChallenge < ::Protobuf::Message; end
  class BuyResponse < ::Protobuf::Message
    class CheckoutInfo < ::Protobuf::Message
      class CheckoutOption < ::Protobuf::Message; end
    end
  end
  class Challenge < ::Protobuf::Message; end
  class FormCheckbox < ::Protobuf::Message; end
  class LineItem < ::Protobuf::Message; end
  class Money < ::Protobuf::Message; end
  class PurchaseNotificationResponse < ::Protobuf::Message; end
  class PurchaseStatusResponse < ::Protobuf::Message; end
  class CheckInstrumentResponse < ::Protobuf::Message; end
  class UpdateInstrumentRequest < ::Protobuf::Message; end
  class UpdateInstrumentResponse < ::Protobuf::Message; end
  class InitiateAssociationResponse < ::Protobuf::Message; end
  class VerifyAssociationResponse < ::Protobuf::Message; end
  class AddCreditCardPromoOffer < ::Protobuf::Message; end
  class AvailablePromoOffer < ::Protobuf::Message; end
  class CheckPromoOfferResponse < ::Protobuf::Message; end
  class RedeemedPromoOffer < ::Protobuf::Message; end
  class Docid < ::Protobuf::Message; end
  class Install < ::Protobuf::Message; end
  class Offer < ::Protobuf::Message; end
  class OwnershipInfo < ::Protobuf::Message; end
  class RentalTerms < ::Protobuf::Message; end
  class SubscriptionTerms < ::Protobuf::Message; end
  class TimePeriod < ::Protobuf::Message; end
  class BillingAddressSpec < ::Protobuf::Message; end
  class CarrierBillingCredentials < ::Protobuf::Message; end
  class CarrierBillingInstrument < ::Protobuf::Message; end
  class CarrierBillingInstrumentStatus < ::Protobuf::Message; end
  class CarrierTos < ::Protobuf::Message; end
  class CarrierTosEntry < ::Protobuf::Message; end
  class CreditCardInstrument < ::Protobuf::Message; end
  class EfeParam < ::Protobuf::Message; end
  class InputValidationError < ::Protobuf::Message; end
  class Instrument < ::Protobuf::Message; end
  class PasswordPrompt < ::Protobuf::Message; end
  class ContainerMetadata < ::Protobuf::Message; end
  class FlagContentResponse < ::Protobuf::Message; end
  class DebugInfo < ::Protobuf::Message
    class Timing < ::Protobuf::Message; end
  end
  class DeliveryResponse < ::Protobuf::Message; end
  class BulkDetailsEntry < ::Protobuf::Message; end
  class BulkDetailsRequest < ::Protobuf::Message; end
  class BulkDetailsResponse < ::Protobuf::Message; end
  class DetailsResponse < ::Protobuf::Message; end
  class DeviceConfigurationProto < ::Protobuf::Message; end
  class Document < ::Protobuf::Message; end
  class DocumentVariant < ::Protobuf::Message; end
  class Image < ::Protobuf::Message
    class Dimension < ::Protobuf::Message; end
    class Citation < ::Protobuf::Message; end
  end
  class TranslatedText < ::Protobuf::Message; end
  class Badge < ::Protobuf::Message; end
  class ContainerWithBanner < ::Protobuf::Message; end
  class DealOfTheDay < ::Protobuf::Message; end
  class EditorialSeriesContainer < ::Protobuf::Message; end
  class Link < ::Protobuf::Message; end
  class PlusOneData < ::Protobuf::Message; end
  class PlusPerson < ::Protobuf::Message; end
  class PromotedDoc < ::Protobuf::Message; end
  class Reason < ::Protobuf::Message; end
  class SectionMetadata < ::Protobuf::Message; end
  class SeriesAntenna < ::Protobuf::Message; end
  class Template < ::Protobuf::Message; end
  class TileTemplate < ::Protobuf::Message; end
  class Warning < ::Protobuf::Message; end
  class AlbumDetails < ::Protobuf::Message; end
  class AppDetails < ::Protobuf::Message; end
  class ArtistDetails < ::Protobuf::Message; end
  class ArtistExternalLinks < ::Protobuf::Message; end
  class DocumentDetails < ::Protobuf::Message; end
  class FileMetadata < ::Protobuf::Message; end
  class MagazineDetails < ::Protobuf::Message; end
  class MusicDetails < ::Protobuf::Message; end
  class SongDetails < ::Protobuf::Message; end
  class SubscriptionDetails < ::Protobuf::Message; end
  class Trailer < ::Protobuf::Message; end
  class TvEpisodeDetails < ::Protobuf::Message; end
  class TvSeasonDetails < ::Protobuf::Message; end
  class TvShowDetails < ::Protobuf::Message; end
  class VideoCredit < ::Protobuf::Message; end
  class VideoDetails < ::Protobuf::Message; end
  class VideoRentalTerm < ::Protobuf::Message
    class Term < ::Protobuf::Message; end
  end
  class Bucket < ::Protobuf::Message; end
  class ListResponse < ::Protobuf::Message; end
  class DocV1 < ::Protobuf::Message; end
  class Annotations < ::Protobuf::Message; end
  class DocV2 < ::Protobuf::Message; end
  class EncryptedSubscriberInfo < ::Protobuf::Message; end
  class Availability < ::Protobuf::Message
    class PerDeviceAvailabilityRestriction < ::Protobuf::Message; end
  end
  class FilterEvaluationInfo < ::Protobuf::Message; end
  class Rule < ::Protobuf::Message; end
  class RuleEvaluation < ::Protobuf::Message; end
  class LibraryAppDetails < ::Protobuf::Message; end
  class LibraryMutation < ::Protobuf::Message; end
  class LibrarySubscriptionDetails < ::Protobuf::Message; end
  class LibraryUpdate < ::Protobuf::Message; end
  class ClientLibraryState < ::Protobuf::Message; end
  class LibraryReplicationRequest < ::Protobuf::Message; end
  class LibraryReplicationResponse < ::Protobuf::Message; end
  class ClickLogEvent < ::Protobuf::Message; end
  class LogRequest < ::Protobuf::Message; end
  class LogResponse < ::Protobuf::Message; end
  class AndroidAppNotificationData < ::Protobuf::Message; end
  class InAppNotificationData < ::Protobuf::Message; end
  class LibraryDirtyData < ::Protobuf::Message; end
  class Notification < ::Protobuf::Message; end
  class PurchaseDeclinedData < ::Protobuf::Message; end
  class PurchaseRemovalData < ::Protobuf::Message; end
  class UserNotificationData < ::Protobuf::Message; end
  class PlusOneResponse < ::Protobuf::Message; end
  class RateSuggestedContentResponse < ::Protobuf::Message; end
  class AggregateRating < ::Protobuf::Message; end
  class DirectPurchase < ::Protobuf::Message; end
  class ResolveLinkResponse < ::Protobuf::Message; end
  class Payload < ::Protobuf::Message; end
  class PreFetch < ::Protobuf::Message; end
  class ResponseWrapper < ::Protobuf::Message; end
  class ServerCommands < ::Protobuf::Message; end
  class GetReviewsResponse < ::Protobuf::Message; end
  class Review < ::Protobuf::Message; end
  class ReviewResponse < ::Protobuf::Message; end
  class RevokeResponse < ::Protobuf::Message; end
  class RelatedSearch < ::Protobuf::Message; end
  class SearchResponse < ::Protobuf::Message; end
  class CorpusMetadata < ::Protobuf::Message; end
  class Experiments < ::Protobuf::Message; end
  class TocResponse < ::Protobuf::Message; end
  class UserSettings < ::Protobuf::Message; end
  class AcceptTosResponse < ::Protobuf::Message; end
  class AckNotificationsRequestProto < ::Protobuf::Message; end
  class AckNotificationsResponseProto < ::Protobuf::Message; end
  class AddressProto < ::Protobuf::Message; end
  class AppDataProto < ::Protobuf::Message; end
  class AppSuggestionProto < ::Protobuf::Message; end
  class AssetIdentifierProto < ::Protobuf::Message; end
  class AssetsRequestProto < ::Protobuf::Message; end
  class AssetsResponseProto < ::Protobuf::Message; end
  class BillingEventRequestProto < ::Protobuf::Message; end
  class BillingEventResponseProto < ::Protobuf::Message; end
  class BillingParameterProto < ::Protobuf::Message; end
  class CarrierBillingCredentialsProto < ::Protobuf::Message; end
  class CategoryProto < ::Protobuf::Message; end
  class CheckForNotificationsRequestProto < ::Protobuf::Message; end
  class CheckForNotificationsResponseProto < ::Protobuf::Message; end
  class CheckLicenseRequestProto < ::Protobuf::Message; end
  class CheckLicenseResponseProto < ::Protobuf::Message; end
  class CommentsRequestProto < ::Protobuf::Message; end
  class CommentsResponseProto < ::Protobuf::Message; end
  class ContentSyncRequestProto < ::Protobuf::Message
    class AssetInstallState < ::Protobuf::Message; end
    class SystemApp < ::Protobuf::Message; end
  end
  class ContentSyncResponseProto < ::Protobuf::Message; end
  class DataMessageProto < ::Protobuf::Message; end
  class DownloadInfoProto < ::Protobuf::Message; end
  class ExternalAssetProto < ::Protobuf::Message
    class PurchaseInformation < ::Protobuf::Message; end
    class ExtendedInfo < ::Protobuf::Message
      class PackageDependency < ::Protobuf::Message; end
    end
  end
  class ExternalBadgeImageProto < ::Protobuf::Message; end
  class ExternalBadgeProto < ::Protobuf::Message; end
  class ExternalCarrierBillingInstrumentProto < ::Protobuf::Message; end
  class ExternalCommentProto < ::Protobuf::Message; end
  class ExternalCreditCard < ::Protobuf::Message; end
  class ExternalPaypalInstrumentProto < ::Protobuf::Message; end
  class FileMetadataProto < ::Protobuf::Message; end
  class GetAddressSnippetRequestProto < ::Protobuf::Message; end
  class GetAddressSnippetResponseProto < ::Protobuf::Message; end
  class GetAssetRequestProto < ::Protobuf::Message; end
  class GetAssetResponseProto < ::Protobuf::Message
    class InstallAsset < ::Protobuf::Message; end
  end
  class GetCarrierInfoRequestProto < ::Protobuf::Message; end
  class GetCarrierInfoResponseProto < ::Protobuf::Message; end
  class GetCategoriesRequestProto < ::Protobuf::Message; end
  class GetCategoriesResponseProto < ::Protobuf::Message; end
  class GetImageRequestProto < ::Protobuf::Message; end
  class GetImageResponseProto < ::Protobuf::Message; end
  class GetMarketMetadataRequestProto < ::Protobuf::Message; end
  class GetMarketMetadataResponseProto < ::Protobuf::Message; end
  class GetSubCategoriesRequestProto < ::Protobuf::Message; end
  class GetSubCategoriesResponseProto < ::Protobuf::Message
    class SubCategory < ::Protobuf::Message; end
  end
  class InAppPurchaseInformationRequestProto < ::Protobuf::Message; end
  class InAppPurchaseInformationResponseProto < ::Protobuf::Message; end
  class InAppRestoreTransactionsRequestProto < ::Protobuf::Message; end
  class InAppRestoreTransactionsResponseProto < ::Protobuf::Message; end
  class ModifyCommentRequestProto < ::Protobuf::Message; end
  class ModifyCommentResponseProto < ::Protobuf::Message; end
  class PaypalCountryInfoProto < ::Protobuf::Message; end
  class PaypalCreateAccountRequestProto < ::Protobuf::Message; end
  class PaypalCreateAccountResponseProto < ::Protobuf::Message; end
  class PaypalCredentialsProto < ::Protobuf::Message; end
  class PaypalMassageAddressRequestProto < ::Protobuf::Message; end
  class PaypalMassageAddressResponseProto < ::Protobuf::Message; end
  class PaypalPreapprovalCredentialsRequestProto < ::Protobuf::Message; end
  class PaypalPreapprovalCredentialsResponseProto < ::Protobuf::Message; end
  class PaypalPreapprovalDetailsRequestProto < ::Protobuf::Message; end
  class PaypalPreapprovalDetailsResponseProto < ::Protobuf::Message; end
  class PaypalPreapprovalRequestProto < ::Protobuf::Message; end
  class PaypalPreapprovalResponseProto < ::Protobuf::Message; end
  class PendingNotificationsProto < ::Protobuf::Message; end
  class PrefetchedBundleProto < ::Protobuf::Message; end
  class PurchaseCartInfoProto < ::Protobuf::Message; end
  class PurchaseInfoProto < ::Protobuf::Message
    class BillingInstruments < ::Protobuf::Message
      class BillingInstrument < ::Protobuf::Message; end
    end
  end
  class PurchaseMetadataRequestProto < ::Protobuf::Message; end
  class PurchaseMetadataResponseProto < ::Protobuf::Message
    class Countries < ::Protobuf::Message
      class Country < ::Protobuf::Message
        class InstrumentAddressSpec < ::Protobuf::Message; end
      end
    end
  end
  class PurchaseOrderRequestProto < ::Protobuf::Message; end
  class PurchaseOrderResponseProto < ::Protobuf::Message; end
  class PurchasePostRequestProto < ::Protobuf::Message
    class BillingInstrumentInfo < ::Protobuf::Message; end
  end
  class PurchasePostResponseProto < ::Protobuf::Message; end
  class PurchaseProductRequestProto < ::Protobuf::Message; end
  class PurchaseProductResponseProto < ::Protobuf::Message; end
  class PurchaseResultProto < ::Protobuf::Message; end
  class QuerySuggestionProto < ::Protobuf::Message; end
  class QuerySuggestionRequestProto < ::Protobuf::Message; end
  class QuerySuggestionResponseProto < ::Protobuf::Message
    class Suggestion < ::Protobuf::Message; end
  end
  class RateCommentRequestProto < ::Protobuf::Message; end
  class RateCommentResponseProto < ::Protobuf::Message; end
  class ReconstructDatabaseRequestProto < ::Protobuf::Message; end
  class ReconstructDatabaseResponseProto < ::Protobuf::Message; end
  class RefundRequestProto < ::Protobuf::Message; end
  class RefundResponseProto < ::Protobuf::Message; end
  class RemoveAssetRequestProto < ::Protobuf::Message; end
  class RequestPropertiesProto < ::Protobuf::Message; end
  class RequestProto < ::Protobuf::Message
    class Request < ::Protobuf::Message; end
  end
  class RequestSpecificPropertiesProto < ::Protobuf::Message; end
  class ResponsePropertiesProto < ::Protobuf::Message; end
  class ResponseProto < ::Protobuf::Message
    class Response < ::Protobuf::Message; end
  end
  class RestoreApplicationsRequestProto < ::Protobuf::Message; end
  class RestoreApplicationsResponseProto < ::Protobuf::Message; end
  class RiskHeaderInfoProto < ::Protobuf::Message; end
  class SignatureHashProto < ::Protobuf::Message; end
  class SignedDataProto < ::Protobuf::Message; end
  class SingleRequestProto < ::Protobuf::Message; end
  class SingleResponseProto < ::Protobuf::Message; end
  class StatusBarNotificationProto < ::Protobuf::Message; end
  class UninstallReasonRequestProto < ::Protobuf::Message; end
  class UninstallReasonResponseProto < ::Protobuf::Message; end
  
  ##
  # Message Fields
  #
  class AndroidAppDeliveryData
    optional ::Protobuf::Field::Int64Field, :download_size, 1
    optional ::Protobuf::Field::StringField, :signature, 2
    optional ::Protobuf::Field::StringField, :download_url, 3
    repeated ::GooglePlay::AppFileMetadata, :additional_file, 4
    repeated ::GooglePlay::HttpCookie, :download_auth_cookie, 5
    optional ::Protobuf::Field::BoolField, :forward_locked, 6
    optional ::Protobuf::Field::Int64Field, :refund_timeout, 7
    optional ::Protobuf::Field::BoolField, :server_initiated, 8
    optional ::Protobuf::Field::Int64Field, :post_install_refund_window_millis, 9
    optional ::Protobuf::Field::BoolField, :immediate_start_needed, 10
    optional ::GooglePlay::AndroidAppPatchData, :patch_data, 11
    optional ::GooglePlay::EncryptionParams, :encryption_params, 12
  end
  
  class AndroidAppPatchData
    optional ::Protobuf::Field::Int32Field, :base_version_code, 1
    optional ::Protobuf::Field::StringField, :base_signature, 2
    optional ::Protobuf::Field::StringField, :download_url, 3
    optional ::Protobuf::Field::Int32Field, :patch_format, 4
    optional ::Protobuf::Field::Int64Field, :max_patch_size, 5
  end
  
  class AppFileMetadata
    optional ::Protobuf::Field::Int32Field, :file_type, 1
    optional ::Protobuf::Field::Int32Field, :version_code, 2
    optional ::Protobuf::Field::Int64Field, :size, 3
    optional ::Protobuf::Field::StringField, :download_url, 4
  end
  
  class EncryptionParams
    optional ::Protobuf::Field::Int32Field, :version, 1
    optional ::Protobuf::Field::StringField, :encryption_key, 2
    optional ::Protobuf::Field::StringField, :hmac_key, 3
  end
  
  class HttpCookie
    optional ::Protobuf::Field::StringField, :name, 1
    optional ::Protobuf::Field::StringField, :value, 2
  end
  
  class Address
    optional ::Protobuf::Field::StringField, :name, 1
    optional ::Protobuf::Field::StringField, :address_line_1, 2
    optional ::Protobuf::Field::StringField, :address_line_2, 3
    optional ::Protobuf::Field::StringField, :city, 4
    optional ::Protobuf::Field::StringField, :state, 5
    optional ::Protobuf::Field::StringField, :postal_code, 6
    optional ::Protobuf::Field::StringField, :postal_country, 7
    optional ::Protobuf::Field::StringField, :dependent_locality, 8
    optional ::Protobuf::Field::StringField, :sorting_code, 9
    optional ::Protobuf::Field::StringField, :language_code, 10
    optional ::Protobuf::Field::StringField, :phone_number, 11
    optional ::Protobuf::Field::BoolField, :is_reduced, 12
    optional ::Protobuf::Field::StringField, :first_name, 13
    optional ::Protobuf::Field::StringField, :last_name, 14
    optional ::Protobuf::Field::StringField, :email, 15
  end
  
  class BookAuthor
    optional ::Protobuf::Field::StringField, :name, 1
    optional ::Protobuf::Field::StringField, :deprecated_query, 2
    optional ::GooglePlay::Docid, :docid, 3
  end
  
  class BookDetails
    class Identifier
      optional ::Protobuf::Field::Int32Field, :type, 19
      optional ::Protobuf::Field::StringField, :identifier, 20
    end
    
    repeated ::GooglePlay::BookSubject, :subject, 3
    optional ::Protobuf::Field::StringField, :publisher, 4
    optional ::Protobuf::Field::StringField, :publication_date, 5
    optional ::Protobuf::Field::StringField, :isbn, 6
    optional ::Protobuf::Field::Int32Field, :number_of_pages, 7
    optional ::Protobuf::Field::StringField, :subtitle, 8
    repeated ::GooglePlay::BookAuthor, :author, 9
    optional ::Protobuf::Field::StringField, :reader_url, 10
    optional ::Protobuf::Field::StringField, :download_epub_url, 11
    optional ::Protobuf::Field::StringField, :download_pdf_url, 12
    optional ::Protobuf::Field::StringField, :acs_epub_token_url, 13
    optional ::Protobuf::Field::StringField, :acs_pdf_token_url, 14
    optional ::Protobuf::Field::BoolField, :epub_available, 15
    optional ::Protobuf::Field::BoolField, :pdf_available, 16
    optional ::Protobuf::Field::StringField, :about_the_author, 17
    repeated ::GooglePlay::BookDetails::Identifier, :identifier, 18
  end
  
  class BookSubject
    optional ::Protobuf::Field::StringField, :name, 1
    optional ::Protobuf::Field::StringField, :query, 2
    optional ::Protobuf::Field::StringField, :subject_id, 3
  end
  
  class BrowseLink
    optional ::Protobuf::Field::StringField, :name, 1
    optional ::Protobuf::Field::StringField, :data_url, 3
  end
  
  class BrowseResponse
    optional ::Protobuf::Field::StringField, :contents_url, 1
    optional ::Protobuf::Field::StringField, :promo_url, 2
    repeated ::GooglePlay::BrowseLink, :category, 3
    repeated ::GooglePlay::BrowseLink, :breadcrumb, 4
  end
  
  class AddressChallenge
    optional ::Protobuf::Field::StringField, :response_address_param, 1
    optional ::Protobuf::Field::StringField, :response_checkboxes_param, 2
    optional ::Protobuf::Field::StringField, :title, 3
    optional ::Protobuf::Field::StringField, :description_html, 4
    repeated ::GooglePlay::FormCheckbox, :checkbox, 5
    optional ::GooglePlay::Address, :address, 6
    repeated ::GooglePlay::InputValidationError, :error_input_field, 7
    optional ::Protobuf::Field::StringField, :error_html, 8
    repeated ::Protobuf::Field::Int32Field, :required_field, 9
  end
  
  class AuthenticationChallenge
    optional ::Protobuf::Field::Int32Field, :authentication_type, 1
    optional ::Protobuf::Field::StringField, :response_authentication_type_param, 2
    optional ::Protobuf::Field::StringField, :response_retry_count_param, 3
    optional ::Protobuf::Field::StringField, :pin_header_text, 4
    optional ::Protobuf::Field::StringField, :pin_description_text_html, 5
    optional ::Protobuf::Field::StringField, :gaia_header_text, 6
    optional ::Protobuf::Field::StringField, :gaia_description_text_html, 7
  end
  
  class BuyResponse
    class CheckoutInfo
      class CheckoutOption
        optional ::Protobuf::Field::StringField, :form_of_payment, 6
        optional ::Protobuf::Field::StringField, :encoded_adjusted_cart, 7
        optional ::Protobuf::Field::StringField, :instrument_id, 15
        repeated ::GooglePlay::LineItem, :item, 16
        repeated ::GooglePlay::LineItem, :sub_item, 17
        optional ::GooglePlay::LineItem, :total, 18
        repeated ::Protobuf::Field::StringField, :footer_html, 19
        optional ::Protobuf::Field::Int32Field, :instrument_family, 29
        repeated ::Protobuf::Field::Int32Field, :deprecated_instrument_inapplicable_reason, 30
        optional ::Protobuf::Field::BoolField, :selected_instrument, 32
        optional ::GooglePlay::LineItem, :summary, 33
        repeated ::Protobuf::Field::StringField, :footnote_html, 35
        optional ::GooglePlay::Instrument, :instrument, 43
        optional ::Protobuf::Field::StringField, :purchase_cookie, 45
        repeated ::Protobuf::Field::StringField, :disabled_reason, 48
      end
      
      optional ::GooglePlay::LineItem, :item, 3
      repeated ::GooglePlay::LineItem, :sub_item, 4
      repeated ::GooglePlay::BuyResponse::CheckoutInfo::CheckoutOption, :checkoutoption, 5
      optional ::Protobuf::Field::StringField, :deprecated_checkout_url, 10
      optional ::Protobuf::Field::StringField, :add_instrument_url, 11
      repeated ::Protobuf::Field::StringField, :footer_html, 20
      repeated ::Protobuf::Field::Int32Field, :eligible_instrument_family, 31
      repeated ::Protobuf::Field::StringField, :footnote_html, 36
      repeated ::GooglePlay::Instrument, :eligible_instrument, 44
    end
    
    optional ::GooglePlay::PurchaseNotificationResponse, :purchase_response, 1
    optional ::GooglePlay::BuyResponse::CheckoutInfo, :checkoutinfo, 2
    optional ::Protobuf::Field::StringField, :continue_via_url, 8
    optional ::Protobuf::Field::StringField, :purchase_status_url, 9
    optional ::Protobuf::Field::StringField, :checkout_service_id, 12
    optional ::Protobuf::Field::BoolField, :checkout_token_required, 13
    optional ::Protobuf::Field::StringField, :base_checkout_url, 14
    repeated ::Protobuf::Field::StringField, :tos_checkbox_html, 37
    optional ::Protobuf::Field::Int32Field, :iab_permission_error, 38
    optional ::GooglePlay::PurchaseStatusResponse, :purchase_status_response, 39
    optional ::Protobuf::Field::StringField, :purchase_cookie, 46
    optional ::GooglePlay::Challenge, :challenge, 49
  end
  
  class Challenge
    optional ::GooglePlay::AddressChallenge, :address_challenge, 1
    optional ::GooglePlay::AuthenticationChallenge, :authentication_challenge, 2
  end
  
  class FormCheckbox
    optional ::Protobuf::Field::StringField, :description, 1
    optional ::Protobuf::Field::BoolField, :checked, 2
    optional ::Protobuf::Field::BoolField, :required, 3
  end
  
  class LineItem
    optional ::Protobuf::Field::StringField, :name, 1
    optional ::Protobuf::Field::StringField, :description, 2
    optional ::GooglePlay::Offer, :offer, 3
    optional ::GooglePlay::Money, :amount, 4
  end
  
  class Money
    optional ::Protobuf::Field::Int64Field, :micros, 1
    optional ::Protobuf::Field::StringField, :currency_code, 2
    optional ::Protobuf::Field::StringField, :formatted_amount, 3
  end
  
  class PurchaseNotificationResponse
    optional ::Protobuf::Field::Int32Field, :status, 1
    optional ::GooglePlay::DebugInfo, :debug_info, 2
    optional ::Protobuf::Field::StringField, :localized_error_message, 3
    optional ::Protobuf::Field::StringField, :purchase_id, 4
  end
  
  class PurchaseStatusResponse
    optional ::Protobuf::Field::Int32Field, :status, 1
    optional ::Protobuf::Field::StringField, :status_msg, 2
    optional ::Protobuf::Field::StringField, :status_title, 3
    optional ::Protobuf::Field::StringField, :brief_message, 4
    optional ::Protobuf::Field::StringField, :info_url, 5
    optional ::GooglePlay::LibraryUpdate, :library_update, 6
    optional ::GooglePlay::Instrument, :rejected_instrument, 7
    optional ::GooglePlay::AndroidAppDeliveryData, :app_delivery_data, 8
  end
  
  class CheckInstrumentResponse
    optional ::Protobuf::Field::BoolField, :user_has_valid_instrument, 1
    optional ::Protobuf::Field::BoolField, :checkout_token_required, 2
    repeated ::GooglePlay::Instrument, :instrument, 4
    repeated ::GooglePlay::Instrument, :eligible_instrument, 5
  end
  
  class UpdateInstrumentRequest
    optional ::GooglePlay::Instrument, :instrument, 1
    optional ::Protobuf::Field::StringField, :checkout_token, 2
  end
  
  class UpdateInstrumentResponse
    optional ::Protobuf::Field::Int32Field, :result, 1
    optional ::Protobuf::Field::StringField, :instrument_id, 2
    optional ::Protobuf::Field::StringField, :user_message_html, 3
    repeated ::GooglePlay::InputValidationError, :error_input_field, 4
    optional ::Protobuf::Field::BoolField, :checkout_token_required, 5
    optional ::GooglePlay::RedeemedPromoOffer, :redeemed_offer, 6
  end
  
  class InitiateAssociationResponse
    optional ::Protobuf::Field::StringField, :user_token, 1
  end
  
  class VerifyAssociationResponse
    optional ::Protobuf::Field::Int32Field, :status, 1
    optional ::GooglePlay::Address, :billing_address, 2
    optional ::GooglePlay::CarrierTos, :carrier_tos, 3
  end
  
  class AddCreditCardPromoOffer
    optional ::Protobuf::Field::StringField, :header_text, 1
    optional ::Protobuf::Field::StringField, :description_html, 2
    optional ::GooglePlay::Image, :image, 3
    optional ::Protobuf::Field::StringField, :introductory_text_html, 4
    optional ::Protobuf::Field::StringField, :offer_title, 5
    optional ::Protobuf::Field::StringField, :no_action_description, 6
    optional ::Protobuf::Field::StringField, :terms_and_conditions_html, 7
  end
  
  class AvailablePromoOffer
    optional ::GooglePlay::AddCreditCardPromoOffer, :add_credit_card_offer, 1
  end
  
  class CheckPromoOfferResponse
    repeated ::GooglePlay::AvailablePromoOffer, :available_offer, 1
    optional ::GooglePlay::RedeemedPromoOffer, :redeemed_offer, 2
    optional ::Protobuf::Field::BoolField, :checkout_token_required, 3
  end
  
  class RedeemedPromoOffer
    optional ::Protobuf::Field::StringField, :header_text, 1
    optional ::Protobuf::Field::StringField, :description_html, 2
    optional ::GooglePlay::Image, :image, 3
  end
  
  class Docid
    optional ::Protobuf::Field::StringField, :backend_docid, 1
    optional ::Protobuf::Field::Int32Field, :type, 2
    optional ::Protobuf::Field::Int32Field, :backend, 3
  end
  
  class Install
    optional ::Protobuf::Field::Fixed64Field, :android_id, 1
    optional ::Protobuf::Field::Int32Field, :version, 2
    optional ::Protobuf::Field::BoolField, :bundled, 3
  end
  
  class Offer
    optional ::Protobuf::Field::Int64Field, :micros, 1
    optional ::Protobuf::Field::StringField, :currency_code, 2
    optional ::Protobuf::Field::StringField, :formatted_amount, 3
    repeated ::GooglePlay::Offer, :converted_price, 4
    optional ::Protobuf::Field::BoolField, :checkout_flow_required, 5
    optional ::Protobuf::Field::Int64Field, :full_price_micros, 6
    optional ::Protobuf::Field::StringField, :formatted_full_amount, 7
    optional ::Protobuf::Field::Int32Field, :offer_type, 8
    optional ::GooglePlay::RentalTerms, :rental_terms, 9
    optional ::Protobuf::Field::Int64Field, :on_sale_date, 10
    repeated ::Protobuf::Field::StringField, :promotion_label, 11
    optional ::GooglePlay::SubscriptionTerms, :subscription_terms, 12
    optional ::Protobuf::Field::StringField, :formatted_name, 13
    optional ::Protobuf::Field::StringField, :formatted_description, 14
  end
  
  class OwnershipInfo
    optional ::Protobuf::Field::Int64Field, :initiation_timestamp_msec, 1
    optional ::Protobuf::Field::Int64Field, :valid_until_timestamp_msec, 2
    optional ::Protobuf::Field::BoolField, :auto_renewing, 3
    optional ::Protobuf::Field::Int64Field, :refund_timeout_timestamp_msec, 4
    optional ::Protobuf::Field::Int64Field, :post_delivery_refund_window_msec, 5
  end
  
  class RentalTerms
    optional ::Protobuf::Field::Int32Field, :grant_period_seconds, 1
    optional ::Protobuf::Field::Int32Field, :activate_period_seconds, 2
  end
  
  class SubscriptionTerms
    optional ::GooglePlay::TimePeriod, :recurring_period, 1
    optional ::GooglePlay::TimePeriod, :trial_period, 2
  end
  
  class TimePeriod
    optional ::Protobuf::Field::Int32Field, :unit, 1
    optional ::Protobuf::Field::Int32Field, :count, 2
  end
  
  class BillingAddressSpec
    optional ::Protobuf::Field::Int32Field, :billing_address_type, 1
    repeated ::Protobuf::Field::Int32Field, :required_field, 2
  end
  
  class CarrierBillingCredentials
    optional ::Protobuf::Field::StringField, :value, 1
    optional ::Protobuf::Field::Int64Field, :expiration, 2
  end
  
  class CarrierBillingInstrument
    optional ::Protobuf::Field::StringField, :instrument_key, 1
    optional ::Protobuf::Field::StringField, :account_type, 2
    optional ::Protobuf::Field::StringField, :currency_code, 3
    optional ::Protobuf::Field::Int64Field, :transaction_limit, 4
    optional ::Protobuf::Field::StringField, :subscriber_identifier, 5
    optional ::GooglePlay::EncryptedSubscriberInfo, :encrypted_subscriber_info, 6
    optional ::GooglePlay::CarrierBillingCredentials, :credentials, 7
    optional ::GooglePlay::CarrierTos, :accepted_carrier_tos, 8
  end
  
  class CarrierBillingInstrumentStatus
    optional ::GooglePlay::CarrierTos, :carrier_tos, 1
    optional ::Protobuf::Field::BoolField, :association_required, 2
    optional ::Protobuf::Field::BoolField, :password_required, 3
    optional ::GooglePlay::PasswordPrompt, :carrier_password_prompt, 4
    optional ::Protobuf::Field::Int32Field, :api_version, 5
    optional ::Protobuf::Field::StringField, :name, 6
  end
  
  class CarrierTos
    optional ::GooglePlay::CarrierTosEntry, :dcb_tos, 1
    optional ::GooglePlay::CarrierTosEntry, :pii_tos, 2
    optional ::Protobuf::Field::BoolField, :needs_dcb_tos_acceptance, 3
    optional ::Protobuf::Field::BoolField, :needs_pii_tos_acceptance, 4
  end
  
  class CarrierTosEntry
    optional ::Protobuf::Field::StringField, :url, 1
    optional ::Protobuf::Field::StringField, :version, 2
  end
  
  class CreditCardInstrument
    optional ::Protobuf::Field::Int32Field, :type, 1
    optional ::Protobuf::Field::StringField, :escrow_handle, 2
    optional ::Protobuf::Field::StringField, :last_digits, 3
    optional ::Protobuf::Field::Int32Field, :expiration_month, 4
    optional ::Protobuf::Field::Int32Field, :expiration_year, 5
    repeated ::GooglePlay::EfeParam, :escrow_efe_param, 6
  end
  
  class EfeParam
    optional ::Protobuf::Field::Int32Field, :key, 1
    optional ::Protobuf::Field::StringField, :value, 2
  end
  
  class InputValidationError
    optional ::Protobuf::Field::Int32Field, :input_field, 1
    optional ::Protobuf::Field::StringField, :error_message, 2
  end
  
  class Instrument
    optional ::Protobuf::Field::StringField, :instrument_id, 1
    optional ::GooglePlay::Address, :billing_address, 2
    optional ::GooglePlay::CreditCardInstrument, :credit_card, 3
    optional ::GooglePlay::CarrierBillingInstrument, :carrier_billing, 4
    optional ::GooglePlay::BillingAddressSpec, :billing_address_spec, 5
    optional ::Protobuf::Field::Int32Field, :instrument_family, 6
    optional ::GooglePlay::CarrierBillingInstrumentStatus, :carrier_billing_status, 7
    optional ::Protobuf::Field::StringField, :display_title, 8
  end
  
  class PasswordPrompt
    optional ::Protobuf::Field::StringField, :prompt, 1
    optional ::Protobuf::Field::StringField, :forgot_password_url, 2
  end
  
  class ContainerMetadata
    optional ::Protobuf::Field::StringField, :browse_url, 1
    optional ::Protobuf::Field::StringField, :next_page_url, 2
    optional ::Protobuf::Field::DoubleField, :relevance, 3
    optional ::Protobuf::Field::Int64Field, :estimated_results, 4
    optional ::Protobuf::Field::StringField, :analytics_cookie, 5
    optional ::Protobuf::Field::BoolField, :ordered, 6
  end
  
  class DebugInfo
    class Timing
      optional ::Protobuf::Field::StringField, :name, 3
      optional ::Protobuf::Field::DoubleField, :time_in_ms, 4
    end
    
    repeated ::Protobuf::Field::StringField, :message, 1
    repeated ::GooglePlay::DebugInfo::Timing, :timing, 2
  end
  
  class DeliveryResponse
    optional ::Protobuf::Field::Int32Field, :status, 1
    optional ::GooglePlay::AndroidAppDeliveryData, :app_delivery_data, 2
  end
  
  class BulkDetailsEntry
    optional ::GooglePlay::DocV2, :doc, 1
  end
  
  class BulkDetailsRequest
    repeated ::Protobuf::Field::StringField, :doc_id, 1
    optional ::Protobuf::Field::BoolField, :include_child_docs, 2
  end
  
  class BulkDetailsResponse
    repeated ::GooglePlay::BulkDetailsEntry, :entry, 1
  end
  
  class DetailsResponse
    optional ::GooglePlay::DocV1, :doc_v1, 1
    optional ::Protobuf::Field::StringField, :analytics_cookie, 2
    optional ::GooglePlay::Review, :user_review, 3
    optional ::GooglePlay::DocV2, :doc_v2, 4
    optional ::Protobuf::Field::StringField, :footer_html, 5
  end
  
  class DeviceConfigurationProto
    optional ::Protobuf::Field::Int32Field, :touch_screen, 1
    optional ::Protobuf::Field::Int32Field, :keyboard, 2
    optional ::Protobuf::Field::Int32Field, :navigation, 3
    optional ::Protobuf::Field::Int32Field, :screen_layout, 4
    optional ::Protobuf::Field::BoolField, :has_hard_keyboard, 5
    optional ::Protobuf::Field::BoolField, :has_five_way_navigation, 6
    optional ::Protobuf::Field::Int32Field, :screen_density, 7
    optional ::Protobuf::Field::Int32Field, :gl_es_version, 8
    repeated ::Protobuf::Field::StringField, :system_shared_library, 9
    repeated ::Protobuf::Field::StringField, :system_available_feature, 10
    repeated ::Protobuf::Field::StringField, :native_platform, 11
    optional ::Protobuf::Field::Int32Field, :screen_width, 12
    optional ::Protobuf::Field::Int32Field, :screen_height, 13
    repeated ::Protobuf::Field::StringField, :system_supported_locale, 14
    repeated ::Protobuf::Field::StringField, :gl_extension, 15
    optional ::Protobuf::Field::Int32Field, :device_class, 16
    optional ::Protobuf::Field::Int32Field, :max_apk_download_size_mb, 17
  end
  
  class Document
    optional ::GooglePlay::Docid, :docid, 1
    optional ::GooglePlay::Docid, :fetch_docid, 2
    optional ::GooglePlay::Docid, :sample_docid, 3
    optional ::Protobuf::Field::StringField, :title, 4
    optional ::Protobuf::Field::StringField, :url, 5
    repeated ::Protobuf::Field::StringField, :snippet, 6
    optional ::GooglePlay::Offer, :price_deprecated, 7
    optional ::GooglePlay::Availability, :availability, 9
    repeated ::GooglePlay::Image, :image, 10
    repeated ::GooglePlay::Document, :child, 11
    optional ::GooglePlay::AggregateRating, :aggregate_rating, 13
    repeated ::GooglePlay::Offer, :offer, 14
    repeated ::GooglePlay::TranslatedText, :translated_snippet, 15
    repeated ::GooglePlay::DocumentVariant, :document_variant, 16
    repeated ::Protobuf::Field::StringField, :category_id, 17
    repeated ::GooglePlay::Document, :decoration, 18
    repeated ::GooglePlay::Document, :parent, 19
    optional ::Protobuf::Field::StringField, :privacy_policy_url, 20
  end
  
  class DocumentVariant
    optional ::Protobuf::Field::Int32Field, :variation_type, 1
    optional ::GooglePlay::Rule, :rule, 2
    optional ::Protobuf::Field::StringField, :title, 3
    repeated ::Protobuf::Field::StringField, :snippet, 4
    optional ::Protobuf::Field::StringField, :recent_changes, 5
    repeated ::GooglePlay::TranslatedText, :auto_translation, 6
    repeated ::GooglePlay::Offer, :offer, 7
    optional ::Protobuf::Field::Int64Field, :channel_id, 9
    repeated ::GooglePlay::Document, :child, 10
    repeated ::GooglePlay::Document, :decoration, 11
  end
  
  class Image
    class Dimension
      optional ::Protobuf::Field::Int32Field, :width, 3
      optional ::Protobuf::Field::Int32Field, :height, 4
    end
    
    class Citation
      optional ::Protobuf::Field::StringField, :title_localized, 11
      optional ::Protobuf::Field::StringField, :url, 12
    end
    
    optional ::Protobuf::Field::Int32Field, :image_type, 1
    optional ::GooglePlay::Image::Dimension, :dimension, 2
    optional ::Protobuf::Field::StringField, :image_url, 5
    optional ::Protobuf::Field::StringField, :alt_text_localized, 6
    optional ::Protobuf::Field::StringField, :secure_url, 7
    optional ::Protobuf::Field::Int32Field, :position_in_sequence, 8
    optional ::Protobuf::Field::BoolField, :supports_fife_url_options, 9
    optional ::GooglePlay::Image::Citation, :citation, 10
  end
  
  class TranslatedText
    optional ::Protobuf::Field::StringField, :text, 1
    optional ::Protobuf::Field::StringField, :source_locale, 2
    optional ::Protobuf::Field::StringField, :target_locale, 3
  end
  
  class Badge
    optional ::Protobuf::Field::StringField, :title, 1
    repeated ::GooglePlay::Image, :image, 2
    optional ::Protobuf::Field::StringField, :browse_url, 3
  end
  
  class ContainerWithBanner
    optional ::Protobuf::Field::StringField, :color_theme_argb, 1
  end
  
  class DealOfTheDay
    optional ::Protobuf::Field::StringField, :featured_header, 1
    optional ::Protobuf::Field::StringField, :color_theme_argb, 2
  end
  
  class EditorialSeriesContainer
    optional ::Protobuf::Field::StringField, :series_title, 1
    optional ::Protobuf::Field::StringField, :series_subtitle, 2
    optional ::Protobuf::Field::StringField, :episode_title, 3
    optional ::Protobuf::Field::StringField, :episode_subtitle, 4
    optional ::Protobuf::Field::StringField, :color_theme_argb, 5
  end
  
  class Link
    optional ::Protobuf::Field::StringField, :uri, 1
  end
  
  class PlusOneData
    optional ::Protobuf::Field::BoolField, :set_by_user, 1
    optional ::Protobuf::Field::Int64Field, :total, 2
    optional ::Protobuf::Field::Int64Field, :circles_total, 3
    repeated ::GooglePlay::PlusPerson, :circles_people, 4
  end
  
  class PlusPerson
    optional ::Protobuf::Field::StringField, :display_name, 2
    optional ::Protobuf::Field::StringField, :profile_image_url, 4
  end
  
  class PromotedDoc
    optional ::Protobuf::Field::StringField, :title, 1
    optional ::Protobuf::Field::StringField, :subtitle, 2
    repeated ::GooglePlay::Image, :image, 3
    optional ::Protobuf::Field::StringField, :description_html, 4
    optional ::Protobuf::Field::StringField, :details_url, 5
  end
  
  class Reason
    optional ::Protobuf::Field::StringField, :brief_reason, 1
    optional ::Protobuf::Field::StringField, :detailed_reason, 2
    optional ::Protobuf::Field::StringField, :unique_id, 3
  end
  
  class SectionMetadata
    optional ::Protobuf::Field::StringField, :header, 1
    optional ::Protobuf::Field::StringField, :list_url, 2
    optional ::Protobuf::Field::StringField, :browse_url, 3
    optional ::Protobuf::Field::StringField, :description_html, 4
  end
  
  class SeriesAntenna
    optional ::Protobuf::Field::StringField, :series_title, 1
    optional ::Protobuf::Field::StringField, :series_subtitle, 2
    optional ::Protobuf::Field::StringField, :episode_title, 3
    optional ::Protobuf::Field::StringField, :episode_subtitle, 4
    optional ::Protobuf::Field::StringField, :color_theme_argb, 5
    optional ::GooglePlay::SectionMetadata, :section_tracks, 6
    optional ::GooglePlay::SectionMetadata, :section_albums, 7
  end
  
  class Template
    optional ::GooglePlay::SeriesAntenna, :series_antenna, 1
    optional ::GooglePlay::TileTemplate, :tile_graphic_2_x_1, 2
    optional ::GooglePlay::TileTemplate, :tile_graphic_4_x_2, 3
    optional ::GooglePlay::TileTemplate, :tile_graphic_colored_title_2_x_1, 4
    optional ::GooglePlay::TileTemplate, :tile_graphic_upper_left_title_2_x_1, 5
    optional ::GooglePlay::TileTemplate, :tile_details_reflected_graphic_2_x_2, 6
    optional ::GooglePlay::TileTemplate, :tile_four_block_4_x_2, 7
    optional ::GooglePlay::ContainerWithBanner, :container_with_banner, 8
    optional ::GooglePlay::DealOfTheDay, :deal_of_the_day, 9
    optional ::GooglePlay::TileTemplate, :tile_graphic_colored_title_4_x_2, 10
    optional ::GooglePlay::EditorialSeriesContainer, :editorial_series_container, 11
  end
  
  class TileTemplate
    optional ::Protobuf::Field::StringField, :color_theme_argb, 1
    optional ::Protobuf::Field::StringField, :color_text_argb, 2
  end
  
  class Warning
    optional ::Protobuf::Field::StringField, :localized_message, 1
  end
  
  class AlbumDetails
    optional ::Protobuf::Field::StringField, :name, 1
    optional ::GooglePlay::MusicDetails, :details, 2
    optional ::GooglePlay::ArtistDetails, :display_artist, 3
  end
  
  class AppDetails
    optional ::Protobuf::Field::StringField, :developer_name, 1
    optional ::Protobuf::Field::Int32Field, :major_version_number, 2
    optional ::Protobuf::Field::Int32Field, :version_code, 3
    optional ::Protobuf::Field::StringField, :version_string, 4
    optional ::Protobuf::Field::StringField, :title, 5
    repeated ::Protobuf::Field::StringField, :app_category, 7
    optional ::Protobuf::Field::Int32Field, :content_rating, 8
    optional ::Protobuf::Field::Int64Field, :installation_size, 9
    repeated ::Protobuf::Field::StringField, :permission, 10
    optional ::Protobuf::Field::StringField, :developer_email, 11
    optional ::Protobuf::Field::StringField, :developer_website, 12
    optional ::Protobuf::Field::StringField, :num_downloads, 13
    optional ::Protobuf::Field::StringField, :package_name, 14
    optional ::Protobuf::Field::StringField, :recent_changes_html, 15
    optional ::Protobuf::Field::StringField, :upload_date, 16
    repeated ::GooglePlay::FileMetadata, :file, 17
    optional ::Protobuf::Field::StringField, :app_type, 18
  end
  
  class ArtistDetails
    optional ::Protobuf::Field::StringField, :details_url, 1
    optional ::Protobuf::Field::StringField, :name, 2
    optional ::GooglePlay::ArtistExternalLinks, :external_links, 3
  end
  
  class ArtistExternalLinks
    repeated ::Protobuf::Field::StringField, :website_url, 1
    optional ::Protobuf::Field::StringField, :google_plus_profile_url, 2
    optional ::Protobuf::Field::StringField, :youtube_channel_url, 3
  end
  
  class DocumentDetails
    optional ::GooglePlay::AppDetails, :app_details, 1
    optional ::GooglePlay::AlbumDetails, :album_details, 2
    optional ::GooglePlay::ArtistDetails, :artist_details, 3
    optional ::GooglePlay::SongDetails, :song_details, 4
    optional ::GooglePlay::BookDetails, :book_details, 5
    optional ::GooglePlay::VideoDetails, :video_details, 6
    optional ::GooglePlay::SubscriptionDetails, :subscription_details, 7
    optional ::GooglePlay::MagazineDetails, :magazine_details, 8
    optional ::GooglePlay::TvShowDetails, :tv_show_details, 9
    optional ::GooglePlay::TvSeasonDetails, :tv_season_details, 10
    optional ::GooglePlay::TvEpisodeDetails, :tv_episode_details, 11
  end
  
  class FileMetadata
    optional ::Protobuf::Field::Int32Field, :file_type, 1
    optional ::Protobuf::Field::Int32Field, :version_code, 2
    optional ::Protobuf::Field::Int64Field, :size, 3
  end
  
  class MagazineDetails
    optional ::Protobuf::Field::StringField, :parent_details_url, 1
    optional ::Protobuf::Field::StringField, :device_availability_description_html, 2
    optional ::Protobuf::Field::StringField, :psv_description, 3
    optional ::Protobuf::Field::StringField, :delivery_frequency_description, 4
  end
  
  class MusicDetails
    optional ::Protobuf::Field::Int32Field, :censoring, 1
    optional ::Protobuf::Field::Int32Field, :duration_sec, 2
    optional ::Protobuf::Field::StringField, :original_release_date, 3
    optional ::Protobuf::Field::StringField, :label, 4
    repeated ::GooglePlay::ArtistDetails, :artist, 5
    repeated ::Protobuf::Field::StringField, :genre, 6
    optional ::Protobuf::Field::StringField, :release_date, 7
    repeated ::Protobuf::Field::Int32Field, :release_type, 8
  end
  
  class SongDetails
    optional ::Protobuf::Field::StringField, :name, 1
    optional ::GooglePlay::MusicDetails, :details, 2
    optional ::Protobuf::Field::StringField, :album_name, 3
    optional ::Protobuf::Field::Int32Field, :track_number, 4
    optional ::Protobuf::Field::StringField, :preview_url, 5
    optional ::GooglePlay::ArtistDetails, :display_artist, 6
  end
  
  class SubscriptionDetails
    optional ::Protobuf::Field::Int32Field, :subscription_period, 1
  end
  
  class Trailer
    optional ::Protobuf::Field::StringField, :trailer_id, 1
    optional ::Protobuf::Field::StringField, :title, 2
    optional ::Protobuf::Field::StringField, :thumbnail_url, 3
    optional ::Protobuf::Field::StringField, :watch_url, 4
    optional ::Protobuf::Field::StringField, :duration, 5
  end
  
  class TvEpisodeDetails
    optional ::Protobuf::Field::StringField, :parent_details_url, 1
    optional ::Protobuf::Field::Int32Field, :episode_index, 2
    optional ::Protobuf::Field::StringField, :release_date, 3
  end
  
  class TvSeasonDetails
    optional ::Protobuf::Field::StringField, :parent_details_url, 1
    optional ::Protobuf::Field::Int32Field, :season_index, 2
    optional ::Protobuf::Field::StringField, :release_date, 3
    optional ::Protobuf::Field::StringField, :broadcaster, 4
  end
  
  class TvShowDetails
    optional ::Protobuf::Field::Int32Field, :season_count, 1
    optional ::Protobuf::Field::Int32Field, :start_year, 2
    optional ::Protobuf::Field::Int32Field, :end_year, 3
    optional ::Protobuf::Field::StringField, :broadcaster, 4
  end
  
  class VideoCredit
    optional ::Protobuf::Field::Int32Field, :credit_type, 1
    optional ::Protobuf::Field::StringField, :credit, 2
    repeated ::Protobuf::Field::StringField, :name, 3
  end
  
  class VideoDetails
    repeated ::GooglePlay::VideoCredit, :credit, 1
    optional ::Protobuf::Field::StringField, :duration, 2
    optional ::Protobuf::Field::StringField, :release_date, 3
    optional ::Protobuf::Field::StringField, :content_rating, 4
    optional ::Protobuf::Field::Int64Field, :likes, 5
    optional ::Protobuf::Field::Int64Field, :dislikes, 6
    repeated ::Protobuf::Field::StringField, :genre, 7
    repeated ::GooglePlay::Trailer, :trailer, 8
    repeated ::GooglePlay::VideoRentalTerm, :rental_term, 9
  end
  
  class VideoRentalTerm
    class Term
      optional ::Protobuf::Field::StringField, :header, 5
      optional ::Protobuf::Field::StringField, :body, 6
    end
    
    optional ::Protobuf::Field::Int32Field, :offer_type, 1
    optional ::Protobuf::Field::StringField, :offer_abbreviation, 2
    optional ::Protobuf::Field::StringField, :rental_header, 3
    repeated ::GooglePlay::VideoRentalTerm::Term, :term, 4
  end
  
  class Bucket
    repeated ::GooglePlay::DocV1, :document, 1
    optional ::Protobuf::Field::BoolField, :multi_corpus, 2
    optional ::Protobuf::Field::StringField, :title, 3
    optional ::Protobuf::Field::StringField, :icon_url, 4
    optional ::Protobuf::Field::StringField, :full_contents_url, 5
    optional ::Protobuf::Field::DoubleField, :relevance, 6
    optional ::Protobuf::Field::Int64Field, :estimated_results, 7
    optional ::Protobuf::Field::StringField, :analytics_cookie, 8
    optional ::Protobuf::Field::StringField, :full_contents_list_url, 9
    optional ::Protobuf::Field::StringField, :next_page_url, 10
    optional ::Protobuf::Field::BoolField, :ordered, 11
  end
  
  class ListResponse
    repeated ::GooglePlay::Bucket, :bucket, 1
    repeated ::GooglePlay::DocV2, :doc, 2
  end
  
  class DocV1
    optional ::GooglePlay::Document, :finsky_doc, 1
    optional ::Protobuf::Field::StringField, :docid, 2
    optional ::Protobuf::Field::StringField, :details_url, 3
    optional ::Protobuf::Field::StringField, :reviews_url, 4
    optional ::Protobuf::Field::StringField, :related_list_url, 5
    optional ::Protobuf::Field::StringField, :more_by_list_url, 6
    optional ::Protobuf::Field::StringField, :share_url, 7
    optional ::Protobuf::Field::StringField, :creator, 8
    optional ::GooglePlay::DocumentDetails, :details, 9
    optional ::Protobuf::Field::StringField, :description_html, 10
    optional ::Protobuf::Field::StringField, :related_browse_url, 11
    optional ::Protobuf::Field::StringField, :more_by_browse_url, 12
    optional ::Protobuf::Field::StringField, :related_header, 13
    optional ::Protobuf::Field::StringField, :more_by_header, 14
    optional ::Protobuf::Field::StringField, :title, 15
    optional ::GooglePlay::PlusOneData, :plus_one_data, 16
    optional ::Protobuf::Field::StringField, :warning_message, 17
  end
  
  class Annotations
    optional ::GooglePlay::SectionMetadata, :section_related, 1
    optional ::GooglePlay::SectionMetadata, :section_more_by, 2
    optional ::GooglePlay::PlusOneData, :plus_one_data, 3
    repeated ::GooglePlay::Warning, :warning, 4
    optional ::GooglePlay::SectionMetadata, :section_body_of_work, 5
    optional ::GooglePlay::SectionMetadata, :section_core_content, 6
    optional ::GooglePlay::Template, :template, 7
    repeated ::GooglePlay::Badge, :badge_for_creator, 8
    repeated ::GooglePlay::Badge, :badge_for_doc, 9
    optional ::GooglePlay::Link, :link, 10
    optional ::GooglePlay::SectionMetadata, :section_cross_sell, 11
    optional ::GooglePlay::SectionMetadata, :section_related_doc_type, 12
    repeated ::GooglePlay::PromotedDoc, :promoted_doc, 13
    optional ::Protobuf::Field::StringField, :offer_note, 14
    repeated ::GooglePlay::DocV2, :subscription, 16
    optional ::GooglePlay::Reason, :reason, 17
    optional ::Protobuf::Field::StringField, :privacy_policy_url, 18
  end
  
  class DocV2
    optional ::Protobuf::Field::StringField, :docid, 1
    optional ::Protobuf::Field::StringField, :backend_docid, 2
    optional ::Protobuf::Field::Int32Field, :doc_type, 3
    optional ::Protobuf::Field::Int32Field, :backend_id, 4
    optional ::Protobuf::Field::StringField, :title, 5
    optional ::Protobuf::Field::StringField, :creator, 6
    optional ::Protobuf::Field::StringField, :description_html, 7
    repeated ::GooglePlay::Offer, :offer, 8
    optional ::GooglePlay::Availability, :availability, 9
    repeated ::GooglePlay::Image, :image, 10
    repeated ::GooglePlay::DocV2, :child, 11
    optional ::GooglePlay::ContainerMetadata, :container_metadata, 12
    optional ::GooglePlay::DocumentDetails, :details, 13
    optional ::GooglePlay::AggregateRating, :aggregate_rating, 14
    optional ::GooglePlay::Annotations, :annotations, 15
    optional ::Protobuf::Field::StringField, :details_url, 16
    optional ::Protobuf::Field::StringField, :share_url, 17
    optional ::Protobuf::Field::StringField, :reviews_url, 18
    optional ::Protobuf::Field::StringField, :backend_url, 19
    optional ::Protobuf::Field::StringField, :purchase_details_url, 20
    optional ::Protobuf::Field::BoolField, :details_reusable, 21
    optional ::Protobuf::Field::StringField, :subtitle, 22
  end
  
  class EncryptedSubscriberInfo
    optional ::Protobuf::Field::StringField, :data, 1
    optional ::Protobuf::Field::StringField, :encrypted_key, 2
    optional ::Protobuf::Field::StringField, :signature, 3
    optional ::Protobuf::Field::StringField, :init_vector, 4
    optional ::Protobuf::Field::Int32Field, :google_key_version, 5
    optional ::Protobuf::Field::Int32Field, :carrier_key_version, 6
  end
  
  class Availability
    class PerDeviceAvailabilityRestriction
      optional ::Protobuf::Field::Fixed64Field, :android_id, 10
      optional ::Protobuf::Field::Int32Field, :device_restriction, 11
      optional ::Protobuf::Field::Int64Field, :channel_id, 12
      optional ::GooglePlay::FilterEvaluationInfo, :filter_info, 15
    end
    
    optional ::Protobuf::Field::Int32Field, :restriction, 5
    optional ::Protobuf::Field::Int32Field, :offer_type, 6
    optional ::GooglePlay::Rule, :rule, 7
    repeated ::GooglePlay::Availability::PerDeviceAvailabilityRestriction, :perdeviceavailabilityrestriction, 9
    optional ::Protobuf::Field::BoolField, :available_if_owned, 13
    repeated ::GooglePlay::Install, :install, 14
    optional ::GooglePlay::FilterEvaluationInfo, :filter_info, 16
    optional ::GooglePlay::OwnershipInfo, :ownership_info, 17
  end
  
  class FilterEvaluationInfo
    repeated ::GooglePlay::RuleEvaluation, :rule_evaluation, 1
  end
  
  class Rule
    optional ::Protobuf::Field::BoolField, :negate, 1
    optional ::Protobuf::Field::Int32Field, :operator, 2
    optional ::Protobuf::Field::Int32Field, :key, 3
    repeated ::Protobuf::Field::StringField, :string_arg, 4
    repeated ::Protobuf::Field::Int64Field, :long_arg, 5
    repeated ::Protobuf::Field::DoubleField, :double_arg, 6
    repeated ::GooglePlay::Rule, :subrule, 7
    optional ::Protobuf::Field::Int32Field, :response_code, 8
    optional ::Protobuf::Field::StringField, :comment, 9
    repeated ::Protobuf::Field::Fixed64Field, :string_arg_hash, 10
    repeated ::Protobuf::Field::Int32Field, :const_arg, 11
  end
  
  class RuleEvaluation
    optional ::GooglePlay::Rule, :rule, 1
    repeated ::Protobuf::Field::StringField, :actual_string_value, 2
    repeated ::Protobuf::Field::Int64Field, :actual_long_value, 3
    repeated ::Protobuf::Field::BoolField, :actual_bool_value, 4
    repeated ::Protobuf::Field::DoubleField, :actual_double_value, 5
  end
  
  class LibraryAppDetails
    optional ::Protobuf::Field::StringField, :certificate_hash, 2
    optional ::Protobuf::Field::Int64Field, :refund_timeout_timestamp_msec, 3
    optional ::Protobuf::Field::Int64Field, :post_delivery_refund_window_msec, 4
  end
  
  class LibraryMutation
    optional ::GooglePlay::Docid, :docid, 1
    optional ::Protobuf::Field::Int32Field, :offer_type, 2
    optional ::Protobuf::Field::Int64Field, :document_hash, 3
    optional ::Protobuf::Field::BoolField, :deleted, 4
    optional ::GooglePlay::LibraryAppDetails, :app_details, 5
    optional ::GooglePlay::LibrarySubscriptionDetails, :subscription_details, 6
  end
  
  class LibrarySubscriptionDetails
    optional ::Protobuf::Field::Int64Field, :initiation_timestamp_msec, 1
    optional ::Protobuf::Field::Int64Field, :valid_until_timestamp_msec, 2
    optional ::Protobuf::Field::BoolField, :auto_renewing, 3
    optional ::Protobuf::Field::Int64Field, :trial_until_timestamp_msec, 4
  end
  
  class LibraryUpdate
    optional ::Protobuf::Field::Int32Field, :status, 1
    optional ::Protobuf::Field::Int32Field, :corpus, 2
    optional ::Protobuf::Field::BytesField, :server_token, 3
    repeated ::GooglePlay::LibraryMutation, :mutation, 4
    optional ::Protobuf::Field::BoolField, :has_more, 5
    optional ::Protobuf::Field::StringField, :library_id, 6
  end
  
  class ClientLibraryState
    optional ::Protobuf::Field::Int32Field, :corpus, 1
    optional ::Protobuf::Field::BytesField, :server_token, 2
    optional ::Protobuf::Field::Int64Field, :hash_code_sum, 3
    optional ::Protobuf::Field::Int32Field, :library_size, 4
  end
  
  class LibraryReplicationRequest
    repeated ::GooglePlay::ClientLibraryState, :library_state, 1
  end
  
  class LibraryReplicationResponse
    repeated ::GooglePlay::LibraryUpdate, :update, 1
  end
  
  class ClickLogEvent
    optional ::Protobuf::Field::Int64Field, :event_time, 1
    optional ::Protobuf::Field::StringField, :url, 2
    optional ::Protobuf::Field::StringField, :list_id, 3
    optional ::Protobuf::Field::StringField, :referrer_url, 4
    optional ::Protobuf::Field::StringField, :referrer_list_id, 5
  end
  
  class LogRequest
    repeated ::GooglePlay::ClickLogEvent, :click_event, 1
  end
  
  class AndroidAppNotificationData
    optional ::Protobuf::Field::Int32Field, :version_code, 1
    optional ::Protobuf::Field::StringField, :asset_id, 2
  end
  
  class InAppNotificationData
    optional ::Protobuf::Field::StringField, :checkout_order_id, 1
    optional ::Protobuf::Field::StringField, :in_app_notification_id, 2
  end
  
  class LibraryDirtyData
    optional ::Protobuf::Field::Int32Field, :backend, 1
  end
  
  class Notification
    optional ::Protobuf::Field::Int32Field, :notification_type, 1
    optional ::Protobuf::Field::Int64Field, :timestamp, 3
    optional ::GooglePlay::Docid, :docid, 4
    optional ::Protobuf::Field::StringField, :doc_title, 5
    optional ::Protobuf::Field::StringField, :user_email, 6
    optional ::GooglePlay::AndroidAppNotificationData, :app_data, 7
    optional ::GooglePlay::AndroidAppDeliveryData, :app_delivery_data, 8
    optional ::GooglePlay::PurchaseRemovalData, :purchase_removal_data, 9
    optional ::GooglePlay::UserNotificationData, :user_notification_data, 10
    optional ::GooglePlay::InAppNotificationData, :in_app_notification_data, 11
    optional ::GooglePlay::PurchaseDeclinedData, :purchase_declined_data, 12
    optional ::Protobuf::Field::StringField, :notification_id, 13
    optional ::GooglePlay::LibraryUpdate, :library_update, 14
    optional ::GooglePlay::LibraryDirtyData, :library_dirty_data, 15
  end
  
  class PurchaseDeclinedData
    optional ::Protobuf::Field::Int32Field, :reason, 1
    optional ::Protobuf::Field::BoolField, :show_notification, 2
  end
  
  class PurchaseRemovalData
    optional ::Protobuf::Field::BoolField, :malicious, 1
  end
  
  class UserNotificationData
    optional ::Protobuf::Field::StringField, :notification_title, 1
    optional ::Protobuf::Field::StringField, :notification_text, 2
    optional ::Protobuf::Field::StringField, :ticker_text, 3
    optional ::Protobuf::Field::StringField, :dialog_title, 4
    optional ::Protobuf::Field::StringField, :dialog_text, 5
  end
  
  class AggregateRating
    optional ::Protobuf::Field::Int32Field, :type, 1
    optional ::Protobuf::Field::FloatField, :star_rating, 2
    optional ::Protobuf::Field::Uint64Field, :ratings_count, 3
    optional ::Protobuf::Field::Uint64Field, :one_star_ratings, 4
    optional ::Protobuf::Field::Uint64Field, :two_star_ratings, 5
    optional ::Protobuf::Field::Uint64Field, :three_star_ratings, 6
    optional ::Protobuf::Field::Uint64Field, :four_star_ratings, 7
    optional ::Protobuf::Field::Uint64Field, :five_star_ratings, 8
    optional ::Protobuf::Field::Uint64Field, :thumbs_up_count, 9
    optional ::Protobuf::Field::Uint64Field, :thumbs_down_count, 10
    optional ::Protobuf::Field::Uint64Field, :comment_count, 11
    optional ::Protobuf::Field::DoubleField, :bayesian_mean_rating, 12
  end
  
  class DirectPurchase
    optional ::Protobuf::Field::StringField, :details_url, 1
    optional ::Protobuf::Field::StringField, :purchase_docid, 2
    optional ::Protobuf::Field::StringField, :parent_docid, 3
    optional ::Protobuf::Field::Int32Field, :offer_type, 4
  end
  
  class ResolveLinkResponse
    optional ::Protobuf::Field::StringField, :details_url, 1
    optional ::Protobuf::Field::StringField, :browse_url, 2
    optional ::Protobuf::Field::StringField, :search_url, 3
    optional ::GooglePlay::DirectPurchase, :direct_purchase, 4
    optional ::Protobuf::Field::StringField, :home_url, 5
  end
  
  class Payload
    optional ::GooglePlay::ListResponse, :list_response, 1
    optional ::GooglePlay::DetailsResponse, :details_response, 2
    optional ::GooglePlay::ReviewResponse, :review_response, 3
    optional ::GooglePlay::BuyResponse, :buy_response, 4
    optional ::GooglePlay::SearchResponse, :search_response, 5
    optional ::GooglePlay::TocResponse, :toc_response, 6
    optional ::GooglePlay::BrowseResponse, :browse_response, 7
    optional ::GooglePlay::PurchaseStatusResponse, :purchase_status_response, 8
    optional ::GooglePlay::UpdateInstrumentResponse, :update_instrument_response, 9
    optional ::GooglePlay::LogResponse, :log_response, 10
    optional ::GooglePlay::CheckInstrumentResponse, :check_instrument_response, 11
    optional ::GooglePlay::PlusOneResponse, :plus_one_response, 12
    optional ::GooglePlay::FlagContentResponse, :flag_content_response, 13
    optional ::GooglePlay::AckNotificationResponse, :ack_notification_response, 14
    optional ::GooglePlay::InitiateAssociationResponse, :initiate_association_response, 15
    optional ::GooglePlay::VerifyAssociationResponse, :verify_association_response, 16
    optional ::GooglePlay::LibraryReplicationResponse, :library_replication_response, 17
    optional ::GooglePlay::RevokeResponse, :revoke_response, 18
    optional ::GooglePlay::BulkDetailsResponse, :bulk_details_response, 19
    optional ::GooglePlay::ResolveLinkResponse, :resolve_link_response, 20
    optional ::GooglePlay::DeliveryResponse, :delivery_response, 21
    optional ::GooglePlay::AcceptTosResponse, :accept_tos_response, 22
    optional ::GooglePlay::RateSuggestedContentResponse, :rate_suggested_content_response, 23
    optional ::GooglePlay::CheckPromoOfferResponse, :check_promo_offer_response, 24
  end
  
  class PreFetch
    optional ::Protobuf::Field::StringField, :url, 1
    optional ::Protobuf::Field::BytesField, :response, 2
    optional ::Protobuf::Field::StringField, :etag, 3
    optional ::Protobuf::Field::Int64Field, :ttl, 4
    optional ::Protobuf::Field::Int64Field, :soft_ttl, 5
  end
  
  class ResponseWrapper
    optional ::GooglePlay::Payload, :payload, 1
    optional ::GooglePlay::ServerCommands, :commands, 2
    repeated ::GooglePlay::PreFetch, :pre_fetch, 3
    repeated ::GooglePlay::Notification, :notification, 4
  end
  
  class ServerCommands
    optional ::Protobuf::Field::BoolField, :clear_cache, 1
    optional ::Protobuf::Field::StringField, :display_error_message, 2
    optional ::Protobuf::Field::StringField, :log_error_stacktrace, 3
  end
  
  class GetReviewsResponse
    repeated ::GooglePlay::Review, :review, 1
    optional ::Protobuf::Field::Int64Field, :matching_count, 2
  end
  
  class Review
    optional ::Protobuf::Field::StringField, :author_name, 1
    optional ::Protobuf::Field::StringField, :url, 2
    optional ::Protobuf::Field::StringField, :source, 3
    optional ::Protobuf::Field::StringField, :document_version, 4
    optional ::Protobuf::Field::Int64Field, :timestamp_msec, 5
    optional ::Protobuf::Field::Int32Field, :star_rating, 6
    optional ::Protobuf::Field::StringField, :title, 7
    optional ::Protobuf::Field::StringField, :comment, 8
    optional ::Protobuf::Field::StringField, :comment_id, 9
    optional ::Protobuf::Field::StringField, :device_name, 19
    optional ::Protobuf::Field::StringField, :reply_text, 29
    optional ::Protobuf::Field::Int64Field, :reply_timestamp_msec, 30
  end
  
  class ReviewResponse
    optional ::GooglePlay::GetReviewsResponse, :get_response, 1
    optional ::Protobuf::Field::StringField, :next_page_url, 2
  end
  
  class RevokeResponse
    optional ::GooglePlay::LibraryUpdate, :library_update, 1
  end
  
  class RelatedSearch
    optional ::Protobuf::Field::StringField, :search_url, 1
    optional ::Protobuf::Field::StringField, :header, 2
    optional ::Protobuf::Field::Int32Field, :backend_id, 3
    optional ::Protobuf::Field::Int32Field, :doc_type, 4
    optional ::Protobuf::Field::BoolField, :current, 5
  end
  
  class SearchResponse
    optional ::Protobuf::Field::StringField, :original_query, 1
    optional ::Protobuf::Field::StringField, :suggested_query, 2
    optional ::Protobuf::Field::BoolField, :aggregate_query, 3
    repeated ::GooglePlay::Bucket, :bucket, 4
    repeated ::GooglePlay::DocV2, :doc, 5
    repeated ::GooglePlay::RelatedSearch, :related_search, 6
  end
  
  class CorpusMetadata
    optional ::Protobuf::Field::Int32Field, :backend, 1
    optional ::Protobuf::Field::StringField, :name, 2
    optional ::Protobuf::Field::StringField, :landing_url, 3
    optional ::Protobuf::Field::StringField, :library_name, 4
  end
  
  class Experiments
    repeated ::Protobuf::Field::StringField, :experiment_id, 1
  end
  
  class TocResponse
    repeated ::GooglePlay::CorpusMetadata, :corpus, 1
    optional ::Protobuf::Field::Int32Field, :tos_version_deprecated, 2
    optional ::Protobuf::Field::StringField, :tos_content, 3
    optional ::Protobuf::Field::StringField, :home_url, 4
    optional ::GooglePlay::Experiments, :experiments, 5
    optional ::Protobuf::Field::StringField, :tos_checkbox_text_marketing_emails, 6
    optional ::Protobuf::Field::StringField, :tos_token, 7
    optional ::GooglePlay::UserSettings, :user_settings, 8
    optional ::Protobuf::Field::StringField, :icon_override_url, 9
  end
  
  class UserSettings
    optional ::Protobuf::Field::BoolField, :tos_checkbox_marketing_emails_opted_in, 1
  end
  
  class AckNotificationsRequestProto
    repeated ::Protobuf::Field::StringField, :notification_id, 1
    optional ::GooglePlay::SignatureHashProto, :signature_hash, 2
    repeated ::Protobuf::Field::StringField, :nack_notification_id, 3
  end
  
  class AddressProto
    optional ::Protobuf::Field::StringField, :address_1, 1
    optional ::Protobuf::Field::StringField, :address_2, 2
    optional ::Protobuf::Field::StringField, :city, 3
    optional ::Protobuf::Field::StringField, :state, 4
    optional ::Protobuf::Field::StringField, :postal_code, 5
    optional ::Protobuf::Field::StringField, :country, 6
    optional ::Protobuf::Field::StringField, :name, 7
    optional ::Protobuf::Field::StringField, :type, 8
    optional ::Protobuf::Field::StringField, :phone, 9
  end
  
  class AppDataProto
    optional ::Protobuf::Field::StringField, :key, 1
    optional ::Protobuf::Field::StringField, :value, 2
  end
  
  class AppSuggestionProto
    optional ::GooglePlay::ExternalAssetProto, :asset_info, 1
  end
  
  class AssetIdentifierProto
    optional ::Protobuf::Field::StringField, :package_name, 1
    optional ::Protobuf::Field::Int32Field, :version_code, 2
    optional ::Protobuf::Field::StringField, :asset_id, 3
  end
  
  class AssetsRequestProto
    optional ::Protobuf::Field::Int32Field, :asset_type, 1
    optional ::Protobuf::Field::StringField, :query, 2
    optional ::Protobuf::Field::StringField, :category_id, 3
    repeated ::Protobuf::Field::StringField, :asset_id, 4
    optional ::Protobuf::Field::BoolField, :retrieve_vending_history, 5
    optional ::Protobuf::Field::BoolField, :retrieve_extended_info, 6
    optional ::Protobuf::Field::Int32Field, :sort_order, 7
    optional ::Protobuf::Field::Int64Field, :start_index, 8
    optional ::Protobuf::Field::Int64Field, :num_entries, 9
    optional ::Protobuf::Field::Int32Field, :view_filter, 10
    optional ::Protobuf::Field::StringField, :ranking_type, 11
    optional ::Protobuf::Field::BoolField, :retrieve_carrier_channel, 12
    repeated ::Protobuf::Field::StringField, :pending_download_asset_id, 13
    optional ::Protobuf::Field::BoolField, :reconstruct_vending_history, 14
    optional ::Protobuf::Field::BoolField, :unfiltered_results, 15
    repeated ::Protobuf::Field::StringField, :badge_id, 16
  end
  
  class AssetsResponseProto
    repeated ::GooglePlay::ExternalAssetProto, :asset, 1
    optional ::Protobuf::Field::Int64Field, :num_total_entries, 2
    optional ::Protobuf::Field::StringField, :corrected_query, 3
    repeated ::GooglePlay::ExternalAssetProto, :alt_asset, 4
    optional ::Protobuf::Field::Int64Field, :num_corrected_entries, 5
    optional ::Protobuf::Field::StringField, :header, 6
    optional ::Protobuf::Field::Int32Field, :list_type, 7
  end
  
  class BillingEventRequestProto
    optional ::Protobuf::Field::Int32Field, :event_type, 1
    optional ::Protobuf::Field::StringField, :billing_parameters_id, 2
    optional ::Protobuf::Field::BoolField, :result_success, 3
    optional ::Protobuf::Field::StringField, :client_message, 4
    optional ::GooglePlay::ExternalCarrierBillingInstrumentProto, :carrier_instrument, 5
  end
  
  class BillingParameterProto
    optional ::Protobuf::Field::StringField, :id, 1
    optional ::Protobuf::Field::StringField, :name, 2
    repeated ::Protobuf::Field::StringField, :mnc_mcc, 3
    repeated ::Protobuf::Field::StringField, :backend_url, 4
    optional ::Protobuf::Field::StringField, :icon_id, 5
    optional ::Protobuf::Field::Int32Field, :billing_instrument_type, 6
    optional ::Protobuf::Field::StringField, :application_id, 7
    optional ::Protobuf::Field::StringField, :tos_url, 8
    optional ::Protobuf::Field::BoolField, :instrument_tos_required, 9
    optional ::Protobuf::Field::Int32Field, :api_version, 10
    optional ::Protobuf::Field::BoolField, :per_transaction_credentials_required, 11
    optional ::Protobuf::Field::BoolField, :send_subscriber_id_with_carrier_billing_requests, 12
    optional ::Protobuf::Field::Int32Field, :device_association_method, 13
    optional ::Protobuf::Field::StringField, :user_token_request_message, 14
    optional ::Protobuf::Field::StringField, :user_token_request_address, 15
    optional ::Protobuf::Field::BoolField, :passphrase_required, 16
  end
  
  class CarrierBillingCredentialsProto
    optional ::Protobuf::Field::StringField, :credentials, 1
    optional ::Protobuf::Field::Int64Field, :credentials_timeout, 2
  end
  
  class CategoryProto
    optional ::Protobuf::Field::Int32Field, :asset_type, 2
    optional ::Protobuf::Field::StringField, :category_id, 3
    optional ::Protobuf::Field::StringField, :category_display, 4
    optional ::Protobuf::Field::StringField, :category_subtitle, 5
    repeated ::Protobuf::Field::StringField, :promoted_assets_new, 6
    repeated ::Protobuf::Field::StringField, :promoted_assets_home, 7
    repeated ::GooglePlay::CategoryProto, :sub_categories, 8
    repeated ::Protobuf::Field::StringField, :promoted_assets_paid, 9
    repeated ::Protobuf::Field::StringField, :promoted_assets_free, 10
  end
  
  class CheckForNotificationsRequestProto
    optional ::Protobuf::Field::Int64Field, :alarm_duration, 1
  end
  
  class CheckLicenseRequestProto
    optional ::Protobuf::Field::StringField, :package_name, 1
    optional ::Protobuf::Field::Int32Field, :version_code, 2
    optional ::Protobuf::Field::Int64Field, :nonce, 3
  end
  
  class CheckLicenseResponseProto
    optional ::Protobuf::Field::Int32Field, :response_code, 1
    optional ::Protobuf::Field::StringField, :signed_data, 2
    optional ::Protobuf::Field::StringField, :signature, 3
  end
  
  class CommentsRequestProto
    optional ::Protobuf::Field::StringField, :asset_id, 1
    optional ::Protobuf::Field::Int64Field, :start_index, 2
    optional ::Protobuf::Field::Int64Field, :num_entries, 3
    optional ::Protobuf::Field::BoolField, :should_return_self_comment, 4
    optional ::Protobuf::Field::StringField, :asset_referrer, 5
  end
  
  class CommentsResponseProto
    repeated ::GooglePlay::ExternalCommentProto, :comment, 1
    optional ::Protobuf::Field::Int64Field, :num_total_entries, 2
    optional ::GooglePlay::ExternalCommentProto, :self_comment, 3
  end
  
  class ContentSyncRequestProto
    class AssetInstallState
      optional ::Protobuf::Field::StringField, :asset_id, 3
      optional ::Protobuf::Field::Int32Field, :asset_state, 4
      optional ::Protobuf::Field::Int64Field, :install_time, 5
      optional ::Protobuf::Field::Int64Field, :uninstall_time, 6
      optional ::Protobuf::Field::StringField, :package_name, 7
      optional ::Protobuf::Field::Int32Field, :version_code, 8
      optional ::Protobuf::Field::StringField, :asset_referrer, 9
    end
    
    class SystemApp
      optional ::Protobuf::Field::StringField, :package_name, 11
      optional ::Protobuf::Field::Int32Field, :version_code, 12
      repeated ::Protobuf::Field::StringField, :certificate_hash, 13
    end
    
    optional ::Protobuf::Field::BoolField, :incremental, 1
    repeated ::GooglePlay::ContentSyncRequestProto::AssetInstallState, :assetinstallstate, 2
    repeated ::GooglePlay::ContentSyncRequestProto::SystemApp, :systemapp, 10
    optional ::Protobuf::Field::Int32Field, :sideloaded_app_count, 14
  end
  
  class ContentSyncResponseProto
    optional ::Protobuf::Field::Int32Field, :num_updates_available, 1
  end
  
  class DataMessageProto
    optional ::Protobuf::Field::StringField, :category, 1
    repeated ::GooglePlay::AppDataProto, :app_data, 3
  end
  
  class DownloadInfoProto
    optional ::Protobuf::Field::Int64Field, :apk_size, 1
    repeated ::GooglePlay::FileMetadataProto, :additional_file, 2
  end
  
  class ExternalAssetProto
    class PurchaseInformation
      optional ::Protobuf::Field::Int64Field, :purchase_time, 10
      optional ::Protobuf::Field::Int64Field, :refund_timeout_time, 11
      optional ::Protobuf::Field::Int32Field, :refund_start_policy, 45
      optional ::Protobuf::Field::Int64Field, :refund_window_duration, 46
    end
    
    class ExtendedInfo
      class PackageDependency
        optional ::Protobuf::Field::StringField, :package_name, 41
        optional ::Protobuf::Field::BoolField, :skip_permissions, 42
      end
      
      optional ::Protobuf::Field::StringField, :description, 13
      optional ::Protobuf::Field::Int64Field, :download_count, 14
      repeated ::Protobuf::Field::StringField, :application_permission_id, 15
      optional ::Protobuf::Field::Int64Field, :required_installation_size, 16
      optional ::Protobuf::Field::StringField, :package_name, 17
      optional ::Protobuf::Field::StringField, :category, 18
      optional ::Protobuf::Field::BoolField, :forward_locked, 19
      optional ::Protobuf::Field::StringField, :contact_email, 20
      optional ::Protobuf::Field::BoolField, :ever_installed_by_user, 21
      optional ::Protobuf::Field::StringField, :download_count_string, 23
      optional ::Protobuf::Field::StringField, :contact_phone, 26
      optional ::Protobuf::Field::StringField, :contact_website, 27
      optional ::Protobuf::Field::BoolField, :next_purchase_refundable, 28
      optional ::Protobuf::Field::Int32Field, :num_screenshots, 30
      optional ::Protobuf::Field::StringField, :promotional_description, 31
      optional ::Protobuf::Field::Int32Field, :server_asset_state, 34
      optional ::Protobuf::Field::Int32Field, :content_rating_level, 36
      optional ::Protobuf::Field::StringField, :content_rating_string, 37
      optional ::Protobuf::Field::StringField, :recent_changes, 38
      repeated ::GooglePlay::ExternalAssetProto::ExtendedInfo::PackageDependency, :packagedependency, 39
      optional ::Protobuf::Field::StringField, :video_link, 43
      optional ::GooglePlay::DownloadInfoProto, :download_info, 49
    end
    
    optional ::Protobuf::Field::StringField, :id, 1
    optional ::Protobuf::Field::StringField, :title, 2
    optional ::Protobuf::Field::Int32Field, :asset_type, 3
    optional ::Protobuf::Field::StringField, :owner, 4
    optional ::Protobuf::Field::StringField, :version, 5
    optional ::Protobuf::Field::StringField, :price, 6
    optional ::Protobuf::Field::StringField, :average_rating, 7
    optional ::Protobuf::Field::Int64Field, :num_ratings, 8
    optional ::GooglePlay::ExternalAssetProto::PurchaseInformation, :purchaseinformation, 9
    optional ::GooglePlay::ExternalAssetProto::ExtendedInfo, :extendedinfo, 12
    optional ::Protobuf::Field::StringField, :owner_id, 22
    optional ::Protobuf::Field::StringField, :package_name, 24
    optional ::Protobuf::Field::Int32Field, :version_code, 25
    optional ::Protobuf::Field::BoolField, :bundled_asset, 29
    optional ::Protobuf::Field::StringField, :price_currency, 32
    optional ::Protobuf::Field::Int64Field, :price_micros, 33
    optional ::Protobuf::Field::StringField, :filter_reason, 35
    optional ::Protobuf::Field::StringField, :actual_seller_price, 40
    repeated ::GooglePlay::ExternalBadgeProto, :app_badge, 47
    repeated ::GooglePlay::ExternalBadgeProto, :owner_badge, 48
  end
  
  class ExternalBadgeImageProto
    optional ::Protobuf::Field::Int32Field, :usage, 1
    optional ::Protobuf::Field::StringField, :url, 2
  end
  
  class ExternalBadgeProto
    optional ::Protobuf::Field::StringField, :localized_title, 1
    optional ::Protobuf::Field::StringField, :localized_description, 2
    repeated ::GooglePlay::ExternalBadgeImageProto, :badge_image, 3
    optional ::Protobuf::Field::StringField, :search_id, 4
  end
  
  class ExternalCarrierBillingInstrumentProto
    optional ::Protobuf::Field::StringField, :instrument_key, 1
    optional ::Protobuf::Field::StringField, :subscriber_identifier, 2
    optional ::Protobuf::Field::StringField, :account_type, 3
    optional ::Protobuf::Field::StringField, :subscriber_currency, 4
    optional ::Protobuf::Field::Uint64Field, :transaction_limit, 5
    optional ::Protobuf::Field::StringField, :subscriber_name, 6
    optional ::Protobuf::Field::StringField, :address_1, 7
    optional ::Protobuf::Field::StringField, :address_2, 8
    optional ::Protobuf::Field::StringField, :city, 9
    optional ::Protobuf::Field::StringField, :state, 10
    optional ::Protobuf::Field::StringField, :postal_code, 11
    optional ::Protobuf::Field::StringField, :country, 12
    optional ::GooglePlay::EncryptedSubscriberInfo, :encrypted_subscriber_info, 13
  end
  
  class ExternalCommentProto
    optional ::Protobuf::Field::StringField, :body, 1
    optional ::Protobuf::Field::Int32Field, :rating, 2
    optional ::Protobuf::Field::StringField, :creator_name, 3
    optional ::Protobuf::Field::Int64Field, :creation_time, 4
    optional ::Protobuf::Field::StringField, :creator_id, 5
  end
  
  class ExternalCreditCard
    optional ::Protobuf::Field::StringField, :type, 1
    optional ::Protobuf::Field::StringField, :last_digits, 2
    optional ::Protobuf::Field::Int32Field, :exp_year, 3
    optional ::Protobuf::Field::Int32Field, :exp_month, 4
    optional ::Protobuf::Field::StringField, :person_name, 5
    optional ::Protobuf::Field::StringField, :country_code, 6
    optional ::Protobuf::Field::StringField, :postal_code, 7
    optional ::Protobuf::Field::BoolField, :make_default, 8
    optional ::Protobuf::Field::StringField, :address_1, 9
    optional ::Protobuf::Field::StringField, :address_2, 10
    optional ::Protobuf::Field::StringField, :city, 11
    optional ::Protobuf::Field::StringField, :state, 12
    optional ::Protobuf::Field::StringField, :phone, 13
  end
  
  class ExternalPaypalInstrumentProto
    optional ::Protobuf::Field::StringField, :instrument_key, 1
    optional ::Protobuf::Field::StringField, :preapproval_key, 2
    optional ::Protobuf::Field::StringField, :paypal_email, 3
    optional ::GooglePlay::AddressProto, :paypal_address, 4
    optional ::Protobuf::Field::BoolField, :multiple_paypal_instruments_supported, 5
  end
  
  class FileMetadataProto
    optional ::Protobuf::Field::Int32Field, :file_type, 1
    optional ::Protobuf::Field::Int32Field, :version_code, 2
    optional ::Protobuf::Field::Int64Field, :size, 3
    optional ::Protobuf::Field::StringField, :download_url, 4
  end
  
  class GetAddressSnippetRequestProto
    optional ::GooglePlay::EncryptedSubscriberInfo, :encrypted_subscriber_info, 1
  end
  
  class GetAddressSnippetResponseProto
    optional ::Protobuf::Field::StringField, :address_snippet, 1
  end
  
  class GetAssetRequestProto
    optional ::Protobuf::Field::StringField, :asset_id, 1
    optional ::Protobuf::Field::StringField, :direct_download_key, 2
  end
  
  class GetAssetResponseProto
    class InstallAsset
      optional ::Protobuf::Field::StringField, :asset_id, 2
      optional ::Protobuf::Field::StringField, :asset_name, 3
      optional ::Protobuf::Field::StringField, :asset_type, 4
      optional ::Protobuf::Field::StringField, :asset_package, 5
      optional ::Protobuf::Field::StringField, :blob_url, 6
      optional ::Protobuf::Field::StringField, :asset_signature, 7
      optional ::Protobuf::Field::Int64Field, :asset_size, 8
      optional ::Protobuf::Field::Int64Field, :refund_timeout_millis, 9
      optional ::Protobuf::Field::BoolField, :forward_locked, 10
      optional ::Protobuf::Field::BoolField, :secured, 11
      optional ::Protobuf::Field::Int32Field, :version_code, 12
      optional ::Protobuf::Field::StringField, :download_auth_cookie_name, 13
      optional ::Protobuf::Field::StringField, :download_auth_cookie_value, 14
      optional ::Protobuf::Field::Int64Field, :post_install_refund_window_millis, 16
    end
    
    optional ::GooglePlay::GetAssetResponseProto::InstallAsset, :installasset, 1
    repeated ::GooglePlay::FileMetadataProto, :additional_file, 15
  end
  
  class GetCarrierInfoResponseProto
    optional ::Protobuf::Field::BoolField, :carrier_channel_enabled, 1
    optional ::Protobuf::Field::BytesField, :carrier_logo_icon, 2
    optional ::Protobuf::Field::BytesField, :carrier_banner, 3
    optional ::Protobuf::Field::StringField, :carrier_subtitle, 4
    optional ::Protobuf::Field::StringField, :carrier_title, 5
    optional ::Protobuf::Field::Int32Field, :carrier_image_density, 6
  end
  
  class GetCategoriesRequestProto
    optional ::Protobuf::Field::BoolField, :prefetch_promo_data, 1
  end
  
  class GetCategoriesResponseProto
    repeated ::GooglePlay::CategoryProto, :categories, 1
  end
  
  class GetImageRequestProto
    optional ::Protobuf::Field::StringField, :asset_id, 1
    optional ::Protobuf::Field::Int32Field, :image_usage, 3
    optional ::Protobuf::Field::StringField, :image_id, 4
    optional ::Protobuf::Field::Int32Field, :screen_property_width, 5
    optional ::Protobuf::Field::Int32Field, :screen_property_height, 6
    optional ::Protobuf::Field::Int32Field, :screen_property_density, 7
    optional ::Protobuf::Field::Int32Field, :product_type, 8
  end
  
  class GetImageResponseProto
    optional ::Protobuf::Field::BytesField, :image_data, 1
    optional ::Protobuf::Field::Int32Field, :image_density, 2
  end
  
  class GetMarketMetadataRequestProto
    optional ::Protobuf::Field::Int64Field, :last_request_time, 1
    optional ::GooglePlay::DeviceConfigurationProto, :device_configuration, 2
    optional ::Protobuf::Field::BoolField, :device_roaming, 3
    repeated ::Protobuf::Field::StringField, :market_signature_hash, 4
    optional ::Protobuf::Field::Int32Field, :content_rating, 5
    optional ::Protobuf::Field::StringField, :device_model_name, 6
    optional ::Protobuf::Field::StringField, :device_manufacturer_name, 7
  end
  
  class GetMarketMetadataResponseProto
    optional ::Protobuf::Field::Int32Field, :latest_client_version_code, 1
    optional ::Protobuf::Field::StringField, :latest_client_url, 2
    optional ::Protobuf::Field::BoolField, :paid_apps_enabled, 3
    repeated ::GooglePlay::BillingParameterProto, :billing_parameter, 4
    optional ::Protobuf::Field::BoolField, :comment_post_enabled, 5
    optional ::Protobuf::Field::BoolField, :billing_events_enabled, 6
    optional ::Protobuf::Field::StringField, :warning_message, 7
    optional ::Protobuf::Field::BoolField, :in_app_billing_enabled, 8
    optional ::Protobuf::Field::Int32Field, :in_app_billing_max_api_version, 9
  end
  
  class GetSubCategoriesRequestProto
    optional ::Protobuf::Field::Int32Field, :asset_type, 1
  end
  
  class GetSubCategoriesResponseProto
    class SubCategory
      optional ::Protobuf::Field::StringField, :sub_category_display, 2
      optional ::Protobuf::Field::StringField, :sub_category_id, 3
    end
    
    repeated ::GooglePlay::GetSubCategoriesResponseProto::SubCategory, :subcategory, 1
  end
  
  class InAppPurchaseInformationRequestProto
    optional ::GooglePlay::SignatureHashProto, :signature_hash, 1
    optional ::Protobuf::Field::Int64Field, :nonce, 2
    repeated ::Protobuf::Field::StringField, :notification_id, 3
    optional ::Protobuf::Field::StringField, :signature_algorithm, 4
    optional ::Protobuf::Field::Int32Field, :billing_api_version, 5
  end
  
  class InAppPurchaseInformationResponseProto
    optional ::GooglePlay::SignedDataProto, :signed_response, 1
    repeated ::GooglePlay::StatusBarNotificationProto, :status_bar_notification, 2
    optional ::GooglePlay::PurchaseResultProto, :purchase_result, 3
  end
  
  class InAppRestoreTransactionsRequestProto
    optional ::GooglePlay::SignatureHashProto, :signature_hash, 1
    optional ::Protobuf::Field::Int64Field, :nonce, 2
    optional ::Protobuf::Field::StringField, :signature_algorithm, 3
    optional ::Protobuf::Field::Int32Field, :billing_api_version, 4
  end
  
  class InAppRestoreTransactionsResponseProto
    optional ::GooglePlay::SignedDataProto, :signed_response, 1
    optional ::GooglePlay::PurchaseResultProto, :purchase_result, 2
  end
  
  class ModifyCommentRequestProto
    optional ::Protobuf::Field::StringField, :asset_id, 1
    optional ::GooglePlay::ExternalCommentProto, :comment, 2
    optional ::Protobuf::Field::BoolField, :delete_comment, 3
    optional ::Protobuf::Field::BoolField, :flag_asset, 4
    optional ::Protobuf::Field::Int32Field, :flag_type, 5
    optional ::Protobuf::Field::StringField, :flag_message, 6
    optional ::Protobuf::Field::BoolField, :non_flag_flow, 7
  end
  
  class PaypalCountryInfoProto
    optional ::Protobuf::Field::BoolField, :birth_date_required, 1
    optional ::Protobuf::Field::StringField, :tos_text, 2
    optional ::Protobuf::Field::StringField, :billing_agreement_text, 3
    optional ::Protobuf::Field::StringField, :pre_tos_text, 4
  end
  
  class PaypalCreateAccountRequestProto
    optional ::Protobuf::Field::StringField, :first_name, 1
    optional ::Protobuf::Field::StringField, :last_name, 2
    optional ::GooglePlay::AddressProto, :address, 3
    optional ::Protobuf::Field::StringField, :birth_date, 4
  end
  
  class PaypalCreateAccountResponseProto
    optional ::Protobuf::Field::StringField, :create_account_key, 1
  end
  
  class PaypalCredentialsProto
    optional ::Protobuf::Field::StringField, :preapproval_key, 1
    optional ::Protobuf::Field::StringField, :paypal_email, 2
  end
  
  class PaypalMassageAddressRequestProto
    optional ::GooglePlay::AddressProto, :address, 1
  end
  
  class PaypalMassageAddressResponseProto
    optional ::GooglePlay::AddressProto, :address, 1
  end
  
  class PaypalPreapprovalCredentialsRequestProto
    optional ::Protobuf::Field::StringField, :gaia_auth_token, 1
    optional ::Protobuf::Field::StringField, :billing_instrument_id, 2
  end
  
  class PaypalPreapprovalCredentialsResponseProto
    optional ::Protobuf::Field::Int32Field, :result_code, 1
    optional ::Protobuf::Field::StringField, :paypal_account_key, 2
    optional ::Protobuf::Field::StringField, :paypal_email, 3
  end
  
  class PaypalPreapprovalDetailsRequestProto
    optional ::Protobuf::Field::BoolField, :get_address, 1
    optional ::Protobuf::Field::StringField, :preapproval_key, 2
  end
  
  class PaypalPreapprovalDetailsResponseProto
    optional ::Protobuf::Field::StringField, :paypal_email, 1
    optional ::GooglePlay::AddressProto, :address, 2
  end
  
  class PaypalPreapprovalResponseProto
    optional ::Protobuf::Field::StringField, :preapproval_key, 1
  end
  
  class PendingNotificationsProto
    repeated ::GooglePlay::DataMessageProto, :notification, 1
    optional ::Protobuf::Field::Int64Field, :next_check_millis, 2
  end
  
  class PrefetchedBundleProto
    optional ::GooglePlay::SingleRequestProto, :request, 1
    optional ::GooglePlay::SingleResponseProto, :response, 2
  end
  
  class PurchaseCartInfoProto
    optional ::Protobuf::Field::StringField, :item_price, 1
    optional ::Protobuf::Field::StringField, :tax_inclusive, 2
    optional ::Protobuf::Field::StringField, :tax_exclusive, 3
    optional ::Protobuf::Field::StringField, :total, 4
    optional ::Protobuf::Field::StringField, :tax_message, 5
    optional ::Protobuf::Field::StringField, :footer_message, 6
    optional ::Protobuf::Field::StringField, :price_currency, 7
    optional ::Protobuf::Field::Int64Field, :price_micros, 8
  end
  
  class PurchaseInfoProto
    class BillingInstruments
      class BillingInstrument
        optional ::Protobuf::Field::StringField, :id, 5
        optional ::Protobuf::Field::StringField, :name, 6
        optional ::Protobuf::Field::BoolField, :is_invalid, 7
        optional ::Protobuf::Field::Int32Field, :instrument_type, 11
        optional ::Protobuf::Field::Int32Field, :instrument_status, 14
      end
      
      repeated ::GooglePlay::PurchaseInfoProto::BillingInstruments::BillingInstrument, :billinginstrument, 4
      optional ::Protobuf::Field::StringField, :default_billing_instrument_id, 8
    end
    
    optional ::Protobuf::Field::StringField, :transaction_id, 1
    optional ::GooglePlay::PurchaseCartInfoProto, :cart_info, 2
    optional ::GooglePlay::PurchaseInfoProto::BillingInstruments, :billinginstruments, 3
    repeated ::Protobuf::Field::Int32Field, :error_input_fields, 9
    optional ::Protobuf::Field::StringField, :refund_policy, 10
    optional ::Protobuf::Field::BoolField, :user_can_add_gdd, 12
    repeated ::Protobuf::Field::Int32Field, :eligible_instrument_types, 13
    optional ::Protobuf::Field::StringField, :order_id, 15
  end
  
  class PurchaseMetadataRequestProto
    optional ::Protobuf::Field::BoolField, :deprecated_retrieve_billing_countries, 1
    optional ::Protobuf::Field::Int32Field, :billing_instrument_type, 2
  end
  
  class PurchaseMetadataResponseProto
    class Countries
      class Country
        class InstrumentAddressSpec
          optional ::Protobuf::Field::Int32Field, :instrument_family, 8
          optional ::GooglePlay::BillingAddressSpec, :billing_address_spec, 9
        end
        
        optional ::Protobuf::Field::StringField, :country_code, 3
        optional ::Protobuf::Field::StringField, :country_name, 4
        optional ::GooglePlay::PaypalCountryInfoProto, :paypal_country_info, 5
        optional ::Protobuf::Field::BoolField, :allows_reduced_billing_address, 6
        repeated ::GooglePlay::PurchaseMetadataResponseProto::Countries::Country::InstrumentAddressSpec, :instrumentaddressspec, 7
      end
      
      repeated ::GooglePlay::PurchaseMetadataResponseProto::Countries::Country, :country, 2
    end
    
    optional ::GooglePlay::PurchaseMetadataResponseProto::Countries, :countries, 1
  end
  
  class PurchaseOrderRequestProto
    optional ::Protobuf::Field::StringField, :gaia_auth_token, 1
    optional ::Protobuf::Field::StringField, :asset_id, 2
    optional ::Protobuf::Field::StringField, :transaction_id, 3
    optional ::Protobuf::Field::StringField, :billing_instrument_id, 4
    optional ::Protobuf::Field::BoolField, :tos_accepted, 5
    optional ::GooglePlay::CarrierBillingCredentialsProto, :carrier_billing_credentials, 6
    optional ::Protobuf::Field::StringField, :existing_order_id, 7
    optional ::Protobuf::Field::Int32Field, :billing_instrument_type, 8
    optional ::Protobuf::Field::StringField, :billing_parameters_id, 9
    optional ::GooglePlay::PaypalCredentialsProto, :paypal_credentials, 10
    optional ::GooglePlay::RiskHeaderInfoProto, :risk_header_info, 11
    optional ::Protobuf::Field::Int32Field, :product_type, 12
    optional ::GooglePlay::SignatureHashProto, :signature_hash, 13
    optional ::Protobuf::Field::StringField, :developer_payload, 14
  end
  
  class PurchaseOrderResponseProto
    optional ::Protobuf::Field::Int32Field, :deprecated_result_code, 1
    optional ::GooglePlay::PurchaseInfoProto, :purchase_info, 2
    optional ::GooglePlay::ExternalAssetProto, :asset, 3
    optional ::GooglePlay::PurchaseResultProto, :purchase_result, 4
  end
  
  class PurchasePostRequestProto
    class BillingInstrumentInfo
      optional ::Protobuf::Field::StringField, :billing_instrument_id, 5
      optional ::GooglePlay::ExternalCreditCard, :credit_card, 6
      optional ::GooglePlay::ExternalCarrierBillingInstrumentProto, :carrier_instrument, 9
      optional ::GooglePlay::ExternalPaypalInstrumentProto, :paypal_instrument, 10
    end
    
    optional ::Protobuf::Field::StringField, :gaia_auth_token, 1
    optional ::Protobuf::Field::StringField, :asset_id, 2
    optional ::Protobuf::Field::StringField, :transaction_id, 3
    optional ::GooglePlay::PurchasePostRequestProto::BillingInstrumentInfo, :billinginstrumentinfo, 4
    optional ::Protobuf::Field::BoolField, :tos_accepted, 7
    optional ::Protobuf::Field::StringField, :cb_instrument_key, 8
    optional ::Protobuf::Field::BoolField, :paypal_auth_confirmed, 11
    optional ::Protobuf::Field::Int32Field, :product_type, 12
    optional ::GooglePlay::SignatureHashProto, :signature_hash, 13
  end
  
  class PurchasePostResponseProto
    optional ::Protobuf::Field::Int32Field, :deprecated_result_code, 1
    optional ::GooglePlay::PurchaseInfoProto, :purchase_info, 2
    optional ::Protobuf::Field::StringField, :terms_of_service_url, 3
    optional ::Protobuf::Field::StringField, :terms_of_service_text, 4
    optional ::Protobuf::Field::StringField, :terms_of_service_name, 5
    optional ::Protobuf::Field::StringField, :terms_of_service_checkbox_text, 6
    optional ::Protobuf::Field::StringField, :terms_of_service_header_text, 7
    optional ::GooglePlay::PurchaseResultProto, :purchase_result, 8
  end
  
  class PurchaseProductRequestProto
    optional ::Protobuf::Field::Int32Field, :product_type, 1
    optional ::Protobuf::Field::StringField, :product_id, 2
    optional ::GooglePlay::SignatureHashProto, :signature_hash, 3
  end
  
  class PurchaseProductResponseProto
    optional ::Protobuf::Field::StringField, :title, 1
    optional ::Protobuf::Field::StringField, :item_title, 2
    optional ::Protobuf::Field::StringField, :item_description, 3
    optional ::Protobuf::Field::StringField, :merchant_field, 4
  end
  
  class PurchaseResultProto
    optional ::Protobuf::Field::Int32Field, :result_code, 1
    optional ::Protobuf::Field::StringField, :result_code_message, 2
  end
  
  class QuerySuggestionProto
    optional ::Protobuf::Field::StringField, :query, 1
    optional ::Protobuf::Field::Int32Field, :estimated_num_results, 2
    optional ::Protobuf::Field::Int32Field, :query_weight, 3
  end
  
  class QuerySuggestionRequestProto
    optional ::Protobuf::Field::StringField, :query, 1
    optional ::Protobuf::Field::Int32Field, :request_type, 2
  end
  
  class QuerySuggestionResponseProto
    class Suggestion
      optional ::GooglePlay::AppSuggestionProto, :app_suggestion, 2
      optional ::GooglePlay::QuerySuggestionProto, :query_suggestion, 3
    end
    
    repeated ::GooglePlay::QuerySuggestionResponseProto::Suggestion, :suggestion, 1
    optional ::Protobuf::Field::Int32Field, :estimated_num_app_suggestions, 4
    optional ::Protobuf::Field::Int32Field, :estimated_num_query_suggestions, 5
  end
  
  class RateCommentRequestProto
    optional ::Protobuf::Field::StringField, :asset_id, 1
    optional ::Protobuf::Field::StringField, :creator_id, 2
    optional ::Protobuf::Field::Int32Field, :comment_rating, 3
  end
  
  class ReconstructDatabaseRequestProto
    optional ::Protobuf::Field::BoolField, :retrieve_full_history, 1
  end
  
  class ReconstructDatabaseResponseProto
    repeated ::GooglePlay::AssetIdentifierProto, :asset, 1
  end
  
  class RefundRequestProto
    optional ::Protobuf::Field::StringField, :asset_id, 1
  end
  
  class RefundResponseProto
    optional ::Protobuf::Field::Int32Field, :result, 1
    optional ::GooglePlay::ExternalAssetProto, :asset, 2
    optional ::Protobuf::Field::StringField, :result_detail, 3
  end
  
  class RemoveAssetRequestProto
    optional ::Protobuf::Field::StringField, :asset_id, 1
  end
  
  class RequestPropertiesProto
    optional ::Protobuf::Field::StringField, :user_auth_token, 1
    optional ::Protobuf::Field::BoolField, :user_auth_token_secure, 2
    optional ::Protobuf::Field::Int32Field, :software_version, 3
    optional ::Protobuf::Field::StringField, :aid, 4
    optional ::Protobuf::Field::StringField, :product_name_and_version, 5
    optional ::Protobuf::Field::StringField, :user_language, 6
    optional ::Protobuf::Field::StringField, :user_country, 7
    optional ::Protobuf::Field::StringField, :operator_name, 8
    optional ::Protobuf::Field::StringField, :sim_operator_name, 9
    optional ::Protobuf::Field::StringField, :operator_numeric_name, 10
    optional ::Protobuf::Field::StringField, :sim_operator_numeric_name, 11
    optional ::Protobuf::Field::StringField, :client_id, 12
    optional ::Protobuf::Field::StringField, :logging_id, 13
  end
  
  class RequestProto
    class Request
      optional ::GooglePlay::RequestSpecificPropertiesProto, :request_specific_properties, 3
      optional ::GooglePlay::AssetsRequestProto, :asset_request, 4
      optional ::GooglePlay::CommentsRequestProto, :comments_request, 5
      optional ::GooglePlay::ModifyCommentRequestProto, :modify_comment_request, 6
      optional ::GooglePlay::PurchasePostRequestProto, :purchase_post_request, 7
      optional ::GooglePlay::PurchaseOrderRequestProto, :purchase_order_request, 8
      optional ::GooglePlay::ContentSyncRequestProto, :content_sync_request, 9
      optional ::GooglePlay::GetAssetRequestProto, :get_asset_request, 10
      optional ::GooglePlay::GetImageRequestProto, :get_image_request, 11
      optional ::GooglePlay::RefundRequestProto, :refund_request, 12
      optional ::GooglePlay::PurchaseMetadataRequestProto, :purchase_metadata_request, 13
      optional ::GooglePlay::GetSubCategoriesRequestProto, :sub_categories_request, 14
      optional ::GooglePlay::UninstallReasonRequestProto, :uninstall_reason_request, 16
      optional ::GooglePlay::RateCommentRequestProto, :rate_comment_request, 17
      optional ::GooglePlay::CheckLicenseRequestProto, :check_license_request, 18
      optional ::GooglePlay::GetMarketMetadataRequestProto, :get_market_metadata_request, 19
      optional ::GooglePlay::GetCategoriesRequestProto, :get_categories_request, 21
      optional ::GooglePlay::GetCarrierInfoRequestProto, :get_carrier_info_request, 22
      optional ::GooglePlay::RemoveAssetRequestProto, :remove_asset_request, 23
      optional ::GooglePlay::RestoreApplicationsRequestProto, :restore_applications_request, 24
      optional ::GooglePlay::QuerySuggestionRequestProto, :query_suggestion_request, 25
      optional ::GooglePlay::BillingEventRequestProto, :billing_event_request, 26
      optional ::GooglePlay::PaypalPreapprovalRequestProto, :paypal_preapproval_request, 27
      optional ::GooglePlay::PaypalPreapprovalDetailsRequestProto, :paypal_preapproval_details_request, 28
      optional ::GooglePlay::PaypalCreateAccountRequestProto, :paypal_create_account_request, 29
      optional ::GooglePlay::PaypalPreapprovalCredentialsRequestProto, :paypal_preapproval_credentials_request, 30
      optional ::GooglePlay::InAppRestoreTransactionsRequestProto, :in_app_restore_transactions_request, 31
      optional ::GooglePlay::InAppPurchaseInformationRequestProto, :in_app_purchase_information_request, 32
      optional ::GooglePlay::CheckForNotificationsRequestProto, :check_for_notifications_request, 33
      optional ::GooglePlay::AckNotificationsRequestProto, :ack_notifications_request, 34
      optional ::GooglePlay::PurchaseProductRequestProto, :purchase_product_request, 35
      optional ::GooglePlay::ReconstructDatabaseRequestProto, :reconstruct_database_request, 36
      optional ::GooglePlay::PaypalMassageAddressRequestProto, :paypal_massage_address_request, 37
      optional ::GooglePlay::GetAddressSnippetRequestProto, :get_address_snippet_request, 38
    end
    
    optional ::GooglePlay::RequestPropertiesProto, :request_properties, 1
    repeated ::GooglePlay::RequestProto::Request, :request, 2
  end
  
  class RequestSpecificPropertiesProto
    optional ::Protobuf::Field::StringField, :if_none_match, 1
  end
  
  class ResponsePropertiesProto
    optional ::Protobuf::Field::Int32Field, :result, 1
    optional ::Protobuf::Field::Int32Field, :max_age, 2
    optional ::Protobuf::Field::StringField, :etag, 3
    optional ::Protobuf::Field::Int32Field, :server_version, 4
    optional ::Protobuf::Field::Int32Field, :max_age_consumable, 6
    optional ::Protobuf::Field::StringField, :error_message, 7
    repeated ::GooglePlay::InputValidationError, :error_input_field, 8
  end
  
  class ResponseProto
    class Response
      optional ::GooglePlay::ResponsePropertiesProto, :response_properties, 2
      optional ::GooglePlay::AssetsResponseProto, :assets_response, 3
      optional ::GooglePlay::CommentsResponseProto, :comments_response, 4
      optional ::GooglePlay::ModifyCommentResponseProto, :modify_comment_response, 5
      optional ::GooglePlay::PurchasePostResponseProto, :purchase_post_response, 6
      optional ::GooglePlay::PurchaseOrderResponseProto, :purchase_order_response, 7
      optional ::GooglePlay::ContentSyncResponseProto, :content_sync_response, 8
      optional ::GooglePlay::GetAssetResponseProto, :get_asset_response, 9
      optional ::GooglePlay::GetImageResponseProto, :get_image_response, 10
      optional ::GooglePlay::RefundResponseProto, :refund_response, 11
      optional ::GooglePlay::PurchaseMetadataResponseProto, :purchase_metadata_response, 12
      optional ::GooglePlay::GetSubCategoriesResponseProto, :sub_categories_response, 13
      optional ::GooglePlay::UninstallReasonResponseProto, :uninstall_reason_response, 15
      optional ::GooglePlay::RateCommentResponseProto, :rate_comment_response, 16
      optional ::GooglePlay::CheckLicenseResponseProto, :check_license_response, 17
      optional ::GooglePlay::GetMarketMetadataResponseProto, :get_market_metadata_response, 18
      repeated ::GooglePlay::PrefetchedBundleProto, :prefetched_bundle, 19
      optional ::GooglePlay::GetCategoriesResponseProto, :get_categories_response, 20
      optional ::GooglePlay::GetCarrierInfoResponseProto, :get_carrier_info_response, 21
      optional ::GooglePlay::RestoreApplicationsResponseProto, :restore_application_response, 23
      optional ::GooglePlay::QuerySuggestionResponseProto, :query_suggestion_response, 24
      optional ::GooglePlay::BillingEventResponseProto, :billing_event_response, 25
      optional ::GooglePlay::PaypalPreapprovalResponseProto, :paypal_preapproval_response, 26
      optional ::GooglePlay::PaypalPreapprovalDetailsResponseProto, :paypal_preapproval_details_response, 27
      optional ::GooglePlay::PaypalCreateAccountResponseProto, :paypal_create_account_response, 28
      optional ::GooglePlay::PaypalPreapprovalCredentialsResponseProto, :paypal_preapproval_credentials_response, 29
      optional ::GooglePlay::InAppRestoreTransactionsResponseProto, :in_app_restore_transactions_response, 30
      optional ::GooglePlay::InAppPurchaseInformationResponseProto, :in_app_purchase_information_response, 31
      optional ::GooglePlay::CheckForNotificationsResponseProto, :check_for_notifications_response, 32
      optional ::GooglePlay::AckNotificationsResponseProto, :ack_notifications_response, 33
      optional ::GooglePlay::PurchaseProductResponseProto, :purchase_product_response, 34
      optional ::GooglePlay::ReconstructDatabaseResponseProto, :reconstruct_database_response, 35
      optional ::GooglePlay::PaypalMassageAddressResponseProto, :paypal_massage_address_response, 36
      optional ::GooglePlay::GetAddressSnippetResponseProto, :get_address_snippet_response, 37
    end
    
    repeated ::GooglePlay::ResponseProto::Response, :response, 1
    optional ::GooglePlay::PendingNotificationsProto, :pending_notifications, 38
  end
  
  class RestoreApplicationsRequestProto
    optional ::Protobuf::Field::StringField, :backup_android_id, 1
    optional ::Protobuf::Field::StringField, :tos_version, 2
    optional ::GooglePlay::DeviceConfigurationProto, :device_configuration, 3
  end
  
  class RestoreApplicationsResponseProto
    repeated ::GooglePlay::GetAssetResponseProto, :asset, 1
  end
  
  class RiskHeaderInfoProto
    optional ::Protobuf::Field::StringField, :hashed_device_info, 1
  end
  
  class SignatureHashProto
    optional ::Protobuf::Field::StringField, :package_name, 1
    optional ::Protobuf::Field::Int32Field, :version_code, 2
    optional ::Protobuf::Field::BytesField, :hash, 3
  end
  
  class SignedDataProto
    optional ::Protobuf::Field::StringField, :signed_data, 1
    optional ::Protobuf::Field::StringField, :signature, 2
  end
  
  class SingleRequestProto
    optional ::GooglePlay::RequestSpecificPropertiesProto, :request_specific_properties, 3
    optional ::GooglePlay::AssetsRequestProto, :asset_request, 4
    optional ::GooglePlay::CommentsRequestProto, :comments_request, 5
    optional ::GooglePlay::ModifyCommentRequestProto, :modify_comment_request, 6
    optional ::GooglePlay::PurchasePostRequestProto, :purchase_post_request, 7
    optional ::GooglePlay::PurchaseOrderRequestProto, :purchase_order_request, 8
    optional ::GooglePlay::ContentSyncRequestProto, :content_sync_request, 9
    optional ::GooglePlay::GetAssetRequestProto, :get_asset_request, 10
    optional ::GooglePlay::GetImageRequestProto, :get_image_request, 11
    optional ::GooglePlay::RefundRequestProto, :refund_request, 12
    optional ::GooglePlay::PurchaseMetadataRequestProto, :purchase_metadata_request, 13
    optional ::GooglePlay::GetSubCategoriesRequestProto, :sub_categories_request, 14
    optional ::GooglePlay::UninstallReasonRequestProto, :uninstall_reason_request, 16
    optional ::GooglePlay::RateCommentRequestProto, :rate_comment_request, 17
    optional ::GooglePlay::CheckLicenseRequestProto, :check_license_request, 18
    optional ::GooglePlay::GetMarketMetadataRequestProto, :get_market_metadata_request, 19
    optional ::GooglePlay::GetCategoriesRequestProto, :get_categories_request, 21
    optional ::GooglePlay::GetCarrierInfoRequestProto, :get_carrier_info_request, 22
    optional ::GooglePlay::RemoveAssetRequestProto, :remove_asset_request, 23
    optional ::GooglePlay::RestoreApplicationsRequestProto, :restore_applications_request, 24
    optional ::GooglePlay::QuerySuggestionRequestProto, :query_suggestion_request, 25
    optional ::GooglePlay::BillingEventRequestProto, :billing_event_request, 26
    optional ::GooglePlay::PaypalPreapprovalRequestProto, :paypal_preapproval_request, 27
    optional ::GooglePlay::PaypalPreapprovalDetailsRequestProto, :paypal_preapproval_details_request, 28
    optional ::GooglePlay::PaypalCreateAccountRequestProto, :paypal_create_account_request, 29
    optional ::GooglePlay::PaypalPreapprovalCredentialsRequestProto, :paypal_preapproval_credentials_request, 30
    optional ::GooglePlay::InAppRestoreTransactionsRequestProto, :in_app_restore_transactions_request, 31
    optional ::GooglePlay::InAppPurchaseInformationRequestProto, :get_in_app_purchase_information_request, 32
    optional ::GooglePlay::CheckForNotificationsRequestProto, :check_for_notifications_request, 33
    optional ::GooglePlay::AckNotificationsRequestProto, :ack_notifications_request, 34
    optional ::GooglePlay::PurchaseProductRequestProto, :purchase_product_request, 35
    optional ::GooglePlay::ReconstructDatabaseRequestProto, :reconstruct_database_request, 36
    optional ::GooglePlay::PaypalMassageAddressRequestProto, :paypal_massage_address_request, 37
    optional ::GooglePlay::GetAddressSnippetRequestProto, :get_address_snippet_request, 38
  end
  
  class SingleResponseProto
    optional ::GooglePlay::ResponsePropertiesProto, :response_properties, 2
    optional ::GooglePlay::AssetsResponseProto, :assets_response, 3
    optional ::GooglePlay::CommentsResponseProto, :comments_response, 4
    optional ::GooglePlay::ModifyCommentResponseProto, :modify_comment_response, 5
    optional ::GooglePlay::PurchasePostResponseProto, :purchase_post_response, 6
    optional ::GooglePlay::PurchaseOrderResponseProto, :purchase_order_response, 7
    optional ::GooglePlay::ContentSyncResponseProto, :content_sync_response, 8
    optional ::GooglePlay::GetAssetResponseProto, :get_asset_response, 9
    optional ::GooglePlay::GetImageResponseProto, :get_image_response, 10
    optional ::GooglePlay::RefundResponseProto, :refund_response, 11
    optional ::GooglePlay::PurchaseMetadataResponseProto, :purchase_metadata_response, 12
    optional ::GooglePlay::GetSubCategoriesResponseProto, :sub_categories_response, 13
    optional ::GooglePlay::UninstallReasonResponseProto, :uninstall_reason_response, 15
    optional ::GooglePlay::RateCommentResponseProto, :rate_comment_response, 16
    optional ::GooglePlay::CheckLicenseResponseProto, :check_license_response, 17
    optional ::GooglePlay::GetMarketMetadataResponseProto, :get_market_metadata_response, 18
    optional ::GooglePlay::GetCategoriesResponseProto, :get_categories_response, 20
    optional ::GooglePlay::GetCarrierInfoResponseProto, :get_carrier_info_response, 21
    optional ::GooglePlay::RestoreApplicationsResponseProto, :restore_application_response, 23
    optional ::GooglePlay::QuerySuggestionResponseProto, :query_suggestion_response, 24
    optional ::GooglePlay::BillingEventResponseProto, :billing_event_response, 25
    optional ::GooglePlay::PaypalPreapprovalResponseProto, :paypal_preapproval_response, 26
    optional ::GooglePlay::PaypalPreapprovalDetailsResponseProto, :paypal_preapproval_details_response, 27
    optional ::GooglePlay::PaypalCreateAccountResponseProto, :paypal_create_account_response, 28
    optional ::GooglePlay::PaypalPreapprovalCredentialsResponseProto, :paypal_preapproval_credentials_response, 29
    optional ::GooglePlay::InAppRestoreTransactionsResponseProto, :in_app_restore_transactions_response, 30
    optional ::GooglePlay::InAppPurchaseInformationResponseProto, :get_in_app_purchase_information_response, 31
    optional ::GooglePlay::CheckForNotificationsResponseProto, :check_for_notifications_response, 32
    optional ::GooglePlay::AckNotificationsResponseProto, :ack_notifications_response, 33
    optional ::GooglePlay::PurchaseProductResponseProto, :purchase_product_response, 34
    optional ::GooglePlay::ReconstructDatabaseResponseProto, :reconstruct_database_response, 35
    optional ::GooglePlay::PaypalMassageAddressResponseProto, :paypal_massage_address_response, 36
    optional ::GooglePlay::GetAddressSnippetResponseProto, :get_address_snippet_response, 37
  end
  
  class StatusBarNotificationProto
    optional ::Protobuf::Field::StringField, :ticker_text, 1
    optional ::Protobuf::Field::StringField, :content_title, 2
    optional ::Protobuf::Field::StringField, :content_text, 3
  end
  
  class UninstallReasonRequestProto
    optional ::Protobuf::Field::StringField, :asset_id, 1
    optional ::Protobuf::Field::Int32Field, :reason, 2
  end
  
end
