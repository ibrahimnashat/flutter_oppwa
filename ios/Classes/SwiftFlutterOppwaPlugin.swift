import Flutter
import UIKit

public class SwiftFlutterOppwaPlugin: NSObject, FlutterPlugin {
    var mode: OPPProviderMode?
    var delegate: SwiftFlutterOppwaDelegate?
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let scheme = Bundle.main.bundleIdentifier! + ".payments"
        if url.scheme?.caseInsensitiveCompare(scheme) == .orderedSame {
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name("PaymentRedirected"), object: nil)
            return true
        }
        return false
    }
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_oppwa", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterOppwaPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        do{
            let args = call.arguments as? Dictionary<String, Any>
            switch call.method {
            case "isPlayServicesWalletAvailable":
                result(false)
            case "isPlayServicesBaseAvailable":
                result(false)
            case "isApplePayAvailable":
                result(OPPPaymentProvider.deviceSupportsApplePay())
            case "initialize":
                try checkUrlInScheme()
                let mode: String = try getArgument(args, "mode")
                let providerMode = FlutterProviderMode(rawValue: mode)
                self.mode = providerMode?.value
                if self.mode == nil {
                    try throwInvalid("mode", mode)
                }
                result(true)
            case "submit_transaction":
                try checkInitialized()
                try submitTransaction(args, result)
            case "register_transaction":
                try checkInitialized()
                try registerTransaction(args, result)
            case "send_transaction":
                try checkInitialized()
                try sendTransaction(args, result)
            case "checkout_info_request":
                try checkInitialized()
                try handleCheckoutInfoRequest(args, result)
            default:
                throw SwiftFlutterOppwaException.init(errorCode: "invalid_method", message: "there is no method with the name " + call.method)
            }
            
        } catch (let error) {
            if let e = error as? SwiftFlutterOppwaException {
                result(FlutterError.init(code: e.errorCode,
                                         message: e.message,
                                         details: nil))
            } else {
                result(FlutterError.init(code: "unhandled_exception",
                                         message: error.localizedDescription,
                                         details: SwiftFlutterOppwaUtils.toJson(error, transaction: nil)))
            }
        }
    }
    func checkInitialized() throws {
        if mode == nil {
            throw SwiftFlutterOppwaException.init(errorCode: "not_initialized", message: "the plugin has not been initialized yet, please call initialize first")
        }
    }
    func handleCheckoutInfoRequest(_ args: Dictionary<String, Any>?, _ result: @escaping FlutterResult) throws  {
        let checkoutId = try getArgument(args, "checkoutId") as String
        let delegate = SwiftFlutterOppwaDelegate.init(mode: self.mode!, result: result)
        delegate.requestCheckoutInfo(checkoutId)
    }
    func submitTransaction(_ args: Dictionary<String, Any>?, _ result: @escaping FlutterResult) throws {
        let transaction = try readTransaction(args)
        self.delegate = SwiftFlutterOppwaDelegate.init(mode: self.mode!, result: result)
        self.delegate!.submitTransaction(transaction)
    }
    func registerTransaction(_ args: Dictionary<String, Any>?, _ result: @escaping FlutterResult) throws {
        let transaction = try readTransaction(args)
        self.delegate = SwiftFlutterOppwaDelegate.init(mode: self.mode!, result: result)
        self.delegate!.registerTransaction(transaction)
    }
    func sendTransaction(_ args: Dictionary<String, Any>?, _ result: @escaping FlutterResult) throws {
        let endpoint = try getArgument(args, "endpoint") as String
        let transaction = try readTransaction(args)
        self.delegate = SwiftFlutterOppwaDelegate.init(mode: self.mode!, result: result)
        self.delegate!.sendTransaction(transaction, toEndpoint: endpoint)
    }
    func readTransaction(_ args: Dictionary<String, Any>?) throws -> OPPTransaction {
        let checkoutId = try getArgument(args, "checkoutId") as String
        let type = try getArgument(args, "type") as String
        var payment: OPPPaymentParams?
        switch type {
        case "card":
            let number = try getArgument(args, "number") as String
            let brand = getNullableArgument(args, "brand") as String?
            let holder = getNullableArgument(args, "holder") as String?
            let expiryMonth = getNullableArgument(args, "expiryMonth") as String?
            let expiryYear = getNullableArgument(args, "expiryYear") as String?
            let cvv = getNullableArgument(args, "cvv") as String?
            let tokenize = getNullableArgument(args, "tokenize") as Bool?
            if brand == nil {
                payment = try OPPCardPaymentParams(checkoutID: checkoutId, holder: holder, number: number, expiryMonth: expiryMonth, expiryYear: expiryYear, cvv: cvv)
            } else {
                payment = try OPPCardPaymentParams(checkoutID: checkoutId, paymentBrand: brand!, holder: holder, number: number, expiryMonth: expiryMonth, expiryYear: expiryYear, cvv: cvv)
            }
            (payment as! OPPCardPaymentParams).isTokenizationEnabled = tokenize ?? false
        case "stc":
            let option = try getArgument(args, "verificationOption") as String
            let mobile = getNullableArgument(args, "mobile") as String?
            let verificationOption = FlutterSTCPayVerificationOption(rawValue: option)
            if verificationOption == nil {
                try throwInvalid("verificationOption", option)
            }
            payment = try OPPSTCPayPaymentParams(checkoutID: checkoutId, verificationOption: verificationOption!.value)
            (payment as! OPPSTCPayPaymentParams).phoneNumber = mobile
        case "token":
            let tokenId = try getArgument(args, "tokenId") as String
            let brand = try getArgument(args, "brand") as String
            let cvv = getNullableArgument(args, "cvv") as String?
            if cvv == nil {
                payment = try OPPTokenPaymentParams(checkoutID: checkoutId, tokenID: tokenId, paymentBrand: brand)
            } else {
                payment = try OPPTokenPaymentParams(checkoutID: checkoutId, tokenID: tokenId, cardPaymentBrand: brand, cvv: cvv)
            }
        case "apple":
            let tokenData = try getArgument(args, "tokenData") as FlutterStandardTypedData
            payment = try OPPApplePayPaymentParams(checkoutID: checkoutId, tokenData: Data(tokenData.data))
        default:
            try throwInvalid("type", type)
        }
        return OPPTransaction.init(paymentParams: payment!)
    }
    func getArgument<T>(_ args: Dictionary<String, Any>?, _ name: String) throws -> T  {
        if args == nil {
            throw SwiftFlutterOppwaException.init(errorCode: "invalid_arguments", message: "expected arguments but found null")
        }
        let contain = args!.keys.contains(name)
        if contain {
            let result = args![name] as? T
            if(result == nil){
                throw SwiftFlutterOppwaException.init(errorCode: "invalid_arguments", message: name + " can not be null")
            }
            return result!
        } else {
            throw SwiftFlutterOppwaException.init(errorCode: "invalid_arguments", message: " argument with the name of '\(name)' is required")
        }
    }
    func getNullableArgument<T>(_ args: Dictionary<String, Any>?, _ name: String) -> T?  {
        if args!.keys.contains(name) {
            let result = args![name] as? T
            return result
        }
        return nil
    }
    func throwInvalid( _ name: String,  _ value: Any) throws {
        throw SwiftFlutterOppwaException.init(errorCode: "invalid_arguments", message: "there is no \(name) with the value of \(value)")
    }
    func checkUrlInScheme() throws {
        let scheme = Bundle.main.bundleIdentifier! + ".payments"
        if !UIApplication.shared.canOpenURL(URL.init(string: scheme + "://result")!) {
            throw SwiftFlutterOppwaException.init(errorCode: "not_ready", message: "Please update Info.plist and add '\(scheme)' to CFBundleURLSchemes")
        }
    }
}
