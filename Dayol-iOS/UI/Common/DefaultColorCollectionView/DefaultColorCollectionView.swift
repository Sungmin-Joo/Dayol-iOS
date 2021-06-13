//
<<<<<<< HEAD:Dayol-iOS/UI/Common/DefaultColorCollectionView/DefaultColorCollectionView.swift
//  DefaultColorCollectionView.swift
=======
//  ColorPaletteView.swift
>>>>>>> 3fc72df91b5b3c46f32bd17f191407eba1b81b17:Dayol-iOS/UI/Common/View/ColorPalette/ColorPaletteView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/04.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let paletteBackgroundColor = UIColor.gray100
    static let cellSpace: CGFloat = 11

    enum Label {
        static let letterSpace: CGFloat = -0.28
        static let textFont = UIFont.appleRegular(size: 15)
        static let textColor = UIColor.gray900
    }
}

<<<<<<< HEAD:Dayol-iOS/UI/Common/DefaultColorCollectionView/DefaultColorCollectionView.swift
private enum Text: String {
    case select = "색상"
}

final class DefaultColorCollectionView: UIView {
    // MARK: - Private Properties
    private var usesHeader: Bool = false

    private var model: [DiaryCoverColor]? {
=======
class ColorPaletteView: UIView {
    // MARK: - Private Properties
    
    private var model: [PaletteColor]? {
>>>>>>> 3fc72df91b5b3c46f32bd17f191407eba1b81b17:Dayol-iOS/UI/Common/View/ColorPalette/ColorPaletteView.swift
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: - Subjects

<<<<<<< HEAD:Dayol-iOS/UI/Common/DefaultColorCollectionView/DefaultColorCollectionView.swift
    let changedColor = PublishSubject<DiaryCoverColor>()

=======
    let changedColor = PublishSubject<PaletteColor>()
    
>>>>>>> 3fc72df91b5b3c46f32bd17f191407eba1b81b17:Dayol-iOS/UI/Common/View/ColorPalette/ColorPaletteView.swift
    // MARK: - UI Components

    private var collectionViewWidthForIpad = NSLayoutConstraint()

    private let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Design.cellSpace

        return stackView
    }()

    private let headerView: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        initView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Method

    private func initView() {
        backgroundColor = Design.paletteBackgroundColor
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DefaultColorCollectionViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentMode = .center

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            layout.scrollDirection = .horizontal
            layout.itemSize = DefaultColorCollectionViewCell.size
            layout.minimumInteritemSpacing = Design.cellSpace
            layout.minimumLineSpacing = Design.cellSpace
        }

        headerView.attributedText = NSAttributedString.build(text: Text.select.rawValue,
                                                             font: Design.Label.textFont,
                                                             align: .natural,
                                                             letterSpacing: Design.Label.letterSpace,
                                                             foregroundColor: Design.Label.textColor)

        addSubview(containerView)
        containerView.addArrangedSubview(headerView)
        containerView.addArrangedSubview(collectionView)

        setConstraint()
    }

    private func setConstraint() {
        if isPadDevice {
            collectionViewWidthForIpad = collectionView.widthAnchor.constraint(equalToConstant: 0)
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: topAnchor),
                containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
                containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
                collectionViewWidthForIpad
            ])
        } else {
            NSLayoutConstraint.activate([
                containerView.leftAnchor.constraint(equalTo: leftAnchor),
                containerView.topAnchor.constraint(equalTo: topAnchor),
                containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
                containerView.rightAnchor.constraint(equalTo: rightAnchor),
            ])
        }
    }
}

<<<<<<< HEAD:Dayol-iOS/UI/Common/DefaultColorCollectionView/DefaultColorCollectionView.swift
extension DefaultColorCollectionView {
    var colors: [DiaryCoverColor]? {
=======
extension ColorPaletteView {
    var colors: [PaletteColor]? {
>>>>>>> 3fc72df91b5b3c46f32bd17f191407eba1b81b17:Dayol-iOS/UI/Common/View/ColorPalette/ColorPaletteView.swift
        get {
            return self.model
        }
        set {
            self.model = newValue

            if isPadDevice {
                collectionViewWidthForIpad.constant = collectionViewWidth(cellCount: self.model?.count ?? 0)
            }
        }
    }

    var showHeader: Bool {
        get {
            return self.usesHeader
        }
        set {
            self.headerView.isHidden = !newValue
            self.usesHeader = newValue
        }
    }

    private func collectionViewWidth(cellCount: Int) -> CGFloat {
        let inset: CGFloat = 16
        let cellWidth: CGFloat = DefaultColorCollectionViewCell.size.width

        let totalCellWidth = cellWidth * CGFloat(cellCount)
        let totalSpace = Design.cellSpace * CGFloat(cellCount-1)

        return (inset * 2) + totalSpace + totalCellWidth
    }
}

// MARK: - CollectionView DataSource

<<<<<<< HEAD:Dayol-iOS/UI/Common/DefaultColorCollectionView/DefaultColorCollectionView.swift
extension DefaultColorCollectionView: UICollectionViewDataSource {
=======
extension ColorPaletteView: UICollectionViewDataSource {
>>>>>>> 3fc72df91b5b3c46f32bd17f191407eba1b81b17:Dayol-iOS/UI/Common/View/ColorPalette/ColorPaletteView.swift
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let colors = model else { return 0 }
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let color = self.model?[safe: indexPath.item] else { return UICollectionViewCell() }

        let cell = collectionView.dequeueReusableCell(DefaultColorCollectionViewCell.self, for: indexPath)
        cell.configure(color: color)

        return cell
    }
}

// MARK: - ColletionView Delegate

<<<<<<< HEAD:Dayol-iOS/UI/Common/DefaultColorCollectionView/DefaultColorCollectionView.swift
extension DefaultColorCollectionView: UICollectionViewDelegate {
=======
extension ColorPaletteView: UICollectionViewDelegate {
>>>>>>> 3fc72df91b5b3c46f32bd17f191407eba1b81b17:Dayol-iOS/UI/Common/View/ColorPalette/ColorPaletteView.swift
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let color = self.model?[safe: indexPath.item] else { return }
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        changedColor.onNext(color)
    }
}

// MARK: - Public Color Interaction

extension ColorPaletteView {

    var currentDYColor: PaletteColor? {
        guard
            let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first,
            let color = colors?[selectedIndexPath.row]
        else {
            return nil
        }
        return color
    }

    func selectColor(_ color: PaletteColor) {
        guard
            let colors = colors?.enumerated(),
            let index = colors.filter({ $1 == color }).first?.offset
        else { return }

        let indexPath = IndexPath(item: index, section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .right)
    }

    func deselectColorItem(animated: Bool = true) {
        collectionView.indexPathsForSelectedItems?.forEach {
            collectionView.deselectItem(at: $0, animated: animated)
        }
    }

}

// MARK: - Public CollectionView Control

extension ColorPaletteView {
    func setInset(_ sectionInset: UIEdgeInsets) {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = sectionInset
        }
    }
}
