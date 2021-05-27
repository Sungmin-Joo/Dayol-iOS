//
//  DatePickerModalViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/05/27.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let modalHeight: CGFloat = 300
}

final class DatePickerModalViewController: DYModalViewController {
    private var month: String?
    private var year: String?
    private let disposeBag = DisposeBag()

    private let datePickerView: DatePickerView = {
        let pickerView = DatePickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerView
    }()

    private let datePickerHeaderView: DatePickerHeaderView = {
        let headerView = DatePickerHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false

        return headerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        bind()
    }
    
    init() {
        let config = DYModalConfiguration(dimStyle: .clear, modalStyle: .custom(containerHeight: Design.modalHeight))
        super.init(configure: config)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        titleView = datePickerHeaderView
        contentView = datePickerView
    }

    private func bind() {
        Observable.combineLatest(datePickerView.didSelectYear, datePickerView.didSelectMonth)
            .subscribe(onNext: { [weak self] year, month in
                self?.month = month
                self?.year = year

                print("\(self?.year) - \(self?.month)")
            })
            .disposed(by: disposeBag)

        datePickerHeaderView.didTappedConfirmButton
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
