//
//  ExerciseCell.swift
//  TheFitnessApp
//
//  Created by lynnguyen on 01/06/2024.
//

import UIKit

final class ExerciseCell: UITableViewCell {
    private let containerView = ContainerView()
    private let titleLabel = UILabel()
    private let minLabel = LabelWithPostfix(
        labelSize: 16,
        postFixSize: 16,
        baseLineAdjustent: 0,
        display: .capital
    )
    private let secLabel = LabelWithPostfix(
        labelSize: 16,
        postFixSize: 16,
        baseLineAdjustent: 0,
        display: .capital
    )

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    func set(model: ExerciseModel) {
        titleLabel.text = model.title
        let minLabelModel = LabelWithPostfix.Model(title: model.min.description, postFix: .minutes)
        minLabel.set(model: minLabelModel)
        
        let secLabelModel = LabelWithPostfix.Model(title: model.sec.description, postFix: .seconds)
        secLabel.set(model: secLabelModel)
    }
    
    // set function that will also set the timeLabel etc
    
    // MARK: - Private
    
    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        
        setupContainerView()
        setupNameLabel()
        setupMinLabel()
        setupSecLabel()
       
    }
    
    private func setupContainerView() {
        addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let top = containerView.topAnchor.constraint(equalTo: topAnchor, constant: 15)
        let leading = containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
        let bottom = containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        let trailing = containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        NSLayoutConstraint.activate([top, leading, bottom, trailing])
    }
    
    private func setupNameLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let top = titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15)
        let leading = titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30)
        let trailing = titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30)
        NSLayoutConstraint.activate([top, leading, trailing])
        
        titleLabel.textColor = .customWhite
        titleLabel.font = .systemFont(ofSize: 32)
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupMinLabel() {
        containerView.addSubview(minLabel)
        minLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let top = minLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        let leading = minLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30)
        let bottom = minLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
        NSLayoutConstraint.activate([top, leading, bottom])
    }
    
    private func setupSecLabel() {
        containerView.addSubview(secLabel)
        secLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let top = secLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        let leading = secLabel.leadingAnchor.constraint(equalTo: minLabel.trailingAnchor, constant: 15)
        let bottom = minLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        NSLayoutConstraint.activate([top, leading, bottom])
    }
    
   
}
