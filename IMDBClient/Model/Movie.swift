//
//  Movie.swift
//  IMDBClient
//
//  Created by Polina Guryeva on 15/10/2018.
//  Copyright © 2018 Polina Guryeva. All rights reserved.
//

import Foundation
import UIKit

struct Movie {
    var name: String = ""
    var rating: String = ""
    var country: String = ""
    var director: String = ""
    var cast: String = ""
    var summary: String = ""
    var image: UIImage?
    var id: String = ""
    var posterURL: String = ""
    
    init(name_: String, id_: String) {
        name = name_
        id = id_
    }
    
    init() {}
    
    mutating func setDetails(fromJson json: [String: Any]) -> Movie {
        guard let director = json["Director"] as? String,
            let cast = json["Actors"] as? String,
            let plot = json["Plot"] as? String,
            let country = json["Country"] as? String,
            let rating = json["imdbRating"] as? String,
            let posterURL = json["Poster"] as? String else {return Movie()}
        
        self.director = director
        self.cast = cast
        self.summary = plot
        self.country = country
        self.rating = rating
        self.posterURL = posterURL
        return self
    }
}
