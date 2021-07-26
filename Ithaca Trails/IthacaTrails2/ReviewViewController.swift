//
//  ReviewViewController.swift
//  IthacaTrails2
//
//  Created by Willen Zhou on 12/13/20.
//

import UIKit

protocol SaveReviewDelegate: class {
    func saveReview(review: Review)
}

class ReviewViewController: UIViewController {
    
    private let reviewsTableView = UITableView()
    private let reviewsTableViewReuseIdentifier = "ReviewsTableViewReuseIdentifier"
    private var reviews: [Review] = []
    private let reviewLabel = UILabel()
    private var trail: Trail!
    private var addButton = UIButton()
    private let trailImageView = UIImageView()
    
    init(reviews: [Review], trail: Trail) {
        super.init(nibName: nil, bundle: nil)
        self.reviews = reviews
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

        view.backgroundColor = UIColor(red: 54.0/255.0, green: 93.0/255.0, blue: 85.0/255.0, alpha: 1)
        getReviews()
        
        // set up views for trail image
        let photoURL = URL(string: trail.imageUrl)
        // this downloads the image asynchronously if it's not cached yet
        trailImageView.kf.setImage(with: photoURL)
        trailImageView.translatesAutoresizingMaskIntoConstraints = false
        trailImageView.contentMode = .scaleAspectFill
        trailImageView.layer.masksToBounds = true
        trailImageView.alpha = 0.7
        view.addSubview(trailImageView)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(reviewAddModal), for: .touchUpInside)
        addButton.titleLabel?.font = UIFont(name: "Papyrus", size: 30)
        addButton.setTitleColor(.white, for: .normal)
        addButton.backgroundColor = UIColor(red: 168.0/255.0, green: 139.0/255.0, blue: 78.0/255.0, alpha: 1)
        addButton.setTitle("Add", for: .normal)
        view.addSubview(addButton)
    
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        reviewsTableView.rowHeight = UITableView.automaticDimension
        reviewsTableView.estimatedRowHeight = UITableView.automaticDimension
        reviewsTableView.translatesAutoresizingMaskIntoConstraints = false
        reviewsTableView.separatorStyle = .none
        reviewsTableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: reviewsTableViewReuseIdentifier)
        reviewsTableView.backgroundColor =
            UIColor(red: 54.0/255.0, green: 93.0/255.0, blue: 85.0/255.0, alpha: 0.2)
        view.addSubview(reviewsTableView)
        
        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewLabel.text = "Reviews"
        reviewLabel.font = UIFont(name: "Papyrus", size: 35)
        reviewLabel.textColor = UIColor(red: 216.0/255.0, green: 237.0/255.0, blue: 231.0/255.0, alpha: 1)
        reviewLabel.numberOfLines = 0
        view.addSubview(reviewLabel)
        
        setupConstraints()
    }
    
    
    @objc func reviewAddModal() {
        let vc = PopupViewController(delegate: self, id: trail.id)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 20
        
        // set up constraints for trail image
        NSLayoutConstraint.activate([
            trailImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trailImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trailImageView.heightAnchor.constraint(equalToConstant: 265)
        ])
        
        NSLayoutConstraint.activate([
            reviewLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 370),
            reviewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 370),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
        
        NSLayoutConstraint.activate([
            reviewsTableView.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor, constant: padding),
            reviewsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            reviewsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding/2),
            reviewsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding/2)
        ])
    }
    
    private func getReviews() {
        NetworkManager.getReviews(id: trail.id) { reviews in
            self.reviews = reviews
            DispatchQueue.main.async {
                self.reviewsTableView.reloadData()
            }
        }
    }
}

extension ReviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reviewsTableViewReuseIdentifier, for: indexPath) as? ReviewTableViewCell else { return UITableViewCell() }
        let review = reviews[indexPath.row]
        cell.configure(with: review)
        return cell
    }
}

extension ReviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension ReviewViewController: SaveReviewDelegate {
    func saveReview(review: Review) {
        reviews.append(review)
        self.reviewsTableView.reloadData()
    }
}
