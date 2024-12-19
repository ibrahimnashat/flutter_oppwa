//
//  FlutterEnums.swift
//  flutter_oppwa
//
//  Created by Osama Gharib on 19/02/2023.
//

import Foundation

enum FlutterProviderDomain: String, CaseIterable {
    case defaultDomain, euDomain
    var value: OPPProviderDomain {
        switch self {
        case .defaultDomain : return OPPProviderDomain.default
        case .euDomain :  return OPPProviderDomain.EU
        }
    }
    static func toFlutter(_ value: OPPProviderDomain) -> FlutterProviderDomain? {
        for e in FlutterProviderDomain.allCases {
            if e.value == value {
                return e
            }
        }
        return nil
    }
}
enum FlutterProviderMode: String, CaseIterable {
    case test, live
    var value: OPPProviderMode {
        switch self {
        case .test : return OPPProviderMode.test
        case .live :  return OPPProviderMode.live
        }
    }
    static func toFlutter(_ value: OPPProviderMode) -> FlutterProviderMode? {
        for e in FlutterProviderMode.allCases {
            if e.value == value {
                return e
            }
        }
        return nil
    }
}
enum FlutterCheckoutThreeDS2Flow: String, CaseIterable {
    case app, web, disabled
    var value: OPPThreeDS2Flow {
        switch self {
        case .app : return OPPThreeDS2Flow.app
        case .web :  return OPPThreeDS2Flow.web
        case .disabled :  return OPPThreeDS2Flow.disabled
        }
    }
    static func toFlutter(_ value: OPPThreeDS2Flow?) -> FlutterCheckoutThreeDS2Flow? {
        if value == nil {return nil}
        for e in FlutterCheckoutThreeDS2Flow.allCases {
            if e.value == value { return e }
        }
        return nil
    }
}

enum FlutterTransactionType: String, CaseIterable {
    case sync, async, undefined
    var value: OPPTransactionType {
        switch self {
        case .sync : return OPPTransactionType.synchronous
        case .async :  return OPPTransactionType.asynchronous
        case .undefined :  return OPPTransactionType.undefined
        }
    }
    static func toFlutter(_ value: OPPTransactionType) -> FlutterTransactionType? {
        for e in FlutterTransactionType.allCases {
            if e.value == value {
                return e
            }
        }
        return nil
    }
}

enum FlutterYooKassaStatus: String, CaseIterable {
    case succeeded, pending, waitingForCapture, canceled, undefined
    var value: OPPYooKassaStatus {
        switch self {
        case .succeeded : return OPPYooKassaStatus.succeeded
        case .pending : return OPPYooKassaStatus.pending
        case .waitingForCapture : return OPPYooKassaStatus.waitingForCapture
        case .canceled : return OPPYooKassaStatus.canceled
        case .undefined : return OPPYooKassaStatus.undefined
        }
    }
    static func toFlutter(_ value: OPPYooKassaStatus) -> FlutterYooKassaStatus? {
        for e in FlutterYooKassaStatus.allCases {
            if e.value == value {
                return e
            }
        }
        return nil
    }
}

enum FlutterSTCPayVerificationOption: String, CaseIterable {
    case mobilePhone, qrCode
    var value: OPPSTCPayVerificationOption {
        switch self {
        case .mobilePhone : return OPPSTCPayVerificationOption.phone
        case .qrCode :  return OPPSTCPayVerificationOption.qrCode
        }
    }
    static func toFlutter(_ value: OPPSTCPayVerificationOption) -> FlutterSTCPayVerificationOption? {
        for e in FlutterSTCPayVerificationOption.allCases {
            if e.value == value {
                return e
            }
        }
        return nil
    }
}

enum FlutterThreeDS2Status: String, CaseIterable {
    case authenticated, attemptProcessingPerformed, challengeRequired, decoupledConfirmed, denied, rejected, failed, informationalOnly, authParamsRequired, undefined
    
    var value: OPPThreeDS2Status {
        switch self {
        case .authenticated : return OPPThreeDS2Status.authenticated
        case .attemptProcessingPerformed : return OPPThreeDS2Status.attemptProcessingPerformed
        case .challengeRequired : return OPPThreeDS2Status.challengeRequired
        case .decoupledConfirmed : return OPPThreeDS2Status.decoupledConfirmed
        case .denied : return OPPThreeDS2Status.denied
        case .rejected : return OPPThreeDS2Status.rejected
        case .failed : return OPPThreeDS2Status.failed
        case .informationalOnly : return OPPThreeDS2Status.informationalOnly
        case .authParamsRequired : return OPPThreeDS2Status.authParamsRequired
        case .undefined : return OPPThreeDS2Status.undefined
        }
    }
    static func toFlutter(_ value: OPPThreeDS2Status) -> FlutterThreeDS2Status? {
        for e in FlutterThreeDS2Status.allCases {
            if e.value == value {
                return e
            }
        }
        return nil
    }
}

enum FlutterErrorCode: String, CaseIterable {
    case paymentParamsUnsupported,
         paymentParamsCheckoutIdInvalid,
         paymentParamsBrandInvalid,
         paymentParamsTokenIdInvalid,
         paymentParamsTokenizationUnsupported,
         cardHolderInvalid,
         cardNumberInvalid,
         cardBrandInvalid,
         cardMonthInvalidFormat,
         cardYearInvalidFormat,
         cardExpired,
         cardCvvInvalid,
         bankAccountHolderInvalid,
         bankAccountIbanInvalid,
         bankAccountCountryInvalid,
         bankAccountBankNameInvalid,
         bankAccountBicInvalid,
         bankAccountBankCodeInvalid,
         bankAccountNumberInvalid,
         applePayTokenDataInvalid,
         phoneNumberInvalid,
         countryCodeInvalid,
         emailInvalid,
         nationalIdentifierInvalid,
         accountVerificationInvalid,
         paymentTokenInvalid,
         checkoutInfoCannotBeLoaded,
         noAvailablePaymentMethods,
         paymentMethodNotAvailable,
         transactionAborted,
         brandValidationCannotBeLoaded,
         transactionProcessingFailure,
         invalidCheckoutConfiguration,
         connectionFailure,
         requestParametersInvalid,
         serverResponseInvalid,
         securityXmlManipulation,
         klarnaInline,
         bancontactLink,
         vippsLink,
         threeDs2Failure,
         threeDs2ChallengeCanceled,
         cardScanningGeneralError
    
    var value: OPPErrorCode {
        switch self {
        case .paymentParamsUnsupported : return OPPErrorCode.paymentParamsUnsupported
        case .paymentParamsCheckoutIdInvalid : return OPPErrorCode.paymentParamsCheckoutIDInvalid
        case .paymentParamsBrandInvalid : return OPPErrorCode.paymentParamsBrandInvalid
        case .paymentParamsTokenIdInvalid : return OPPErrorCode.paymentParamsTokenIDInvalid
        case .paymentParamsTokenizationUnsupported : return OPPErrorCode.paymentParamsTokenizationUnsupported
        case .cardHolderInvalid : return OPPErrorCode.cardHolderInvalid
        case .cardNumberInvalid : return OPPErrorCode.cardNumberInvalid
        case .cardBrandInvalid : return OPPErrorCode.cardBrandInvalid
        case .cardMonthInvalidFormat : return OPPErrorCode.cardMonthInvalidFormat
        case .cardYearInvalidFormat : return OPPErrorCode.cardYearInvalidFormat
        case .cardExpired : return OPPErrorCode.cardExpired
        case .cardCvvInvalid : return OPPErrorCode.cardCVVInvalid
        case .bankAccountHolderInvalid : return OPPErrorCode.bankAccountHolderInvalid
        case .bankAccountIbanInvalid : return OPPErrorCode.bankAccountIBANInvalid
        case .bankAccountCountryInvalid : return OPPErrorCode.bankAccountCountryInvalid
        case .bankAccountBankNameInvalid : return OPPErrorCode.bankAccountBankNameInvalid
        case .bankAccountBicInvalid : return OPPErrorCode.bankAccountBICInvalid
        case .bankAccountBankCodeInvalid : return OPPErrorCode.bankAccountBankCodeInvalid
        case .bankAccountNumberInvalid : return OPPErrorCode.bankAccountNumberInvalid
        case .applePayTokenDataInvalid : return OPPErrorCode.applePayTokenDataInvalid
        case .phoneNumberInvalid : return OPPErrorCode.phoneNumberInvalid
        case .countryCodeInvalid : return OPPErrorCode.countryCodeInvalid
        case .emailInvalid : return OPPErrorCode.emailInvalid
        case .nationalIdentifierInvalid : return OPPErrorCode.nationalIdentifierInvalid
        case .accountVerificationInvalid : return OPPErrorCode.accountVerificationInvalid
        case .paymentTokenInvalid : return OPPErrorCode.paymentTokenInvalid
        case .checkoutInfoCannotBeLoaded : return OPPErrorCode.checkoutInfoCannotBeLoaded
        case .noAvailablePaymentMethods : return OPPErrorCode.noAvailablePaymentMethods
        case .paymentMethodNotAvailable : return OPPErrorCode.paymentMethodNotAvailable
        case .transactionAborted : return OPPErrorCode.transactionAborted
        case .brandValidationCannotBeLoaded : return OPPErrorCode.brandValidationCannotBeLoaded
        case .transactionProcessingFailure : return OPPErrorCode.transactionProcessingFailure
        case .invalidCheckoutConfiguration : return OPPErrorCode.invalidCheckoutConfiguration
        case .connectionFailure : return OPPErrorCode.connectionFailure
        case .requestParametersInvalid : return OPPErrorCode.requestParametersInvalid
        case .serverResponseInvalid : return OPPErrorCode.serverResponseInvalid
        case .securityXmlManipulation : return OPPErrorCode.securityXMLManipulation
        case .klarnaInline : return OPPErrorCode.klarnaInline
        case .bancontactLink : return OPPErrorCode.bancontactLink
        case .vippsLink : return OPPErrorCode.vippsLink
        case .threeDs2Failure : return OPPErrorCode.threeDS2Failure
        case .threeDs2ChallengeCanceled : return OPPErrorCode.threeDS2ChallengeCanceled
        case .cardScanningGeneralError : return OPPErrorCode.cardScanningGeneralError
        }
    }
    static func toFlutter(_ value: OPPErrorCode) -> FlutterErrorCode? {
        for e in FlutterErrorCode.allCases {
            if e.value == value {
                return e
            }
        }
        return nil
    }
}
