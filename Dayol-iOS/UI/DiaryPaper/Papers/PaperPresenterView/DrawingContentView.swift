//
//  DrawingContentView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/18.
//

import UIKit
import PencilKit
import RxSwift

class DrawingContentView: UIView {
    private let disposeBag = DisposeBag()
    private let canvas = PKCanvasView()
    let currentToolSubject = BehaviorSubject<DYDrawTool?>(value: nil)

    init() {
        super.init(frame: .zero)
        initView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func initView() {
        canvas.backgroundColor = .clear
        addSubViewPinEdge(canvas)
    }

    private func bindEvent() {
        currentToolSubject.bind { [weak self] tool in
            guard let pkTool = tool?.pkTool else {
                self?.canvas.isUserInteractionEnabled = false
                return
            }
            self?.canvas.isUserInteractionEnabled = true
            self?.canvas.tool = pkTool
        }
        .disposed(by: disposeBag)
    }
}
