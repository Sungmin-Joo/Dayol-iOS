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
    
    private var paper: PaperModel
    private let numberOfPapers: Int
    private var contentTop = NSLayoutConstraint()
    private var contentBottom = NSLayoutConstraint()
    private var disposeBag = DisposeBag()
    private let flexibleSize: Bool

    let showPaperSelect = PublishSubject<Void>()
    let showAddSchedule = PublishSubject<Date>()
    
    var scaleForFit: CGFloat = 0.0 {
        didSet {
            let scale = CGAffineTransform(scaleX: self.scaleForFit, y: self.scaleForFit)
            self.tableView.transform = scale
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
    
    private let drawingContentView: DrawingContentView = {
        // TODO: - 아마 canvas 뷰로 대체
        let view = DrawingContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let stickerContentView: StickerContentView = {
        let view = StickerContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(paper: PaperModel, count: Int = 1, flexibleSize: Bool = false) {
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

    // MARK: - Init
    
    private func initView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        reginterIdentifier()
        
        setupPaperBorder()

        addSubview(tableView)
        tableView.addSubViewPinEdge(drawingContentView)
        tableView.addSubViewPinEdge(stickerContentView)
        
        setupConstraint()
    }

    private func thumbnailBind() {
        Observable<Int>
            .interval(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let cell = self.tableView.cellForRow(at: IndexPath.init(item: 0, section: 0))
                else { return }
                let thumbnail = cell.asImage()
                DYTestData.shared.addPaperThumbnail(id: self.paper.id, thumbnail: thumbnail)
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
                tableView.widthAnchor.constraint(equalToConstant: style.size.width),
                tableView.heightAnchor.constraint(equalToConstant: height)
            ])
        }
    }
    
    private func reginterIdentifier() {
        tableView.register(BasePaper.self, forCellReuseIdentifier: BasePaper.className)
        tableView.register(MujiPaper.self, forCellReuseIdentifier: MujiPaper.className)
        tableView.register(DailyPaper.self, forCellReuseIdentifier: DailyPaper.className)
        tableView.register(GridPaper.self, forCellReuseIdentifier: GridPaper.className)
        tableView.register(CornellPaper.self, forCellReuseIdentifier: CornellPaper.className)
        tableView.register(FourPaper.self, forCellReuseIdentifier: FourPaper.className)
        tableView.register(WeeklyCalendarView.self, forCellReuseIdentifier: WeeklyCalendarView.className)
        tableView.register(MonthlyCalendarView.self, forCellReuseIdentifier: MonthlyCalendarView.className)
    }
    
    private func setupPaperBorder() {
        layer.borderWidth = 1
        layer.borderColor = CommonPaperDesign.borderColor.cgColor
    }
}

extension PaperPresentView {
    var style: PaperStyle { paper.paperStyle }
    var height: CGFloat { paper.paperStyle.size.height * CGFloat(numberOfPapers) }
}

extension PaperPresentView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return style.size.height
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
        switch paper.paperType {
        case .monthly(date: let date):
            let cell = tableView.dequeueReusableCell(MonthlyCalendarView.self, for: indexPath)
            let viewModel = MonthlyCalendarViewModel(date: date)
            cell.configure(viewModel: viewModel, paperStyle: paper.paperStyle)
            cell.showSelectPaper
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] in
                    self?.showPaperSelect.onNext(())
                })
                .disposed(by: cell.disposeBag)

            cell.showAddSchedule
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] date in
                    self?.showAddSchedule.onNext(date)
                })
                .disposed(by: cell.disposeBag)

            return cell
        case .weekly(date: let date):
            let cell = tableView.dequeueReusableCell(WeeklyCalendarView.self, for: indexPath)
            let viewModel = WeeklyCalendarViewModel(date: date)
            cell.configure(viewModel: viewModel, paperStyle: paper.paperStyle)

            return cell
        case .daily(date: let date):
            let cell = tableView.dequeueReusableCell(DailyPaper.self, for: indexPath)
            let viewModel = DailyPaperViewModel(date: date, drawModel: DrawModel())

            cell.configure(viewModel: viewModel, paperStyle: paper.paperStyle)

            return cell
        case .four:
            let cell = tableView.dequeueReusableCell(FourPaper.self, for: indexPath)
            let viewModel = PaperViewModel(drawModel: DrawModel())

            cell.configure(viewModel: viewModel, paperStyle: paper.paperStyle)

            return cell
        case .grid:
            let cell = tableView.dequeueReusableCell(GridPaper.self, for: indexPath)
            let viewModel = PaperViewModel(drawModel: DrawModel())

            cell.configure(viewModel: viewModel, paperStyle: paper.paperStyle)

            return cell
        case .cornell:
            let cell = tableView.dequeueReusableCell(CornellPaper.self, for: indexPath)
            let viewModel = PaperViewModel(drawModel: DrawModel())

            cell.configure(viewModel: viewModel, paperStyle: paper.paperStyle)

            return cell
        case .tracker:
            let cell = tableView.dequeueReusableCell(BasePaper.self, for: indexPath)
            let viewModel = PaperViewModel(drawModel: DrawModel())

            cell.configure(viewModel: viewModel, paperStyle: paper.paperStyle)

            return cell
        case .muji:
            let cell = tableView.dequeueReusableCell(MujiPaper.self, for: indexPath)
            let viewModel = PaperViewModel(drawModel: DrawModel())

            cell.configure(viewModel: viewModel, paperStyle: paper.paperStyle)

            return cell
        }
    }
}
