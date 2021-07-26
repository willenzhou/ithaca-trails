//
//  Trail.swift
//  IthacaTrails2
//
//  Created by Justin Gu on 12/7/20.
//
import UIKit
import Alamofire

class ViewController: UIViewController {

    let padding: CGFloat = 8
    
    let trailsTableView = UITableView()
    let trailCellReuseIdentifier = "trailCellReuseIdentifier"
    var trails: [Trail] = []
    
    var searchBar = UISearchBar()
    var copyTrails: [Trail] = []
    var activityNames: [String] = []
    
    var filterCollectionView: UICollectionView!
    let filterCellReuseIdentifier = "filterCellReuseIdentifier"
    
    let running = Filter(name: "Running", filter: false)
    let hiking = Filter(name: "Hiking", filter: false)
    let biking = Filter(name: "Biking", filter: false)
    let skiing = Filter(name: "Skiing", filter: false)
    let lessTwo = Filter(name: "<2 miles", filter: false)
    let twoFive = Filter(name: "2-5 miles", filter: false)
    let fiveTen = Filter(name: "5-10 miles", filter: false)
    let moreThanTen = Filter(name: ">10 miles", filter: false)
    let easy = Filter(name: "Easy", filter: false)
    let medium = Filter(name: "Moderate", filter: false)
    let hard = Filter(name: "Hard", filter: false)
    
    var filters: [Filter] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        filters = [running, hiking, biking, skiing, lessTwo, twoFive, fiveTen, moreThanTen, easy, medium, hard]

        title = "Ithaca Trails"

        view.backgroundColor =
            UIColor(red: 54.0/255.0, green: 93.0/255.0, blue: 85.0/255.0, alpha: 1)
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .gray

        setupViews()
        
        self.setNavigationItem()
        
        getTrails()
        
        setupConstraints()
        
        // initialize copy trails array
        copyTrails = trails
    }

    
    func setupViews() {
    
        // set up views for search bar
        searchBar.delegate = self
        searchBar.backgroundColor = .white
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Enter trail name or site name"
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 15)
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.layer.cornerRadius = 15
        searchBar.layer.masksToBounds = true
        view.addSubview(searchBar)
        
        
        let filterLayout = UICollectionViewFlowLayout()
        filterLayout.scrollDirection = .horizontal
        filterLayout.minimumInteritemSpacing = padding
        filterLayout.minimumLineSpacing = padding
        
        filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: filterLayout)
        filterCollectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: filterCellReuseIdentifier)
        filterCollectionView.backgroundColor = UIColor(red: 54.0/255.0, green: 93.0/255.0, blue: 85.0/255.0, alpha: 1)
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterCollectionView)
        
        // set up views for trails table
        trailsTableView.delegate = self
        trailsTableView.dataSource = self
        trailsTableView.translatesAutoresizingMaskIntoConstraints = false
        trailsTableView.separatorStyle = .none
        trailsTableView.backgroundColor = UIColor(red: 54.0/255.0, green: 93.0/255.0, blue: 85.0/255.0, alpha: 1)
        trailsTableView.register(TrailTableViewCell.self, forCellReuseIdentifier: trailCellReuseIdentifier)
        view.addSubview(trailsTableView)
    }
    
    func setupConstraints() {
        
        // constraints for searchBar
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            filterCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 15),
            filterCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding),
            filterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            filterCollectionView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // set up constraints for trails table
        NSLayoutConstraint.activate([
            trailsTableView.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor, constant: 30),
            trailsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            trailsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func getTrails() {
        NetworkManager.getTrails { trails in
            self.trails = trails
            self.copyTrails = trails
            DispatchQueue.main.async {
                self.trailsTableView.reloadData()
            }
        }
    }
    

}

// Filter Collection View

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return filters.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: filterCellReuseIdentifier, for: indexPath) as! FilterCollectionViewCell
            let filter = filters[indexPath.row]
            cell.configure(for: filter)
            return cell
        
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 85, height: 30)
        
    }
}

// MARK: Trails Table
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trail = trails[indexPath.row]
        let trailViewController = TrailViewController(trail: trail)
        navigationController?.pushViewController(trailViewController, animated: true)

    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: trailCellReuseIdentifier) as? TrailTableViewCell else { return UITableViewCell() }
        let trail = trails[indexPath.row]
        cell.configure(for: trail)
        return cell
    }
}

extension ViewController:  UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
        NetworkManager.searchTrails(name: searchText){ trails in
            self.trails = trails
            
            DispatchQueue.main.async {
                self.trailsTableView.reloadData()
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        filters[indexPath.item].setFilter()
        
        var filterCount = 0
        var x: Float //min miles
        var y: Float //max miles
        var hasActivity = false
        
        for f in filters{
            if f.filterOn{
                filterCount += 1
            }
        }
        
        trails.removeAll()
        for f in filters{
            if f.filterOn{
                if(f.filterName == "<2 miles"){
                    x = 0.0
                    y = 2.0
                }else if(f.filterName == "2-5 miles"){
                    x = 2.0
                    y = 5.0
                }else if(f.filterName == "5-10 miles"){
                    x = 5.0
                    y = 10.0
                }else if(f.filterName == ">10 miles"){
                    x = 10.0
                    y = 1000.0
                }else{
                    x = 0.0
                    y = 0.0
                }
                for t in copyTrails{
                    
                    if let activities = t.activities{
                        for a in activities{
                            if a.name == f.filterName{
                                hasActivity = true
                            }
                        }
                    }
                    
                    if ((t.length >= x && t.length <= y) || (f.filterName == t.difficulty) || hasActivity) && !trails.contains(t){
                        trails.append(t)
                    }
                    
                    hasActivity = false
                }
            }
        }
        
        if filterCount == 0{
            trails = copyTrails
        }
        
        self.filterCollectionView.reloadData()
        self.trailsTableView.reloadData()
        
        }
}

// main logo
extension UIViewController {
    func setNavigationItem() {
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let logoimageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            logoimageView.image = UIImage(named: "mainlogo.jpg")
            logoimageView.contentMode = UIView.ContentMode.scaleAspectFit
            logoimageView.layer.cornerRadius = 20
            logoimageView.layer.masksToBounds = true
            containView.addSubview(logoimageView)
            let rightBarButton = UIBarButtonItem(customView: containView)
            self.navigationItem.rightBarButtonItem = rightBarButton
    }
}

