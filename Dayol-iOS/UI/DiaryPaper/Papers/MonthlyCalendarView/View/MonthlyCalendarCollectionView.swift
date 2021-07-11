//
//  MonthlyCalendarCollectionView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/25.
//

import UIKit
import RxSwift

private enum Design {
    enum IPadOrientation {
        case landscape
        case portrait
    }
    static let dayFont = UIFont.systemFont(ofSize: 11, weight: .bold)
    static let sundayColor = UIColor.dayolRed
    static let saturdayColor = UIColor(decimalRed: 41, green: 85, blue: 230)
    static let dayColor: UIColor = .black
    static let dayLetterSpace: CGFloat = -0.42
    static let weekDayHeight: CGFloat = 20
    
    static let separatorLineColor: UIColor = .gray200
    static let separatorLineWidth: CGFloat = 1
    static let maxScheduleCount: Int = isPadDevice ? 4 : 3
}

class MonthlyCalendarCollectionView: UIView {
    let longTappedIndex = PublishSubject<Int>()

    private var dayModel: [MonthlyCalendarDayModel]?
    private var paperOrientation: Paper.PaperOrientation = .portrait
    private var iPadOrientation: Design.IPadOrientation {
        if self.frame.size.width > self.frame.size.height {
            return .landscape
        } else {
            return .portrait
        }
    }

    private let weekDayView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    private let dayLabels: [UILabel] = {
        var labels = [UILabel]()
        let attributes: [NSAttributedString.Key: Any] = [
            .font : Design.dayFont,
            .kern : Design.dayLetterSpace
        ]
        WeekDay.allCases.forEach { weekday in
            let dayColor: UIColor
            let label = UILabel()
            if weekday == .sunday {
                dayColor = Design.sundayColor
            } else if weekday == .saturday {
                dayColor = Design.saturdayColor
            } else {
                dayColor = Design.dayColor
            }
            let attributedText = NSAttributedString(string: weekday.stringValue, attributes: attributes)
            label.textColor = dayColor
            label.attributedText = attributedText
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            labels.append(label)
        }
        
        return labels
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let separatorLine: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Design.separatorLineWidth))
        view.backgroundColor = Design.separatorLineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private(set) var scheduleContainerViews: [PaperScheduleLineContainerView] = []
    var firstDatesOfSunday: [Date] = []

    init() {
        super.init(frame: .zero)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionView()
    }
    
    private func initView() {
        addSubview(weekDayView)
        addSubview(collectionView)
        addSubview(separatorLine)
        dayLabels.forEach { weekDayView.addArrangedSubview($0) }
        setupCollectionView()
        setConstraint()
    }
    
    private func setupCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            collectionView.collectionViewLayout = layout
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MonthlyCalendarViewDayCell.self, forCellWithReuseIdentifier: MonthlyCalendarViewDayCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
    }

    private func setConstraint() {
        NSLayoutConstraint.activate([
            weekDayView.topAnchor.constraint(equalTo: topAnchor),
            weekDayView.leftAnchor.constraint(equalTo: leftAnchor),
            weekDayView.rightAnchor.constraint(equalTo: rightAnchor),
            weekDayView.heightAnchor.constraint(equalToConstant: Design.weekDayHeight),
            
            separatorLine.leftAnchor.constraint(equalTo: leftAnchor),
            separatorLine.rightAnchor.constraint(equalTo: rightAnchor),
            separatorLine.topAnchor.constraint(equalTo: weekDayView.bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: Design.separatorLineWidth),
            
            collectionView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func updateCollectionView() {
        collectionView.layoutIfNeeded()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func setupSchedules() {
        for index in 0..<6 {
            let scheduleLineContainer = makeScheduleLineContainer(index: index)
            self.scheduleContainerViews.append(scheduleLineContainer)
            addSubview(scheduleLineContainer)
        }
    }

    private func makeScheduleLineContainer(index: Int) -> PaperScheduleLineContainerView {
        let scheduleLineContainer = PaperScheduleLineContainerView(lineType: .month(paper: paperOrientation))
        scheduleLineContainer.translatesAutoresizingMaskIntoConstraints = false
        scheduleLineContainer.set(
            scheduleCount: Design.maxScheduleCount,
            widthPerSchedule: collectionView.frame.size.width / 7,
            schedules: DYTestData.shared.scheduleModels,
            firstDateOfWeek: firstDatesOfSunday[index]
        )

        return scheduleLineContainer
    }
}

extension MonthlyCalendarCollectionView {
    var days: [MonthlyCalendarDayModel]? {
        get {
            return self.dayModel
        }
        set {
            self.dayModel = newValue
            self.collectionView.reloadData()
            self.setupSchedules()
        }
    }
}

extension MonthlyCalendarCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let day = dayModel?[safe: indexPath.item],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyCalendarViewDayCell.identifier, for: indexPath) as? MonthlyCalendarViewDayCell
        else { return UICollectionViewCell() }
        
        cell.configure(model: day)

        cell.didLongTapped
            .bind { [weak self] in
                guard let self = self else { return }

                self.longTappedIndex.onNext(indexPath.item)
            }
            .disposed(by: cell.disposeBag)

        return cell
    }
}

extension MonthlyCalendarCollectionView {
    var orientation: Paper.PaperOrientation {
        get {
            return self.paperOrientation
        }
        set {
            self.paperOrientation = newValue
        }
    }
}

extension MonthlyCalendarCollectionView: UICollectionViewDelegate {
    
}

extension MonthlyCalendarCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item % 6 == 0 {
            for index in 0..<scheduleContainerViews.count {
                updateScheduleLineContainerConstraint(index: index)
            }
        }

        return CGSize(width: collectionView.frame.size.width / 7, height: collectionView.frame.size.height / 6)
    }

    private func updateScheduleLineContainerConstraint(index: Int) {
        let cellHeight: CGFloat = collectionView.frame.size.height / 6
        let topConstant: CGFloat = 26 + (cellHeight * CGFloat(index))
        NSLayoutConstraint.activate([
            scheduleContainerViews[index].topAnchor.constraint(equalTo: weekDayView.bottomAnchor, constant: topConstant)
        ])
    }
}
