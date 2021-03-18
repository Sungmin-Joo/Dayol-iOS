//
//  PaperPresentView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/26.
//

import UIKit

class PaperPresentView: UITableView {
    
    // MARK: - Properties
    
    private let paperStyle: PaperStyle
    private var scaleToFit: CGFloat {
        switch Orientation.currentState {
        case .portrait:
            switch paperStyle {
            case .vertical:
                return frame.height / paperStyle.paperHeight
            case .horizontal:
                return frame.width / paperStyle.paperWidth
            }
        case .landscape:
            switch paperStyle {
            case .vertical:
                return frame.height / paperStyle.paperHeight
            case .horizontal:
                return frame.width / paperStyle.paperWidth
            }
        default: return 0.0
        }
    }

    // MARK: - UI
    
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
    
    init(paperStyle: PaperStyle) {
        self.paperStyle = paperStyle
        super.init(frame: .zero, style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init
    
    private func initView() {
        setupPaperBorder()
        addSubViewPinEdge(drawingContentView)
        addSubViewPinEdge(stickerContentView)
    }
    
    private func setupPaperBorder() {
        layer.borderWidth = 1
        layer.borderColor = CommonPaperDesign.borderColor.cgColor
    }
}

extension PaperPresentView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var contentOffset = scrollView.contentOffset

        if contentOffset.y < 0 {
            contentOffset.y = 0
        }
    }
}

extension PaperPresentView: UITableViewDelegate {
    
}

extension PaperPresentView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
