//
//  SaveCancelButtons.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 27/05/2024.
//

import UIKit

final class SaveCancelButton: UIView {
    private let stackView = UIStackView()
    private let cancelButton = UIButton()
    private let saveButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setupStackView()
        setupCancelButton()
        setupSaveButton()
    }
    
    private func setupStackView() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        let top = stackView.topAnchor.constraint(equalTo: topAnchor)
        let leading = stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        let bottom = stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([top, leading, trailing, bottom])

    }
    
    private func setupCancelButton() {
        stackView.addArrangedSubview(cancelButton)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.customRed, for: .normal)
    }
    
    private func setupSaveButton() {
        stackView.addArrangedSubview(saveButton)
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.customGreen, for: .normal)
    }
}
