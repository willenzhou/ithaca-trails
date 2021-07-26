//
//  TrailTableViewCell.swift
//  IthacaTrails2
//
//  Created by Justin Gu on 12/7/20.
//

import UIKit
import Kingfisher
import Alamofire

class TrailTableViewCell: UITableViewCell {
    
    let containerView = UIView()
    let nameLabel = UILabel()
    let lengthLabel = UILabel()
    let difficultyLabel = UILabel()
    let activityLabel = UILabel()
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(red: 54.0/255.0, green: 93.0/255.0, blue: 85.0/255.0, alpha: 0.5)
        selectionStyle = .none
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        // views for containerView
        containerView.layer.cornerRadius = 20
        containerView.layer.backgroundColor = CGColor(red: 54.0/255.0, green: 93.0/255.0, blue: 85.0/255.0, alpha: 1)
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // set up views for containerView background image
//        backgroundImage.image = UIImage(named: "generic.jpg")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        backgroundImage.alpha = 0.3
        containerView.insertSubview(backgroundImage, at: 0)

        // views for name label
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "Papyrus", size: 30)
        containerView.addSubview(nameLabel)
        
        // views for length label
        lengthLabel.textColor = .white
        lengthLabel.translatesAutoresizingMaskIntoConstraints = false
        lengthLabel.font = UIFont(name: "Papyrus", size: 15)
        containerView.addSubview(lengthLabel)
        
        // views for difficulty label
        difficultyLabel.textColor = .white
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        difficultyLabel.textAlignment = .right
        difficultyLabel.font = UIFont(name: "Papyrus", size: 15)
        containerView.addSubview(difficultyLabel)
        
        // views for activity label
        activityLabel.textColor = .white
        activityLabel.translatesAutoresizingMaskIntoConstraints = false
        activityLabel.font = UIFont(name: "Papyrus", size: 15)
        containerView.addSubview(activityLabel)
    }
    
    func setupConstraints() {
        let containerPadding: CGFloat = 20
        let padding: CGFloat = 10
        
        // constraints for container
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: containerPadding),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -containerPadding),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: containerPadding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -containerPadding)
        ])
        
        // constraints for name label
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 80),
            nameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // constraints for length label
        NSLayoutConstraint.activate([
            lengthLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding/2),
            lengthLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            lengthLabel.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -15)
        ])
        
        // constraints for difficulty label
        NSLayoutConstraint.activate([
            difficultyLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding/2),
            difficultyLabel.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 15),
            difficultyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])
        
        // constraints for activity label
        NSLayoutConstraint.activate([
            activityLabel.topAnchor.constraint(equalTo: lengthLabel.bottomAnchor, constant: padding/2),
            activityLabel.leadingAnchor.constraint(equalTo: lengthLabel.leadingAnchor),
            activityLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            activityLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding/2),
        ])
    }
    
    private func getActivitiesText(activities: [Activity]) -> String {
        var activitynames: [String] = []
        for activ in activities {
            activitynames.append(activ.name)
        }
        return activitynames.joined(separator: ", ")
    }
    
    func configure(for trail : Trail) {
        let photoURL = URL(string: (trail.imageUrl))
        backgroundImage.kf.setImage(with: photoURL)
        nameLabel.text = trail.name
        lengthLabel.text = String(trail.length) + " Miles"
        difficultyLabel.text = trail.difficulty
        if let activities = trail.activities {
            activityLabel.text = getActivitiesText(activities: activities)
        }
    }
    
}
