//
//  TrailViewController.swift
//  IthacaTrails2
//
//  Created by Justin Gu on 12/7/20.
//
import UIKit

class TrailViewController: UIViewController {
    
    var gl:CAGradientLayer!
    
    private var trail: Trail!
    private let trailImageView = UIImageView()
    private let nameLabel = UILabel()
    private let latitudeLabel = UILabel()
    private let longitudeLabel = UILabel()
    private let lengthLabel = UILabel()
    private let ratingLabel = UILabel()
    private let difficultyLabel = UILabel()
    private let activitiesLabel = UILabel()
    private let reviewContainerView = UIView()
    private let reviewsButton = UIButton()
    private let descriptionText = UITextView()

    init(trail: Trail) {
        super.init(nibName: nil, bundle: nil)
        self.trail = trail
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor(red: 171.0/255.0, green: 189.0/255.0, blue: 162.0/255.0, alpha: 0.22)
        let color2 = UIColor(red: 171.0/255.0, green: 189.0/255.0, blue: 162.0/255.0, alpha: 1)
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 54.0/255.0, green: 93.0/255.0, blue: 85.0/255.0, alpha: 1)
        getTrail()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        
        // set up views for trail image
        let photoURL = URL(string: trail.imageUrl)
        // this downloads the image asynchronously if it's not cached yet
        trailImageView.kf.setImage(with: photoURL)
        trailImageView.translatesAutoresizingMaskIntoConstraints = false
        trailImageView.contentMode = .scaleAspectFill
        trailImageView.layer.masksToBounds = true
        trailImageView.alpha = 0.7
        view.addSubview(trailImageView)
        
        // set up views for name label
        nameLabel.text = trail.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont(name: "Papyrus", size: 30)
        nameLabel.textColor = .white
        view.addSubview(nameLabel)
        
        // set up views for latitude label
        latitudeLabel.text = "Latitude: " + String(trail.latitude)
        latitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        latitudeLabel.numberOfLines = 0
        latitudeLabel.font = UIFont(name: "Papyrus", size: 15)
        latitudeLabel.textColor = .white
        view.addSubview(latitudeLabel)
        
        // set up views for longitude label
        longitudeLabel.text = "Longitude: " + String(trail.longitude)
        longitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        longitudeLabel.numberOfLines = 0
        longitudeLabel.font = UIFont(name: "Papyrus", size: 15)
        longitudeLabel.textColor = .white
        view.addSubview(longitudeLabel)
        
        // set up views for length label
        lengthLabel.text = "Length: " + String(trail.length) + " Miles"
        lengthLabel.translatesAutoresizingMaskIntoConstraints = false
        lengthLabel.numberOfLines = 0
        lengthLabel.font = UIFont(name: "Papyrus", size: 15)
        lengthLabel.textColor = .white
        view.addSubview(lengthLabel)
        
//        // set up views for rating label
        ratingLabel.text = "Rating: " + String(trail.rating)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.numberOfLines = 0
        ratingLabel.font = UIFont(name: "Papyrus", size: 15)
        ratingLabel.textColor = .white
        view.addSubview(ratingLabel)
        
        // set up views for difficulty label
        difficultyLabel.text = "Difficulty: " + trail.difficulty
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        difficultyLabel.numberOfLines = 0
        difficultyLabel.font = UIFont(name: "Papyrus", size: 15)
        difficultyLabel.textColor = .white
        view.addSubview(difficultyLabel)
        
        // set up views for activity label
        if let activities = trail.activities{
            activitiesLabel.text = "Activities: " + getActivitiesText(activities: activities)
        }
        activitiesLabel.translatesAutoresizingMaskIntoConstraints = false
        activitiesLabel.numberOfLines = 0
        activitiesLabel.font = UIFont(name: "Papyrus", size: 15)
        activitiesLabel.textColor = .white
        view.addSubview(activitiesLabel)
        
        // set up views for review container
        reviewContainerView.backgroundColor = UIColor(red: 168.0/255.0, green: 139.0/255.0, blue: 78.0/255.0, alpha: 1)
        reviewContainerView.layer.cornerRadius = 35
        reviewContainerView.sizeToFit()
        reviewContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(reviewContainerView)
        
        // set up views for review button
        reviewsButton.translatesAutoresizingMaskIntoConstraints = false
        reviewsButton.addTarget(self, action: #selector(seeAllReviews), for: .touchUpInside)
        reviewsButton.titleLabel?.font = UIFont(name: "Papyrus", size: 30)
        reviewsButton.setTitleColor(.white, for: .normal)
        reviewsButton.setTitle("Reviews", for: .normal)
        reviewsButton.alpha = 0.75
        view.addSubview(reviewsButton)
        
        // set up views for description label
        descriptionText.text = trail.description
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.isEditable = false
        descriptionText.isScrollEnabled = true
        descriptionText.isUserInteractionEnabled = true
        descriptionText.frame = CGRect(x: 10, y: 10, width: self.view.frame.width, height: 100)
        descriptionText.font = UIFont(name: "Papyrus", size: 15)
        descriptionText.backgroundColor = UIColor(red: 54.0/255.0, green: 93.0/255.0, blue: 85.0/255.0, alpha: 0.2)
        descriptionText.textColor = .white
        view.addSubview(descriptionText)
    }
    
    @objc func seeAllReviews() {
        if let reviews = trail.reviews {
            let reviewViewController = ReviewViewController(reviews: reviews, trail: trail)
            navigationController?.pushViewController(reviewViewController, animated: true)
        }
    }
    
    func setupConstraints() {
        let padding: CGFloat = 10
        
        // set up constraints for trail image
        NSLayoutConstraint.activate([
            trailImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trailImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trailImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // set up constraints for name label
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150 + padding),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // set up constraints for latitude label
        NSLayoutConstraint.activate([
            latitudeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding),
            latitudeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // set up constraints for longitude label
        NSLayoutConstraint.activate([
            longitudeLabel.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: padding),
            longitudeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // set up constraints for length label
        NSLayoutConstraint.activate([
            lengthLabel.topAnchor.constraint(equalTo: longitudeLabel.bottomAnchor, constant: padding),
            lengthLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // set up constraints for rating label
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: lengthLabel.bottomAnchor, constant: padding),
            ratingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // set up constraints for difficulty label
        NSLayoutConstraint.activate([
            difficultyLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: padding),
            difficultyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // set up constraints for activities label
        NSLayoutConstraint.activate([
            activitiesLabel.topAnchor.constraint(equalTo: difficultyLabel.bottomAnchor, constant: padding),
            activitiesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // set up constraints for description text
        NSLayoutConstraint.activate([
            descriptionText.topAnchor.constraint(equalTo: activitiesLabel.bottomAnchor, constant: padding),
            descriptionText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding/2),
            descriptionText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding/2),
            descriptionText.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // set up constraints for review container
        NSLayoutConstraint.activate([
            reviewContainerView.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 2 * padding),
            reviewContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reviewContainerView.heightAnchor.constraint(equalToConstant: 80),
            reviewContainerView.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        // set up constraints for review button
        NSLayoutConstraint.activate([
            reviewsButton.topAnchor.constraint(equalTo: reviewContainerView.topAnchor, constant: padding),
            reviewsButton.leadingAnchor.constraint(equalTo: reviewContainerView.leadingAnchor, constant: padding),
            reviewsButton.trailingAnchor.constraint(equalTo: reviewContainerView.trailingAnchor, constant: -padding),
            reviewsButton.bottomAnchor.constraint(equalTo: reviewContainerView.bottomAnchor, constant: -padding)
        ])
    }
    
    private func getTrail() {
        NetworkManager.getTrail(id: trail.id) { trail in
            self.trail = trail
        }
    }
    
    private func getActivitiesText(activities: [Activity]) -> String {
        var activitynames: [String] = []
        for activ in activities {
            activitynames.append(activ.name)
        }
        return activitynames.joined(separator: ", ")
    }
}
