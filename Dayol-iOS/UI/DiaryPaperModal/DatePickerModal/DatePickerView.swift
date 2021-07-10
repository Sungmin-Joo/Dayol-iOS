//
//  DatePickerView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/05/27.
//

import UIKit
import RxSwift
import RxCocoa

private enum Constant {
    static let year = 0
    static let month = 1
    static let monthes: [Int] =  [0, 1, 2, 3, 4, 5, 6, 7, 8, 8, 10, 11]
}

final class DatePickerView: UIView {
    private let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerView
    }()

    let didSelectYear = BehaviorSubject<String?>(value: "")
    let didSelectMonth =  BehaviorSubject<String?>(value: "")
    let years = [Date.now.year(add: -1).string(with: .year), Date.now.year().string(with: .year), Date.now.year(add: 1).string(with: .year)]

    init() {
        super.init(frame: .zero)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        addSubview(pickerView)
        setupPickerView()
        setupConstraints()
        setupSubjects()
    }
    
    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self

    }

    private func setupSubjects() {
        didSelectYear.onNext(years[1])
        didSelectMonth.onNext(String(Constant.monthes[0] + 1))
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: topAnchor),
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension DatePickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == Constant.year {
            return 3
        } else {
            return 12
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == Constant.year {
            return years[row]
        } else {
            return Month.allCases.first { $0 == Month(rawValue: Constant.monthes[row]) }?.asString
        }
    }
}

extension DatePickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == Constant.year {
            didSelectYear.onNext(years[row])
        } else {
            didSelectMonth.onNext(String(Constant.monthes[row] + 1))
        }
    }
}
