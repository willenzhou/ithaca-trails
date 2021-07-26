//
//  ReviewTableViewCell.swift
//  IthacaTrails2
//
//  Created by Justin Gu on 12/13/20.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    private let containerView = UIView()
    private let reviewBody = UILabel()
    private let reviewUsername = UILabel()
    private let rating = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        containerView.backgroundColor = 
            UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        containerView.layer.cornerRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = true
        
        reviewBody.translatesAutoresizingMaskIntoConstraints = false
        reviewBody.font = UIFont(name: "Papyrus", size: 16)
        reviewBody.textColor = .black
        reviewBody.numberOfLines = 0
        containerView.addSubview(reviewBody)
        
        reviewUsername.translatesAutoresizingMaskIntoConstraints = false
        reviewUsername.font = UIFont(name: "Papyrus", size: 20)
        reviewUsername.textColor = .black
        reviewUsername.numberOfLines = 0
        containerView.addSubview(reviewUsername)
        
        rating.translatesAutoresizingMaskIntoConstraints = false
        rating.font = UIFont(name: "Papyrus", size: 20)
        rating.textColor = .black
        rating.numberOfLines = 0
        containerView.addSubview(rating)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with review: Review) {
        reviewBody.text = review.body
        reviewUsername.text = review.username
        rating.text = "Rating: \(review.rating)"
    }
    
    private func setupConstraints() {
        let containerPadding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: containerPadding),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -containerPadding),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: containerPadding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -containerPadding)
        ])
        
        NSLayoutConstraint.activate([
            reviewUsername.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            reviewUsername.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            reviewUsername.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            rating.topAnchor.constraint(equalTo: reviewUsername.topAnchor, constant: 30),
            rating.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            rating.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            reviewBody.topAnchor.constraint(equalTo: rating.bottomAnchor, constant: 40),
            reviewBody.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            reviewBody.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            reviewBody.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -60)
        ])
    }
}
