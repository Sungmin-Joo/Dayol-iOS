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
    private var disposeBag: DisposeBag = DisposeBag()

    var canMakePayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }

    let updatedProducts: PublishSubject<[SKProduct]> = PublishSubject<[SKProduct]>()
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
        guard canMakePayments else { return }
        paymentQueue.restoreCompletedTransactions()
    }

    func checkPurchased() -> Single<API.MembershipReceiptAPI.Response> {
        return API.MembershipReceiptAPI(password: sharedSecretPassword).rx.response()
    }
}

// MARK: - Request Delegate

extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard !response.products.isEmpty else { return }
        products = response.products
        updatedProducts.onNext(response.products)

        response.products.forEach { product in
            DYLog.d(.inAppPurchase, value: product.productIdentifier)
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
                MembershipManager.shared.didChangeMembership(type: .subscriber)
                paymentQueue.finishTransaction(transaction)
                DYLog.i(.inAppPurchase, value: "PURCHASED")
            case .failed:
                purchasedProduct.onNext(false)
                paymentQueue.finishTransaction(transaction)
                DYLog.e(.inAppPurchase, value: "FAILED")
            case .deferred:
                paymentQueue.finishTransaction(transaction)
                DYLog.i(.inAppPurchase, value: "DEFERRED")
            case .restored:
                paymentQueue.finishTransaction(transaction)
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
