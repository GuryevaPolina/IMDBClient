//
//  MovieDetailViewController.swift
//  IMDBClient
//
//  Created by Polina Guryeva on 15/10/2018.
//  Copyright © 2018 Polina Guryeva. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var summuryTextView: UITextView!
    
    var movie: Movie!
    var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    var activityIndicator = UIActivityIndicatorView(style: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        addActivityIndicator()
        ApiRequest.getDetail(forMovie: movie) { (result) in
            DispatchQueue.main.async {
                self.movie = result
                ApiRequest.getPoster(withUrl: result.posterURL, completion: { (poster) in
                    DispatchQueue.main.async {
                        self.movie.image = poster
                        self.setDetails()
                        self.removeActivityIndicator()
                    }
                })
            }
        }
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
    
    func setDetails() {
        movieNameLabel.text = movie.name
        markLabel.text = "Rating: \(movie.rating)"
        countryLabel.text = "Country: \(movie.country)"
        producerLabel.text = "Director: \(movie.director)"
        castLabel.text = "Cast: \(movie.cast)"
        summuryTextView.text = movie.summary
        poster.image = movie.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
