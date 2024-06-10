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
    private let baseLineAdjustent: CGFloat
    private let display: Display

    init(labelSize: CGFloat = 32, postFixSize: CGFloat = 16, baseLineAdjustent: CGFloat = -4, display: Display = .lowercase) {
        self.label.font = .boldSystemFont(ofSize: CGFloat(labelSize))
        self.postFixLabel.font = .boldSystemFont(ofSize: CGFloat(postFixSize))
        self.baseLineAdjustent = baseLineAdjustent
        self.display = display
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    func set(model: Model) {
        if let number = Int(model.title), number < 10 {
            label.text = "0\(number)"
        } else {
            label.text = model.title
        }
        
        var postFix = model.postFix.rawValue
        
        switch display {
        case .capital:
            postFix = postFix.uppercased()
        case .lowercase:
            postFix = postFix.lowercased()
        }
        postFixLabel.text = postFix
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
        let bottom = label.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([top, leading, bottom])
        
        label.textColor = .customRed
    }
    
    private func setupPostFixLabel() {
        addSubview(postFixLabel)
        postFixLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let bottom = postFixLabel.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: baseLineAdjustent)
        let leading = postFixLabel.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 3)
        let trailing = postFixLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        NSLayoutConstraint.activate([bottom, leading, trailing])
        
        postFixLabel.textColor = .lightDimmedBlue        
    }
}

extension LabelWithPostfix {
    struct Model {
        let title: String
        let postFix: Postfix
    }
    
    enum Postfix: String {
        case minutes
        case seconds
        case exercise
    }
    
    enum Display {
        case capital
        case lowercase
    }
}
