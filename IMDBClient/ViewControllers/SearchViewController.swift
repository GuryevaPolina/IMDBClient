//
//  ViewController.swift
//  IMDBClient
//
//  Created by Polina Guryeva on 15/10/2018.
//  Copyright © 2018 Polina Guryeva. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    var movies: [Int: [Movie]] = [:]
    
    lazy var noResultsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "There is no movies"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initView()
        //updateMovies(withName: "interstellar")
    }
    
    func initView() {
        movieTableView.rowHeight = UITableViewAutomaticDimension
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.tableFooterView = UIView()
        searchBar.delegate = self
    }
    
    func updateMovies(withName name: String) {
        movies = [:]
        ApiRequest.getPageCount(forName: name) { (pageCount) in
            DispatchQueue.main.async {
                for page in 0...pageCount {
                    ApiRequest.getMovies(onPage: page) { (results) in
                        DispatchQueue.main.async {
                            self.movies[page] = results
                            self.movieTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rowsInSectionCount = movies[section]?.count else {return 0}
        return rowsInSectionCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.backgroundView = movies.isEmpty ? noResultsLabel : nil
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.movieCellID) as? MovieTableViewCell,
            let movieArray = movies[indexPath.section] else {return UITableViewCell()}
        cell.movieNameLabel.text = movieArray[indexPath.row].name
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let navigator = navigationController,
              let detailVC = UIStoryboard(name: Constants.mainStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.movieDetailViewControllerID) as? MovieDetailViewController,
              let movieArray = movies[indexPath.section] else {return}
        detailVC.movie = movieArray[indexPath.row]
        navigator.pushViewController(detailVC, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func replaceSpacesByPlus(inText text: String) -> String {
        let trimmedString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedString.replacingOccurrences(of: " ", with: "+")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            movies = [:]
            return
        }
        let textForSearch = replaceSpacesByPlus(inText: searchText)
        updateMovies(withName: textForSearch)
    }
}











