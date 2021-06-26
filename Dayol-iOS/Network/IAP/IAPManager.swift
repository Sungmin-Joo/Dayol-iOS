//
//  IAPManager.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/20.
//

import Foundation
import StoreKit
import RxSwift

// TODO: 서버로 이전
private enum Product: String, CaseIterable {
    case membership = "membership"
    private enum MembershipItem: String, CaseIterable {
        case month = "month"
        case year = "year"
    }

    private static let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""

    var identifiers: Set<String> {
        var identifiers: Set<String> = []

        MembershipItem.allCases.forEach {
            identifiers.insert([Self.bundleIdentifier, self.rawValue, $0.rawValue].joined(separator: "."))
        }

        // ... Add Type

        return identifiers
    }
}

final class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static var shared = IAPManager()

    private let productIdentifiers: Set<String> = Product.membership.identifiers
    private var products: [SKProduct] = []

    let updated: BehaviorSubject<[SKProduct]> = BehaviorSubject<[SKProduct]>(value: [])

    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        updated.onNext(response.products)

        products.removeAll()
        response.products.forEach { product in
            products.append(product)
            DYLog.i(.debug, value: product.productIdentifier)
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased, .restored:
                break
            case .failed, .deferred:
                break
            default:
                break
            }
        }
    }
}
