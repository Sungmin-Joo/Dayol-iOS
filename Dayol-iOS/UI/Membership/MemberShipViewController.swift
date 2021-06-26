//
//  MemberShipViewController.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/06/20.
//

import UIKit
import StoreKit
import RxSwift

class MembershipViewController: UIViewController {
    struct ViewModel {
        let userActivityType: UserActivityType
        var products: [SubscribeProduct] = []

        mutating func update(products: [SKProduct]) {
            products.reversed().forEach {
                self.products.append(
                    SubscribeProduct(
                        title: $0.localizedTitle,
                        price: "\("currency_suffix".localized)\($0.price)\("currency_symbol".localized)/\("date_year".localized)",
                        description: $0.localizedDescription,
                        emphasisTitleStrings: $0.localizedTitle.components(separatedBy: " ")
                    )
                )
            }
        }
    }

    private let subscribeView: MembershipSubscribeView = {
        let subscribeView = MembershipSubscribeView()
        subscribeView.translatesAutoresizingMaskIntoConstraints = false
        subscribeView.backgroundColor = .white
        return subscribeView
    }()

    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    private let containerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var leftButton = DYNavigationItemCreator.barButton(type: .back)
    private lazy var rightButton = DYNavigationItemCreator.barButton(type: .cancel)

    private var viewModel: ViewModel
    private let disposeBag: DisposeBag = DisposeBag()

    deinit { DYLog.i(.deinit, value: "\(Self.self)") }

    init(_ type: UserActivityType) {
        self.viewModel = ViewModel(userActivityType: type)
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
}

// MARK: - Setup View
private extension MembershipViewController {
    func setNavigationBar() {
        let isTopMost = navigationController?.viewControllers.first is Self
        if isTopMost {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        }
    }

    func addSubviews() {
        containerScrollView.addSubview(containerStackView)
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

            containerStackView.widthAnchor.constraint(equalTo: containerScrollView.widthAnchor),
            containerStackView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor),
            containerStackView.centerXAnchor.constraint(equalTo: containerScrollView.centerXAnchor),
        ])
    }

    func bind() {
        IAPManager.shared.fetchProducts()
        IAPManager.shared.updated
            .skip(1)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] products in
                guard
                    let self = self,
                    let products = products.element
                else {
                    return
                }

                self.viewModel.update(products: products)

                let isExist: Bool = self.viewModel.userActivityType == .exist
                let bottomInset: CGFloat = isExist ? .zero : 233

                if !isExist {
                    self.subscribeView.configure(self.viewModel.products)
                }

                UIView.animate(withDuration: 1) {
                    self.containerScrollView.contentInset.bottom = bottomInset
                    self.subscribeView.isHidden = isExist
                }
            }.disposed(by: disposeBag)
    }

    func configureComponents() {
        containerStackView.addArrangedSubview(MembershipContentsView(viewModel))
    }
}
