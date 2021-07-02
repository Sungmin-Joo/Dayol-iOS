//
//  MemberShipViewController.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/20.
//

import UIKit
import StoreKit
import RxSwift

private class ViewModel {
    let userActivityType: UserActivityType

    var updatedProducts: Observable<[SKProduct]> {
        return IAPManager.shared.updatedProducts.asObservable()
    }

    var purchasedProduct: Observable<Bool> {
        return IAPManager.shared.purchasedProduct.asObservable()
    }

    var products: [SubscribeItemType: SKProduct] = [:]

    init() {
        if let userActivityType = UserActivityType(rawValue: DYUserDefaults.activityType) {
            self.userActivityType = .new
            IAPManager.shared.fetchProducts()
            IAPManager.shared.checkPurchased()
        } else {
            fatalError("No User Activity Type")
        }
    }

    func convertToSubscribeProduct(products: [SKProduct]) {
        products.forEach {
            let productInfo = SubscribeItemType.SubscribeProductInfo(
                title: $0.localizedTitle,
                price: "\($0.price)",
                description: $0.localizedDescription
            )

            switch IAPProduct(identifier: $0.productIdentifier) {
            case .membershipYear:
                self.products[.year(product: productInfo)] = $0
            case .membershipMonth:
                self.products[.month(product: productInfo)] = $0
            default: break
            }
        }
    }

    func payment(key: SubscribeItemType) {
        if let product = products.first(where: { $0.key == key })?.value {
            IAPManager.shared.purchase(product: product)
        }
    }
}

class MembershipViewController: UIViewController {
    private let subscribeView: MembershipSubscribeView = {
        let subscribeView = MembershipSubscribeView()
        subscribeView.translatesAutoresizingMaskIntoConstraints = false
        subscribeView.backgroundColor = .white
        subscribeView.isHidden = true
        return subscribeView
    }()

    private let contentsView: MembershipContentsView = {
        let view = MembershipContentsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let containerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var leftButton = DYNavigationItemCreator.barButton(type: .back)
    private lazy var rightButton = DYNavigationItemCreator.barButton(type: .cancel)

    private let viewModel = ViewModel()
    private let disposeBag: DisposeBag = DisposeBag()

    deinit { DYLog.i(.deinit, value: "\(Self.self)") }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setNavigationBar()
        addSubviews()
        addConstraints()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func bind() {
        viewModel.updatedProducts
            .skip(1)
            .observe(on: MainScheduler.instance)
            .attachHUD(view)
            .subscribe { [weak self] products in
                guard let self = self, let products = products.element else { return }
                self.viewModel.convertToSubscribeProduct(products: products)
                self.setSubscribeView()
            }.disposed(by: disposeBag)

        viewModel.purchasedProduct
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self, let isSuccess = result.element else { return }
                if isSuccess {
                    DYUserDefaults.isMembership = true
                    self.dismiss(animated: true)
                } else {
                    DYUserDefaults.isMembership = false
                    DYLog.e(.inAppPurchase, value: "Purchase Error")
                }
            }.disposed(by: disposeBag)
    }
}

// MARK: - Setup View
private extension MembershipViewController {
    func setNavigationBar() {
        let isTopMost = navigationController?.viewControllers.first is Self
        if isTopMost {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
            rightButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
            leftButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        }
    }

    func addSubviews() {
        containerScrollView.addSubview(contentsView)
        view.addSubview(containerScrollView)
        view.addSubview(subscribeView)
        configureComponents()
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            subscribeView.heightAnchor.constraint(equalToConstant: 196),
            subscribeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            subscribeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subscribeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            containerScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentsView.widthAnchor.constraint(equalTo: containerScrollView.widthAnchor),
            contentsView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            contentsView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor),
            contentsView.centerXAnchor.constraint(equalTo: containerScrollView.centerXAnchor),
        ])
    }

    func configureComponents() {
        contentsView.configure(viewModel.userActivityType)
    }

    func setSubscribeView() {
        let isExist: Bool = self.viewModel.userActivityType == .subscriber
        let bottomInset: CGFloat = isExist ? .zero : 233

        if !isExist {
            self.subscribeView.delegate = self
            self.subscribeView.configure(self.viewModel.products.map { $0.key }, for: viewModel.userActivityType)
        }

        self.containerScrollView.contentInset.bottom = bottomInset
        self.subscribeView.isHidden = isExist
    }
}

// MARK: - Action

extension MembershipViewController: MembershipSubscribeViewDelegate {
    @objc func didTapClose() {
        super.dismiss(animated: true)
    }

    func didTapSubscribe(productView: SubscribeProductView) {
        if let type = productView.type {
            viewModel.payment(key: type)
        }
    }
}
