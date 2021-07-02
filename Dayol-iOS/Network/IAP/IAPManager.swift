//
//  IAPManager.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/20.
//

import Foundation
import StoreKit
import RxSwift

// MARK: - IAP Product Type

enum IAPProduct: CaseIterable {
    case membershipYear
    case membershipMonth

    init?(identifier: String) {
        switch identifier {
        case IAPProduct.membershipYear.identifier: self = .membershipYear
        case IAPProduct.membershipMonth.identifier: self = .membershipMonth
        default: return nil
        }
    }

    private static let bundleIdentifier: String = {
        guard Config.shared.isProd else { return "com.dayolstudio.dayol" }
        return Bundle.main.bundleIdentifier ?? ""
    }()

    static var identifiers: Set<String> {
        var identifiers: Set<String> = []
        Self.allCases.forEach {
            identifiers.insert([Self.bundleIdentifier, $0.toString].joined(separator: "."))
        }

        return identifiers
    }

    var toString: String {
        switch self {
        case .membershipYear: return "membership.year"
        case .membershipMonth: return "membership.month"
        }
    }

    var identifier: String {
        return Self.bundleIdentifier + "." + self.toString
    }
}

// MARK: - IAP Manager

final class IAPManager: NSObject {
    static var shared = IAPManager()

    private let productIdentifiers: Set<String> = IAPProduct.identifiers
    private let sharedSecretPassword = "a077f258292c41288a70b3c96c0a22ab"
    private let paymentQueue: SKPaymentQueue = SKPaymentQueue.default()
    private var products = [SKProduct]()


    var canMakePayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }

    let updatedProducts: BehaviorSubject<[SKProduct]> = BehaviorSubject<[SKProduct]>(value: [])
    let purchasedProduct: PublishSubject<Bool> = PublishSubject<Bool>()

    override init() {
        super.init()
        paymentQueue.add(self)
    }

    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }

    func purchase(product: SKProduct) {
        guard canMakePayments else { return }
        let payment = SKPayment(product: product)
        paymentQueue.add(payment)
    }

    func restorePurchase() {
        paymentQueue.restoreCompletedTransactions()
    }

    func checkPurchased() {
        guard
            let url = URL(string:"https://sandbox.itunes.apple.com/verifyReceipt"),
            let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path)
        else {
            DYLog.e(.inAppPurchase, value: "Receipt Error")
            return
        }

        guard let receiptData = try? Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped) else { return }
        let receiptString = receiptData.base64EncodedString(options: [])
        let requestData : [String : Any] = [
            "receipt-data" : receiptString,
            "password" : sharedSecretPassword,
            "exclude-old-transactions" : false
        ]

        let httpBody = try? JSONSerialization.data(withJSONObject: requestData, options: [])
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
                request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = httpBody
                URLSession.shared.dataTask(with: request)  { (data, response, error) in
                    if let error = error {
                        DYLog.e(.inAppPurchase, value: error)
                        return
                    }

                    if let jsonData = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        DYLog.i(.inAppPurchase, value: jsonData)
                    }
                }.resume()

    }
}

// MARK: - Request Delegate

extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard !response.products.isEmpty else { return }
        products = response.products
        updatedProducts.onNext(response.products)

        response.products.forEach { product in
            DYLog.d(.debug, value: product.productIdentifier)
        }
    }
}

// MARK: - Payment Transaction Observer

extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            DYLog.d(.inAppPurchase, value: "ID: \(transaction.transactionIdentifier)")
            DYLog.d(.inAppPurchase, value: "Original ID: \(transaction.original?.transactionIdentifier)")
            switch transaction.transactionState {
            case .purchasing:
                DYLog.i(.inAppPurchase, value: "PURCHASING")
            case .purchased:
                purchasedProduct.onNext(true)
                DYUserDefaults.activityType = UserActivityType.subscriber.rawValue
                DYUserDefaults.isMembership = true
                SKPaymentQueue.default().finishTransaction(transaction)
                DYLog.i(.inAppPurchase, value: "PURCHASED")
            case .failed:
                purchasedProduct.onNext(false)
                SKPaymentQueue.default().finishTransaction(transaction)
                DYLog.e(.inAppPurchase, value: "FAILED")
            case .deferred:
                SKPaymentQueue.default().finishTransaction(transaction)
                DYLog.i(.inAppPurchase, value: "DEFERRED")
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                DYLog.i(.inAppPurchase, value: "RESTORED")
            default:
                break
            }
        }
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        DYLog.i(.inAppPurchase, value: "RestoreCompletedTransactionsFinished")
    }
}
