//
//  PaperPresentView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/26.
//

import UIKit

class PaperPresentView: UIView {
    
    // MARK: - Properties
    
    typealias PaperModel = DiaryInnerModel.PaperModel
    private let paper: PaperModel
    private let numberOfPapers: Int
    
    private var scaleForFit: CGFloat {
        switch Orientation.currentState {
        case .portrait:
            switch paperStyle {
            case .vertical:
                return frame.height / paperStyle.size.height
            case .horizontal:
                return frame.width / paperStyle.size.width
            }
        case .landscape:
            switch paperStyle {
            case .vertical:
                return frame.height / paperStyle.size.height
            case .horizontal:
                return frame.width / paperStyle.size.width
            }
        default: return 0.0
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
    
    init(paper: PaperModel, count: Int = 1) {
        self.paper = paper
        self.numberOfPapers = count
        super.init(frame: .zero)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.visibleCells.forEach { $0.contentView.transform = .init(scaleX: scaleForFit, y: scaleForFit) }
        tableView.reloadData()
    }
    
    // MARK: - Init
    
    private func initView() {
        tableView.delegate = self
        tableView.dataSource = self
        reginterIdentifier()
        
        setupPaperBorder()
        
        addSubViewPinEdge(drawingContentView)
        addSubViewPinEdge(stickerContentView)
        addSubViewPinEdge(tableView)
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
    var paperStyle: PaperStyle { paper.paperStyle }
}

extension PaperPresentView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return paperStyle.size.height * scaleForFit
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: paper.paperType.identifier, for: indexPath) as? BasePaper else { return UITableViewCell() }
        let baseViewModel = PaperViewModel(drawModel: DrawModel())
        
        cell.contentView.transform = .init(scaleX: scaleForFit, y: scaleForFit)
        
        if let mujiCell = cell as? MujiPaper {
            mujiCell.configure(viewModel: baseViewModel, paperStyle: paper.paperStyle)
            return mujiCell
        }
        
        if let dailyCell = cell as? DailyPaper {
            let dailyViewModel = DailyPaperViewModel(date: Date(), drawModel: DrawModel())
            dailyCell.configure(viewModel: dailyViewModel, paperStyle: paper.paperStyle)
            return dailyCell
        }
        
        if let gridCell = cell as? GridPaper {
            gridCell.configure(viewModel: baseViewModel, paperStyle: paper.paperStyle)
            return gridCell
        }
        
        if let cornelCell = cell as? CornellPaper {
            cornelCell.configure(viewModel: baseViewModel, paperStyle: paper.paperStyle)
            return cornelCell
        }
        
        if let fourCell = cell as? FourPaper {
            fourCell.configure(viewModel: baseViewModel, paperStyle: paper.paperStyle)
            return fourCell
        }
        
        if let weekCell = cell as? WeeklyCalendarView {
            let weekViewModel = WeeklyCalendarViewModel()
            weekCell.configure(viewModel: weekViewModel, paperStyle: paper.paperStyle)
            return weekCell
        }
        
        if let monthCell = cell as? MonthlyCalendarView {
            let monthViewModel = MonthlyCalendarViewModel()
            monthCell.configure(viewModel: monthViewModel, paperStyle: paper.paperStyle)
            return monthCell
        }
        
        return cell
    }
}
