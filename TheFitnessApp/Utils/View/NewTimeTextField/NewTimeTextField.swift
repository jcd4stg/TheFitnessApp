//
//  NewTimeTextField.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 04/06/2024.
//

import UIKit

final class NewTimeTextField: UIView {
    weak var delegate: NewTimeTextFieldDelegate?
    
    private let minLabel = UILabel()
    private let minTF = TextField()
    
    private let secLabel = UILabel()
    private let secTF = TextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func set(with model: Model) {
        minTF.text = model.min.description
        secTF.text = model.sec.description
        
        if let inputView = minTF.inputView, let minPicker = inputView as? UIPickerView {
            minPicker.selectRow(model.min, inComponent: Tag.min.rawValue, animated: true)
        }
        
        if let inputView = secTF.inputView, let secPicker = inputView as? UIPickerView {
            secPicker.selectRow(model.sec / 5, inComponent: Tag.min.rawValue, animated: true)
        }
    }
    
    // MARK: Private
    private func setupView() {
        setupMinLabel()
        setupMinTF()
        setupSecLabel()
        setupSecTF()
    }
    
    private func setupMinLabel() {
        addSubview(minLabel)
        minLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let top = minLabel.topAnchor.constraint(equalTo: topAnchor)
        let leading = minLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        let width = minLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2)
        NSLayoutConstraint.activate([top, leading, width])
        
        minLabel.text = "min"
        minLabel.textColor = .customWhite
        minLabel.font = .boldSystemFont(ofSize: 24)
    }
    
    private func setupMinTF() {
        addSubview(minTF)
        minTF.translatesAutoresizingMaskIntoConstraints = false
        
        let top = minTF.topAnchor.constraint(equalTo: minLabel.bottomAnchor, constant: 10)
        let leading = minTF.leadingAnchor.constraint(equalTo: minLabel.leadingAnchor)
        let height = minTF.heightAnchor.constraint(equalToConstant: 60)
        let width = minTF.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2)
        let bottom = minTF.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([top, leading, width, height, bottom])
        
        minTF.text = "0"
        minTF.font = .boldSystemFont(ofSize: 28)
        minTF.textColor = .customWhite
        minTF.isActionsEnabled = false
        
        let minPicker = UIPickerView()
        minPicker.tag = Tag.min.rawValue
        minPicker.dataSource = self
        minPicker.delegate = self
        minTF.inputView = minPicker
        
        minTF.inputAccessoryView = buildToolBar()

    }
    
    private func setupSecLabel() {
        addSubview(secLabel)
        secLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let top = secLabel.topAnchor.constraint(equalTo: minLabel.topAnchor)
        let leading = secLabel.leadingAnchor.constraint(equalTo: minLabel.trailingAnchor)
        let width = secLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2)
        NSLayoutConstraint.activate([top, leading, width])
        
        secLabel.text = "sec"
        secLabel.textColor = .customWhite
        secLabel.font = .boldSystemFont(ofSize: 24)
    }
    
    private func setupSecTF() {
        addSubview(secTF)
        secTF.translatesAutoresizingMaskIntoConstraints = false
        
        let top = secTF.topAnchor.constraint(equalTo: secLabel.bottomAnchor, constant: 10)
        let leading = secTF.leadingAnchor.constraint(equalTo: minTF.trailingAnchor)
        let height = secTF.heightAnchor.constraint(equalToConstant: 60)
        let width = secTF.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2)
        let bottom = secTF.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([top, leading, width, height, bottom])
        
        secTF.text = "0"
        secTF.font = .boldSystemFont(ofSize: 28)
        secTF.textColor = .customWhite
        secTF.isActionsEnabled = false
        
        let secPicker = UIPickerView()
        secPicker.tag = Tag.sec.rawValue
        secPicker.dataSource = self
        secPicker.delegate = self
        
        secTF.inputView = secPicker
        secTF.inputAccessoryView = buildToolBar()
    }
    
    // MARK: - Action
    @objc private func doneAction() {
        endEditing(true)
    }
    
    // MARK: - Logic
    
    private func buildToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        let btn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction))
        
        let flexibleSpaces = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolBar.setItems([flexibleSpaces, btn], animated: true)
        toolBar.isTranslucent = false
        toolBar.sizeToFit()
        return toolBar
    }
    
    private func handleValueHaveChanged() {
        guard let minText = minTF.text, let secText = secTF.text else {
            return
        }
        
        let min = Int(minText) ?? 0
        let sec = Int(secText) ?? 0
        
        if let delegate = delegate {
            delegate.valueHaveChanged(to: min, sec: sec)
        } else {
            print("No delegate was assigned for \(self)")
        }
    }
}

// MARK: - UIPickerViewDataSource

extension NewTimeTextField: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case Tag.min.rawValue: return 61
        case Tag.sec.rawValue: return 12
        default: return 0
        }
    }
}

// MARK: - UIPickerViewDelegate

extension NewTimeTextField: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case Tag.min.rawValue: return row.description
        case Tag.sec.rawValue: return (row * 5).description
        default: return 0.description
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case Tag.min.rawValue: minTF.text = row.description
        case Tag.sec.rawValue: secTF.text = (row * 5).description
        default: return
        }
        
        handleValueHaveChanged()
    }
}

extension NewTimeTextField {
    struct Model {
        let min: Int
        let sec: Int
    }
}



