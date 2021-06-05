//
//  PaperSelectModalViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/02.
//

import UIKit
import RxSwift

private enum Design {
    enum Text {
        static let titleTextFont = UIFont.appleBold(size: 18)
        static let titleTextColor = UIColor.gray900
        static let titleTextLetterSpace: CGFloat = -0.7
    }
}

private enum Text {
    static var infoText: String { "생성한 먼슬리 플랜으로 바로 이동할 수 있어요. 원하는 월이 없다면 속지를 추가해보세요!" }
}

protocol PaperSelectCollectionViewControllerDelegate: NSObject {
    func paperSelectCollectionView(_ paperSelectCollectionView: PaperSelectModalViewController, didSelectItem: DiaryInnerModel.PaperModel)
    func paperSelectCollectionViewDidSelectAdd()
}


final class PaperSelectModalViewController: DYModalViewController {
    private let disposeBag = DisposeBag()
    let viewModel: PaperSelectModalViewModel

    weak var delegate: PaperSelectCollectionViewControllerDelegate?

    private let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0

        return stackView
    }()

    private let infoView: InfoView = {
        let infoView = InfoView(text: Text.infoText)

        infoView.translatesAutoresizingMaskIntoConstraints = false

        return infoView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let paperSelectCollectionView: PaperSelectCollectionView = {
        let paperSelectCollectionView = PaperSelectCollectionView()
        paperSelectCollectionView.translatesAutoresizingMaskIntoConstraints = false

        return paperSelectCollectionView
    }()


    init(title: String, viewModel: PaperSelectModalViewModel) {
        self.viewModel = viewModel

        super.init(configure: .init(dimStyle: .black, modalStyle: .normal))
        setupTitleLabel(title)
        setupRightDownButton()
        setupView()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        containerView.addArrangedSubview(infoView)
        containerView.addArrangedSubview(paperSelectCollectionView)

        titleView = titleLabel
        contentView = containerView

        paperSelectCollectionView.models = viewModel.paperModels
    }

    private func bind() {
        paperSelectCollectionView.didSelect
            .subscribe(onNext: { [weak self] selectEvent in
                guard let self = self else { return }

                switch selectEvent {
                case .item(paper: let paper):
                    self.delegate?.paperSelectCollectionView(self, didSelectItem: paper)
                case .add:
                    self.dismiss(animated: true) {
                        self.delegate?.paperSelectCollectionViewDidSelectAdd()
                    }
                }
            })
            .disposed(by: disposeBag)

        infoView.closeButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.infoView.isHidden = true
            })
            .disposed(by: disposeBag)
    }
}
