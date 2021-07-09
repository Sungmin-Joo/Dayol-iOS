//
//  WeeklyCalendarView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/02/01.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static func headerHeight(style: Paper.PaperOrientation) -> CGFloat {
        switch style {
        case .portrait: return 125
        case .landscape: return 81
        }
    }
}

class WeeklyCalendarView: BasePaper {
    let showAddSchedule = PublishSubject<Date>()
    let showSelectPaper = PublishSubject<Void>()

    private var dayModel: [WeeklyCalendarDataModel]?
    var disposeBag = DisposeBag()
    
    private let headerView: MonthlyCalendarHeaderView = {
        let header = MonthlyCalendarHeaderView(month: .january)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        return header
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configure(viewModel: PaperViewModel, orientation: Paper.PaperOrientation) {
        super.configure(viewModel: viewModel, orientation: orientation)
        setupCollectionView()
        
        contentView.addSubview(headerView)
        contentView.addSubview(collectionView)
        setupConstraints()
        
        bind()
    }

    
    private func setupConstraints() {
        guard let orientation = self.orientation else { return }
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Design.headerHeight(style: orientation)),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            collectionView.collectionViewLayout = layout
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WeeklyCalendarViewCell.self, forCellWithReuseIdentifier: WeeklyCalendarViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
    }
    
    private func bind() {
        guard let viewModel = self.viewModel as? WeeklyCalendarViewModel else { return }
        
        viewModel.dateModel()
            .subscribe(onNext: {[weak self] models in
                guard let month = models[safe: 1]?.month else { return }
                self?.headerView.month = month
                self?.dayModel = models
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedHeaderView(_:))))
    }
    
    private func updateCollectionView() {
        collectionView.layoutIfNeeded()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    @objc
    private func didTappedHeaderView(_ sender: WeeklyCalendarHeaderView) {
        showSelectPaper.onNext(())
    }
}

// MARK: - CollectionView Delegate

extension WeeklyCalendarView: UICollectionViewDelegate {
    
}

// MARK: - CollectionView DataSource

extension WeeklyCalendarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = dayModel?[safe: indexPath.item],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyCalendarViewCell.identifier, for: indexPath) as? WeeklyCalendarViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(model: model)
        if model.isFirst {
            cell.setFirstCell(true)
        }

        cell.didLongTapped
            .bind { [weak self] in
                guard let self = self,
                      let dayModel = self.dayModel?[safe: indexPath.item]
                else { return }
                let day = dayModel.day
                let month = dayModel.month.rawValue + 1
                let year = dayModel.year

                let date = DateType.yearMonthDay.date(year: year, month: month, day: day) ?? .now

                self.showAddSchedule.onNext(date)
            }
            .disposed(by: disposeBag)
        
        return cell
    }
}

// MARK: - CollectionView FlowLayout

extension WeeklyCalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height / 4)
    }
}
