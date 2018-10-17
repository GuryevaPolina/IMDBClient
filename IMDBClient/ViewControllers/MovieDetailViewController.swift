//
//  MovieDetailViewController.swift
//  IMDBClient
//
//  Created by Polina Guryeva on 15/10/2018.
//  Copyright © 2018 Polina Guryeva. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var infoTableView: UITableView!
    var movie: Movie!
    var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    var activityIndicator = UIActivityIndicatorView(style: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        addActivityIndicator()
        ApiRequest.getDetail(forMovie: movie) { (result) in
            DispatchQueue.main.async {
                self.movie = result
                ApiRequest.getPoster(withUrl: result.posterURL, completion: { (poster) in
                    DispatchQueue.main.async {
                        self.movie.image = poster
                        self.infoTableView.reloadData()
                        self.removeActivityIndicator()
                    }
                })
            }
        }
    }
    
    func initView() {
        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.rowHeight = UITableView.automaticDimension
        infoTableView.separatorStyle = .none
        infoTableView.allowsSelection = false
    }
    
    func addActivityIndicator() {
        blurView.frame = view.bounds
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(blurView)
        view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        blurView.removeFromSuperview()
        activityIndicator.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.imageCellID) as? PosterTableViewCell else {return UITableViewCell()}
            cell.poster.image = movie.image
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.textCellID) as? TextTableViewCell else {return UITableViewCell()}
        switch indexPath.row {
        case 0:
            cell.info.text = movie.name
            cell.info.font = UIFont.boldSystemFont(ofSize: 23.0)
        case 2:
            cell.info.text = "Rating: \(movie.rating)"
            cell.info.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        case 3:
            cell.info.text = "Country: \(movie.country)"
        case 4:
            cell.info.text = "Director: \(movie.director)"
        case 5:
            cell.info.text = "Cast: \(movie.cast)"
        case 6:
            cell.info.text = movie.summary
        default:
            break
        }
        return cell
    }
    
}
