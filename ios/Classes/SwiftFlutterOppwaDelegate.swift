import Foundation
import SafariServices
import Flutter

class SwiftFlutterOppwaDelegate: NSObject, OPPThreeDSEventListener, SFSafariViewControllerDelegate, UIAdaptivePresentationControllerDelegate {
    var safari: SFSafariViewController?
    var provider: OPPPaymentProvider
    var result: FlutterResult
    var shopperResultURL: String
    var transaction: OPPTransaction?
    
    init(mode: OPPProviderMode, result: @escaping FlutterResult) {
        self.provider = OPPPaymentProvider.init(mode: mode)
        self.result = result
        self.shopperResultURL = Bundle.main.bundleIdentifier! + ".payments://result"
        super.init()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(onPaymentRedirected), name: Notification.Name("PaymentRedirected"), object: nil)
    }
    
    // Safari Related
    func presentURL(url: URL) {
        self.safari = SFSafariViewController(url: url)
        self.safari!.delegate = self;
        self.safari!.presentationController?.delegate = self;
        UIApplication.shared.windows.first?.rootViewController!.present(self.safari!, animated: true, completion: nil)
    }
    func paymentCanceled() {
        print("payment_canceled")
        self.result(FlutterError.init(code: "payment_canceled",
                                      message: "The payment was canceled",
                                      details: SwiftFlutterOppwaUtils.toJson(nil, transaction: self.transaction)))
    }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        paymentCanceled()
    }
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        paymentCanceled()
    }
    
    @objc func onPaymentRedirected() {
        print("On Payment Redirected")
        self.safari?.dismiss(animated: true) {
            self.result(SwiftFlutterOppwaUtils.toJson(self.transaction!))
        }
    }
    public func requestCheckoutInfo(_ checkoutId: String) {
        self.provider.requestCheckoutInfo(withCheckoutID: checkoutId, completionHandler: { (checkoutInfo, error) in
            print("requestCheckoutInfo completed: \(checkoutInfo != nil).")
            if checkoutInfo != nil {
                self.result(SwiftFlutterOppwaUtils.toJson(checkoutInfo!))
            } else if error != nil {
                self.result(FlutterError.init(code: "payment_error",
                                              message: error!.localizedDescription,
                                              details: nil))
            } else {
                self.result(FlutterError.init(code: "payment_error",
                                              message: "failed to get checkout info",
                                              details: nil))
            }
        })
    }
    public func submitTransaction(_ transaction: OPPTransaction) {
        transaction.paymentParams.shopperResultURL = self.shopperResultURL
        self.provider.submitTransaction(transaction, completionHandler: { (transaction, error) in
            if error != nil {
                self.result(FlutterError.init(code: "payment_error",
                                              message: error!.localizedDescription,
                                              details: SwiftFlutterOppwaUtils.toJson(error, transaction: transaction)))
            } else {
                if transaction.type == OPPTransactionType.asynchronous {
                    if transaction.redirectURL == nil {
                        self.result(FlutterError.init(code: "invalid_transaction",
                                                      message: "The transaction type was async but the redirect url was null",
                                                      details: SwiftFlutterOppwaUtils.toJson(nil, transaction: transaction)))
                        
                    } else {
                        self.transaction = transaction
                        self.presentURL(url: transaction.redirectURL!)
                    }
                } else {
                    self.result(SwiftFlutterOppwaUtils.toJson(transaction))
                }
            }
        })
    }
    public func registerTransaction(_ transaction: OPPTransaction) {
        transaction.paymentParams.shopperResultURL = self.shopperResultURL
        self.provider.register(transaction, completionHandler: { (transaction, error) in
            if error != nil {
                self.result(FlutterError.init(code: "payment_error",
                                              message: error!.localizedDescription,
                                              details: SwiftFlutterOppwaUtils.toJson(error, transaction: transaction)))
            } else {
                self.result(SwiftFlutterOppwaUtils.toJson(transaction))
            }
        })
    }
    public func sendTransaction(_ transaction: OPPTransaction, toEndpoint: String) {
        transaction.paymentParams.shopperResultURL = self.shopperResultURL
        self.provider.send(transaction, toEndpoint: toEndpoint, completionHandler: { (transaction, error) in
            if error != nil {
                self.result(FlutterError.init(code: "payment_error",
                                              message: error!.localizedDescription,
                                              details: SwiftFlutterOppwaUtils.toJson(error, transaction: transaction)))
            } else {
                self.result(SwiftFlutterOppwaUtils.toJson(transaction))
            }
        })
    }
}
