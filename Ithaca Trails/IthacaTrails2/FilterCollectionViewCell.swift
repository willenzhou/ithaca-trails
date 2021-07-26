//
//  FilterCollectionViewCell.swift
//  IthacaTrails2
//
//  Created by Justin Gu on 12/11/20.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    var filterNameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filterNameLabel = UILabel()
        filterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        filterNameLabel.font = UIFont.systemFont(ofSize: 15)
        filterNameLabel.textColor = .black
        
        self.layer.cornerRadius = 8.0
        
        contentView.addSubview(filterNameLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            filterNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            filterNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(for filter: Filter) {
        filterNameLabel.text = filter.filterName;
        if filter.filterOn == false{
            backgroundColor = .white
            
        }
        else{
            backgroundColor = UIColor(red: 168.0/255.0, green: 139.0/255.0, blue: 78.0/255.0, alpha: 1)
        }
    }
    
}
