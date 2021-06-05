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

final class DiaryPaperEmptyViewController: UIViewController {
    private let emptyView: DiaryPaperEmptyView = {
        let view = DiaryPaperEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

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
        presentAddPaperModal()
    }

    private func presentAddPaperModal() {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        let screenHeight = keyWindow?.bounds.height ?? .zero
        let modalHeight: CGFloat = screenHeight - Design.addPageModalTopMargin
        let modalStyle: DYModalConfiguration.ModalStyle = isPadDevice ? .normal : .custom(containerHeight: modalHeight)
        let configuration = DYModalConfiguration(dimStyle: .black,
                                                 modalStyle: modalStyle)

        let modalVC = PaperModalViewController(toolType: .add, configure: configuration)
        modalVC.delegate = self

        presentCustomModal(modalVC)
    }
}

extension DiaryPaperEmptyViewController: PaperModalViewDelegate {
    func didSelectedDate(didSelected date: Date?) { }
    func didTappedMonthlyAdd() { }
    func didTappedItem(_ paper: DiaryInnerModel.PaperModel) { }
    func didTappedAdd() { }
}
