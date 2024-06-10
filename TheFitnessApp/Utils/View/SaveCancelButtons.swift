//
//  SaveCancelButtons.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 27/05/2024.
//

import UIKit

final class SaveCancelButtons: UIView {
    weak var delegate: SaveCancelButtonsDelegate?
    
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
    
    // MARK: - Private
    
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
        cancelButton.titleLabel?.font = .boldSystemFont(ofSize: 26)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    }
    
    private func setupSaveButton() {
        stackView.addArrangedSubview(saveButton)
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.customGreen, for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 26)
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)

    }
    
    // MARK: - Action
    
    @objc private func cancelAction() {
        if let delegate = delegate {
            delegate.onCancel()
        }
    }
    
    @objc private func saveAction() {
        if let delegate = delegate {
            delegate.onSave()
        }
    }
}

protocol SaveCancelButtonsDelegate: AnyObject {
    func onCancel()
    func onSave()
}
