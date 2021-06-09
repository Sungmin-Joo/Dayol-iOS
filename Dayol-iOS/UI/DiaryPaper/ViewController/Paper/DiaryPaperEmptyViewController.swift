//
//  DiaryPaperEmptyViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/05.
//

import UIKit

private enum Design {
    static let addPageModalTopMargin: CGFloat = 57.0
}

protocol DiaryPaperEmptyViewControllerDelegate: NSObject {
    func didTapEmptyView()
}

final class DiaryPaperEmptyViewController: UIViewController {
    private let emptyView: DiaryPaperEmptyView = {
        let view = DiaryPaperEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    weak var delegate: DiaryPaperEmptyViewControllerDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }                

    private func setupView() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(didTapEmptyView))
        emptyView.addGestureRecognizer(tapGesture)

        view.addSubViewPinEdge(emptyView)
    }

    @objc
    private func didTapEmptyView() {
        delegate?.didTapEmptyView()
    }
}
