//
//  LabelWithPostfix.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 09/05/2024.
//

import UIKit

final class LabelWithPostfix: UIView {
    private let label = UILabel()
    private let postFixLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    func set(model: Model) {
        label.text = model.title
        postFixLabel.text = model.postFix.rawValue
    }
    
    // MARK: - Private
    private func setupView() {
        setupLabel()
        setupPostFixLabel()
    }
    
    private func setupLabel() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let top = label.topAnchor.constraint(equalTo: topAnchor)
        let leading = label.leadingAnchor.constraint(equalTo: leadingAnchor)
        NSLayoutConstraint.activate([top, leading])
        
        label.textColor = .customRed
        label.font = .boldSystemFont(ofSize: 32)
    }
    
    private func setupPostFixLabel() {
        addSubview(postFixLabel)
        postFixLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let bottom = postFixLabel.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: -4)
        let leading = postFixLabel.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 3)
        let trailing = postFixLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        NSLayoutConstraint.activate([bottom, leading, trailing])
        
        postFixLabel.textColor = .lightDimmedBlue
        postFixLabel.font = .boldSystemFont(ofSize: 16)
        
    }
}

extension LabelWithPostfix {
    struct Model {
        let title: String
        let postFix: Postfix
    }
    
    enum Postfix: String {
        case min
        case exercise
    }
}
