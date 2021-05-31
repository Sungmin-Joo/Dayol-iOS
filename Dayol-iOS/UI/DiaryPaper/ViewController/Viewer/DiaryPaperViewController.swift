//
//  DiaryPaperViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/10.
//

import UIKit
import Combine
import RxSwift

enum DiaryPaperEventType {
    case showDatePicker
}

class DiaryPaperViewController: UIViewController {
    let didReceivedEvent = PublishSubject<DiaryPaperEventType>()
    let index: Int
    let scaleSubject = PassthroughSubject<CGFloat, Error>()
    let viewModel: DiaryPaperViewModel

    private var cancellable = [AnyCancellable]()
    private var paperHeight = NSLayoutConstraint()
    private let disposeBag = DisposeBag()

    private var scaleVariable: CGFloat {
        let paperStyle = viewModel.paper.paperStyle
        if isPadDevice {
            switch paperStyle {
            case .vertical:
                return paperScrollView.frame.height / paperStyle.size.height
            case .horizontal:
                return paperScrollView.frame.width / paperStyle.size.width
            }
        } else {
            return paperScrollView.frame.width / paperStyle.size.width
        }
    }

    lazy var paper = PaperPresentView(paper: viewModel.paper, count: viewModel.numberOfPapers)
    
    private let paperScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    init(index: Int, viewModel: DiaryPaperViewModel) {
        self.index = index
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scaleSubject.send(scaleVariable)
    }
    
    private func initView() {
        paper.translatesAutoresizingMaskIntoConstraints = false
        
        paperScrollView.delegate = self
        paperScrollView.minimumZoomScale = 1.0
        paperScrollView.maximumZoomScale = 3.0
        view.addSubViewPinEdge(paperScrollView)
        paperScrollView.addSubViewPinEdge(paper)
        paperScrollView.isPagingEnabled = true
        view.backgroundColor = UIColor(decimalRed: 246, green: 248, blue: 250)
        
        setupConstraint()
        combine()
        setupConstraint()
        paperActionBind()
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            paper.widthAnchor.constraint(equalTo: paperScrollView.widthAnchor)
        ])
    }
    
    private func combine() {
        let scaleCombine = scaleSubject.sink { error in
            // do Something
        } receiveValue: { [weak self] value in
            guard let self = self else { return }
            self.paper.scaleForFit = value
        }

        cancellable.append(scaleCombine)
    }
}

extension DiaryPaperViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return paper
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        paperScrollView.isPagingEnabled = (scrollView.zoomScale == 1.0)
    }
}

extension DiaryPaperViewController {
    func paperActionBind() {
        paper.showDatePicker
            .observe(on:MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.didReceivedEvent.onNext(.showDatePicker)
            })
            .disposed(by: disposeBag)
    }
}
