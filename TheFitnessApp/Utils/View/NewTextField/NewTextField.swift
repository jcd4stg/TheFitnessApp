//
//  NewTextFieldswift.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 02/06/2024.
//

import UIKit

final class NewTextField: UIView {
    weak var delegate: NewTextFieldDelegate?
    
    private let titleLabel = UILabel()
    private let nameTF = TextField()
        
    init(title: String) {
        self.titleLabel.text = title
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func set(name: String) {
        nameTF.text = name
    }
 
    func disable() {
        nameTF.text = "Pause"
        nameTF.isEnabled = false
        nameTF.textColor = .lightGray
    }
    
    func enable() {
        nameTF.text = ""
        nameTF.isEnabled = true
        nameTF.textColor = .customWhite
    }
    
    // MARK: - Private
    
    private func setupView() {
        setupTitleLabel()
        setupNameTextField()
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let top = titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30)
        let leading = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        NSLayoutConstraint.activate([top, leading, trailing])
        
        titleLabel.textColor = .customWhite
        titleLabel.font = .boldSystemFont(ofSize: 24)
    }
    
    private func setupNameTextField() {
        addSubview(nameTF)
        nameTF.translatesAutoresizingMaskIntoConstraints = false
        
        let top = nameTF.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        let leading = nameTF.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        let trailing = nameTF.trailingAnchor.constraint(equalTo: trailingAnchor)
        let height = nameTF.heightAnchor.constraint(equalToConstant: 60)
        let bottom = nameTF.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([top, leading, trailing, height, bottom])
        
        nameTF.layer.cornerRadius = 10
        nameTF.font = .boldSystemFont(ofSize: 28)
        nameTF.textColor = .customWhite
        
        nameTF.returnKeyType = .done
        nameTF.addTarget(self, action: #selector(textFieldAction), for: .editingChanged)
    }
    
    @objc private func textFieldAction(_ textField: UITextField) {
        guard let delegate = delegate else  {
            print("⚠️ No delegate set for \(self)")
            return
        }
        delegate.valueDidChange(to: textField.text ?? "")

    }
}

// MARK: - UITextFieldDelegate
extension NewTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
    }
}


