//
//  StickerModalViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/25.
//

import UIKit
import RxSwift

private enum Design {
    static let modalHeight: CGFloat = 300
}

class StickerModalViewContoller: DYModalViewController {
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private var stickers: [UIImage]?
    
    var didTappedSticker: PublishSubject<UIImage?> {
        return stickerContentView.didTappedSticker
    }
    
    // MARK: - UIComponent
    
    private let headerView: StickerModalHeaderView = {
        let view = StickerModalHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stickerContentView: StickerModalCollectionView = {
        let view = StickerModalCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    // MARK: - Init
    
    init() {
        let config = DYModalConfiguration(dimStyle: .clear, modalStyle: .custom(containerHeight: Design.modalHeight))
        super.init(configure: config)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func initView() {
        titleView = headerView
        contentView = stickerContentView
        
        combine()
    }
    
    // MARK: - Combine
    
    private func combine() {
        headerView.didTappedCloseButton
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
