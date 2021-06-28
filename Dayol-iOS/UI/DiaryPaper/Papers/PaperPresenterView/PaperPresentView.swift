//
//  PaperPresentView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/26.
//

import UIKit
import Combine
import RxSwift

class PaperPresentView: UIView {
    
    // MARK: - Properties
    
    private var paper: Paper
    private let numberOfPapers: Int
    private var contentTop = NSLayoutConstraint()
    private var contentBottom = NSLayoutConstraint()
    private var disposeBag = DisposeBag()
    private let flexibleSize: Bool

    let showPaperSelect = PublishSubject<PaperType>()
    let showAddSchedule = PublishSubject<(Date, ScheduleModalType)>()
    
    var scaleForFit: CGFloat = 0.0 {
        didSet {
            let scale = CGAffineTransform(scaleX: self.scaleForFit, y: self.scaleForFit)
            self.tableView.transform = scale
            self.drawingContentView.transform = scale
            let constarintConstant: CGFloat = (self.height - self.tableView.frame.height) / 2
            self.contentTop.constant = -constarintConstant
            self.contentBottom.constant = constarintConstant
        }
    }
    
    // MARK: - UI
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    var drawingContentView: DrawingContentView = {
        let view = DrawingContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        
        return view
    }()

    init(paper: Paper, count: Int = 1, flexibleSize: Bool = false) {
        self.paper = paper
        self.numberOfPapers = count
        self.flexibleSize = flexibleSize
        super.init(frame: .zero)
        initView()
        thumbnailBind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawThumbnail()
    }

    // MARK: - Init
    
    private func initView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        reginterIdentifier()
        
        setupPaperBorder()

        addSubview(tableView)
        addSubview(drawingContentView)

        setupConstraint()
    }

    private func thumbnailBind() {
        Observable<Int>
            .interval(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.drawThumbnail()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupConstraint() {
        contentTop = tableView.topAnchor.constraint(equalTo: topAnchor)
        contentBottom = tableView.bottomAnchor.constraint(equalTo: bottomAnchor)

        if self.flexibleSize == false {
            NSLayoutConstraint.activate([
                contentTop, contentBottom,
                tableView.centerXAnchor.constraint(equalTo: centerXAnchor),
                tableView.widthAnchor.constraint(equalToConstant: size.width),
                tableView.heightAnchor.constraint(equalToConstant: height),

                drawingContentView.topAnchor.constraint(equalTo: tableView.topAnchor),
                drawingContentView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
                drawingContentView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
                drawingContentView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
            ])
        }
    }
    
    private func reginterIdentifier() {
        tableView.register(BasePaper.self, forCellReuseIdentifier: BasePaper.className)
        tableView.register(MujiPaper.self, forCellReuseIdentifier: MujiPaper.className)
        tableView.register(DailyPaper.self, forCellReuseIdentifier: DailyPaper.className)
        tableView.register(GridPaper.self, forCellReuseIdentifier: GridPaper.className)
        tableView.register(CornellPaper.self, forCellReuseIdentifier: CornellPaper.className)
        tableView.register(QuartetPaper.self, forCellReuseIdentifier: QuartetPaper.className)
        tableView.register(WeeklyCalendarView.self, forCellReuseIdentifier: WeeklyCalendarView.className)
        tableView.register(MonthlyCalendarView.self, forCellReuseIdentifier: MonthlyCalendarView.className)
    }
    
    private func setupPaperBorder() {
        layer.borderWidth = 1
        layer.borderColor = CommonPaperDesign.borderColor.cgColor
    }

    private func drawThumbnail() {
        let cell = self.tableView.cellForRow(at: IndexPath.init(item: 0, section: 0))
        let thumbnail = cell?.asImage()
        DYTestData.shared.addPaperThumbnail(id: self.paper.id, thumbnail: thumbnail)
    }

}

extension PaperPresentView {
    var orientaion: Paper.PaperOrientation {
        return Paper.PaperOrientation(rawValue: paper.orientation) ?? .portrait
    }

    var size: CGSize {
        return PaperOrientationConstant.size(orentantion: orientaion)
    }

    var height: CGFloat {
        return size.height * CGFloat(numberOfPapers)
    }
}

extension PaperPresentView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return size.height
    }
}

extension PaperPresentView: UITableViewDataSource {
    var numberOfSections: Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfPapers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let paperType = paper.type
        switch paperType {
        case .monthly:
            guard let date = paper.date else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(MonthlyCalendarView.self, for: indexPath)
            let viewModel = MonthlyCalendarViewModel(date: date)
            cell.configure(viewModel: viewModel, orientation: orientaion)
            cell.showSelectPaper
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    self?.showPaperSelect.onNext(.monthly)
                })
                .disposed(by: cell.disposeBag)

            cell.showAddSchedule
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] date in
                    self?.showAddSchedule.onNext((date, .monthly))
                })
                .disposed(by: cell.disposeBag)

            return cell
        case .weekly:
            guard let date = paper.date else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(WeeklyCalendarView.self, for: indexPath)
            let viewModel = WeeklyCalendarViewModel(date: date)
            cell.configure(viewModel: viewModel, orientation: orientaion)
            cell.showSelectPaper
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    self?.showPaperSelect.onNext(.weekly)
                })
                .disposed(by: cell.disposeBag)

            cell.showAddSchedule
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] date in
                    self?.showAddSchedule.onNext((date, .weekly))
                })
                .disposed(by: disposeBag)

            return cell
        case .daily:
            guard let date = paper.date else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(DailyPaper.self, for: indexPath)
            let viewModel = DailyPaperViewModel(date: date, drawModel: DrawModel())

            cell.configure(viewModel: viewModel, orientation: orientaion)

            return cell
        case .quartet:
            let cell = tableView.dequeueReusableCell(QuartetPaper.self, for: indexPath)
            let viewModel = PaperViewModel(drawModel: DrawModel())

            cell.configure(viewModel: viewModel, orientation: orientaion)

            return cell
        case .grid:
            let cell = tableView.dequeueReusableCell(GridPaper.self, for: indexPath)
            let viewModel = PaperViewModel(drawModel: DrawModel())

            cell.configure(viewModel: viewModel, orientation: orientaion)

            return cell
        case .cornell:
            let cell = tableView.dequeueReusableCell(CornellPaper.self, for: indexPath)
            let viewModel = PaperViewModel(drawModel: DrawModel())

            cell.configure(viewModel: viewModel, orientation: orientaion)

            return cell
        case .tracker:
            let cell = tableView.dequeueReusableCell(BasePaper.self, for: indexPath)
            let viewModel = PaperViewModel(drawModel: DrawModel())

            cell.configure(viewModel: viewModel, orientation: orientaion)

            return cell
        case .muji:
            let cell = tableView.dequeueReusableCell(MujiPaper.self, for: indexPath)
            let viewModel = PaperViewModel(drawModel: DrawModel())

            cell.configure(viewModel: viewModel, orientation: orientaion)

            return cell
        }
    }
}
