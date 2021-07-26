//
//  PopupViewController.swift
//  IthacaTrails2
//
//  Created by Willen Zhou on 12/14/20.
//

import UIKit

class PopupViewController: UIViewController {

    private var usernameTextField = UITextField()
    private var bodyTextField = UITextField()
    private var ratingTextField = UITextField()
    private var container = UIView()
    private let addReviewButton = UIButton()
    private let closeButton = UIButton()
    private let id: Int

    weak var delegate: SaveReviewDelegate?

    init(delegate: SaveReviewDelegate?, id: Int){
        self.id = id
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 54.0/255.0, green: 93.0/255.0, blue: 85.0/255.0, alpha: 1)

        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor(red: 54.0/255.0, green: 93.0/255.0, blue: 85.0/255.0, alpha: 1)
        container.layer.cornerRadius = 24
        view.addSubview(container)

        usernameTextField.placeholder = "Enter username"
        usernameTextField.backgroundColor = .white
        usernameTextField.textColor = .black
        usernameTextField.font = UIFont(name: "Papyrus", size: 15)
        usernameTextField.layer.cornerRadius = 5
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameTextField)

        bodyTextField.placeholder = "Enter review"
        bodyTextField.backgroundColor = .white
        bodyTextField.textColor = .black
        bodyTextField.font = UIFont(name: "Papyrus", size: 15)
        bodyTextField.layer.cornerRadius = 5
        bodyTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bodyTextField)

        ratingTextField.placeholder = "Enter rating 1-5"
        ratingTextField.backgroundColor = .white
        ratingTextField.textColor = .black
        ratingTextField.font = UIFont(name: "Papyrus", size: 15)
        ratingTextField.layer.cornerRadius = 5
        ratingTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ratingTextField)

        addReviewButton.translatesAutoresizingMaskIntoConstraints = false
        addReviewButton.titleLabel?.font = UIFont(name: "Papyrus", size: 20)
        addReviewButton.backgroundColor = UIColor(red: 153.0/255.0, green: 152.0/255.0, blue: 132.0/255.0, alpha: 0.65)
        addReviewButton.setTitle("Post", for: .normal)
        addReviewButton.addTarget(self, action: #selector(addReview), for: .touchUpInside)
        addReviewButton.isUserInteractionEnabled = true
        view.addSubview(addReviewButton)

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.titleLabel?.font = UIFont(name: "Papyrus", size: 20)
        closeButton.backgroundColor = UIColor(red: 153.0/255.0, green: 152.0/255.0, blue: 132.0/255.0, alpha: 0.65)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(dismissFromView), for: .touchUpInside)
        view.addSubview(closeButton)

        setupConstraints()

    }

    @objc func addReview(_ button: UIButton){
        if let username = usernameTextField.text, let body = bodyTextField.text, let rating = Int(ratingTextField.text ?? "1"){
            NetworkManager.makeReview(id: self.id, title: "", username: username, body: body, rating: rating){review in
                print("Succesful post")
                self.delegate?.saveReview(review: review)
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
        else{
            let dialogMessage = UIAlertController(title: "Error", message: "Fill out all text fields or use whole number for rating", preferredStyle: .alert)

            dialogMessage.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            self.present(dialogMessage, animated: true, completion: nil)
        }
    }

    @objc func dismissFromView(_ button: UIButton){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

    private func setupConstraints() {
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            container.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45)
        ])
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: container.topAnchor, constant: padding),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            bodyTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 40),
            bodyTextField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            bodyTextField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            bodyTextField.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            ratingTextField.topAnchor.constraint(equalTo: bodyTextField.bottomAnchor, constant: 40),
            ratingTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ratingTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            addReviewButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -padding),
            addReviewButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -35)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -padding),
            closeButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 25)
        ])
    }
}
