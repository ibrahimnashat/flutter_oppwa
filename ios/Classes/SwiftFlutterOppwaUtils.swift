import Flutter
import Foundation

private func putNullable(_ map: inout Dictionary<String,Any>, _ key: String, _ value: Any?) {
    if value != nil {
        map[key] = value
    }
}
class SwiftFlutterOppwaUtils {
    static func toJson(_ error: Error?, transaction: OPPTransaction?) -> Dictionary<String,Any>?{
        if let err = error as? NSError {
            let errorCode = OPPErrorCode.init(rawValue: err.code)
            var details: Dictionary<String,Any>?
            for (_, value) in err.userInfo {
                if let val = value as? Dictionary<String,Any> {
                    details = val
                }
            }
            var map:Dictionary<String,Any> = Dictionary()
            let code = details?["code"] as? String
            let description = details?["description"] as? String
            putNullable(&map, "message", code)
            putNullable(&map, "info", description)
            if errorCode != nil {
                putNullable(&map, "code", FlutterErrorCode.toFlutter(errorCode!)?.rawValue)
            }
            if transaction != nil {
                putNullable(&map, "transaction", toJson(transaction!))
            }
            return map
        } else if transaction != nil {
            var map:Dictionary<String,Any> = Dictionary()
            putNullable(&map, "transaction", toJson(transaction!))
            return map
        }  else {
            return nil
        }
    }
    static func toJson(_ transaction: OPPTransaction) -> Dictionary<String,Any>{
        var map:Dictionary<String,Any> = Dictionary()
        putNullable(&map, "paymentParams", toJson(transaction.paymentParams))
        putNullable(&map, "transactionType", FlutterTransactionType.toFlutter(transaction.type)?.rawValue)
        putNullable(&map, "redirectURL", transaction.redirectURL?.absoluteString)
        putNullable(&map, "threeDS2Info", toJson(transaction.threeDS2Info))
        putNullable(&map, "yooKassaInfo", toJson(transaction.yooKassaInfo))
        putNullable(&map, "threeDS2MethodRedirectUrl", transaction.threeDS2MethodRedirectURL?.absoluteString)
        putNullable(&map, "brandSpecificInfo", transaction.brandSpecificInfo)
        return map
    }
    static func toJson(_ payment: OPPPaymentParams?) -> Dictionary<String,Any>?{
        if payment == nil {return nil}
        var map:Dictionary<String,Any> = Dictionary()
        putNullable(&map, "checkoutId", payment!.checkoutID)
        putNullable(&map, "paymentBrand", payment!.paymentBrand)
        putNullable(&map, "shopperResultUrl", payment!.shopperResultURL)
        putNullable(&map, "customParams", payment!.customParams)
        if let baseCard = payment as? OPPBaseCardPaymentParams {
            putNullable(&map, "cvv", baseCard.cvv)
            putNullable(&map, "numberOfInstallments", baseCard.numberOfInstallments)
            putNullable(&map, "threeDS2AuthParams", baseCard.threeDS2AuthParams)
        }
        if let stc = payment as? OPPSTCPayPaymentParams {
            putNullable(&map, "__typename__", "STCPayPaymentParams")
            putNullable(&map, "mobilePhoneNumber", stc.phoneNumber)
        }
        if let apple = payment as? OPPApplePayPaymentParams {
            putNullable(&map, "__typename__", "ApplePayPaymentParams")
            putNullable(&map, "mobilePhoneNumber", FlutterStandardTypedData.init(bytes: apple.tokenData))
        }
        if let card = payment as? OPPCardPaymentParams {
            putNullable(&map, "__typename__", "CardPaymentParams")
            putNullable(&map, "holder", card.holder)
            putNullable(&map, "number", card.number)
            putNullable(&map, "expiryMonth", card.expiryMonth)
            putNullable(&map, "expiryYear", card.expiryYear)
            putNullable(&map, "countryCode", card.countryCode)
            putNullable(&map, "mobilePhone", card.mobilePhone)
            putNullable(&map, "tokenizationEnabled", card.isTokenizationEnabled)
            putNullable(&map, "billingAddress", toJson(card.address))
        }
        if let token = payment as? OPPTokenPaymentParams {
            putNullable(&map, "__typename__", "TokenPaymentParams")
            putNullable(&map, "tokenId", token.tokenID)
        }
        // TODO add others
        return map
    }
    static func toJson(_ info: OPPThreeDS2Info?) -> Dictionary<String,Any>?{
        if info==nil {return nil}
        var map:Dictionary<String,Any> = Dictionary()
        putNullable(&map, "authStatus", FlutterThreeDS2Status.toFlutter(info!.authStatus)?.rawValue)
        putNullable(&map, "authResponse", info!.authResponse)
        putNullable(&map, "protocolVersion", info!.protocolVersion)
        putNullable(&map, "callbackUrl", info!.callbackURL)
        putNullable(&map, "challengeCompletionCallbackUrl", info!.challengeCompletionCallbackUrl)
        putNullable(&map, "cardHolderInfo", info!.cardHolderInfo)
        return map
    }
    static func toJson(_ info: OPPYooKassaInfo?) -> Dictionary<String,Any>?{
        if info==nil {return nil}
        var map:Dictionary<String,Any> = Dictionary()
        putNullable(&map, "status", FlutterYooKassaStatus.toFlutter(info!.status)?.rawValue)
        putNullable(&map, "confirmationUrl", info!.confirmationUrl)
        putNullable(&map, "callbackUrl", info!.callbackUrl)
        return map
    }
    static func toJson(_ address: OPPBillingAddress?) -> Dictionary<String,Any>?{
        if address==nil {return nil}
        var map:Dictionary<String,Any> = Dictionary()
        putNullable(&map, "country", address!.country)
        putNullable(&map, "state", address!.state)
        putNullable(&map, "city", address!.city)
        putNullable(&map, "postCode", address!.postCode)
        putNullable(&map, "street1", address!.street1)
        putNullable(&map, "street2", address!.street2)
        return map
    }
    static func toJson(_ checkoutInfo: OPPCheckoutInfo) -> Dictionary<String,Any>{
        var map:Dictionary<String,Any> = Dictionary()
        putNullable(&map, "amount", checkoutInfo.amount)
        // putNullable(&map, "brands", checkoutInfo.brands)
        putNullable(&map, "currencyCode", checkoutInfo.currencyCode)
        putNullable(&map, "endpoint", checkoutInfo.endpoint)
        putNullable(&map, "klarnaMerchantIds", checkoutInfo.klarnaMerchantIDs)
        putNullable(&map, "resourcePath", checkoutInfo.resourcePath)
        putNullable(&map, "threeDs2Brands", checkoutInfo.threeDS2Brands)
        putNullable(&map, "threeDs2Flow", FlutterCheckoutThreeDS2Flow.toFlutter( checkoutInfo.threeDS2Flow)?.rawValue)
        putNullable(&map, "collectRedShieldDeviceId", checkoutInfo.collectRedShieldDeviceId)
        putNullable(&map, "browserParamsRequired", checkoutInfo.isBrowserParamsRequired)
        putNullable(&map, "paymentBrandsConfig", toJson(checkoutInfo.paymentBrandsConfig))
        putNullable(&map, "tokens", checkoutInfo.tokens?.compactMap{ toJson($0) })
        return map
    }
    static func toJson(_ config: OPPPaymentBrandsConfig?) -> Dictionary<String,Any>?{
        if config==nil {return nil}
        var map:Dictionary<String,Any> = Dictionary()
        putNullable(&map, "enabled", config!.isEnabled)
        putNullable(&map, "paymentBrands", config!.paymentBrands)
        putNullable(&map, "shouldOverride", config!.shouldOverride)
        return map
    }
    static func toJson(_ token: OPPToken?) -> Dictionary<String,Any>? {
        if token==nil {return nil}
        var map:Dictionary<String,Any> = Dictionary()
        putNullable(&map, "tokenID", token!.tokenID)
        putNullable(&map, "paymentBrand", token!.paymentBrand)
        putNullable(&map, "card", token!.card)
        putNullable(&map, "bankAccount", token!.bankAccount)
        putNullable(&map, "virtualAccount", token!.virtualAccount)
        return map
    }
    static func toJson(_ card: OPPCard?) -> Dictionary<String,Any>? {
        if card==nil {return nil}
        var map:Dictionary<String,Any> = Dictionary()
        putNullable(&map, "holder", card!.holder)
        putNullable(&map, "last4Digits", card!.last4Digits)
        putNullable(&map, "expiryMonth", card!.expiryMonth)
        putNullable(&map, "expiryYear", card!.expiryYear)
        return map
    }
    static func toJson(_ bankAccount: OPPBankAccount?) -> Dictionary<String,Any>? {
        if bankAccount==nil {return nil}
        var map:Dictionary<String,Any> = Dictionary()
        putNullable(&map, "holder", bankAccount!.holder)
        putNullable(&map, "IBAN", bankAccount!.iban)
        return map
    }
    static func toJson(_ virtualAccount: OPPVirtualAccount?) -> Dictionary<String,Any>? {
        if virtualAccount==nil {return nil}
        var map:Dictionary<String,Any> = Dictionary()
        putNullable(&map, "holder", virtualAccount!.holder)
        putNullable(&map, "accountId", virtualAccount!.accountId)
        return map
    }
}
