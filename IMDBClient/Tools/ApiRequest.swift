//
//  ApiRequest.swift
//  IMDBClient
//
//  Created by Polina Guryeva on 15/10/2018.
//  Copyright © 2018 Polina Guryeva. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class ApiRequest {
    
    static var pathWithName = ""
    static let resultsOnPage = 10
    
    // get count of page with results
    static func getPageCount(forName name: String, completion: @escaping (Int) -> ()) {
        pathWithName = "\(Constants.path)s=\(name)"
        guard let url = URL(string: pathWithName) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                guard let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] else {return}
                guard let resultCount = json["totalResults"] as? String else {return}
                guard let pageCount = Int(resultCount) else {return}
                completion(Int(ceil(Double(pageCount / resultsOnPage))))
            }
            catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    // get movies on certain page
    static func getMovies(onPage page: Int, completion: @escaping ([Movie]) -> ()){
        guard let urlWithPage = URL(string: pathWithName + "&page=\(page)") else {return}
        URLSession.shared.dataTask(with: urlWithPage) { (data, response, error) in
            var moviesOnPage: [Movie] = []
            do {
                guard let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] else {return}
                guard let searchResults = json["Search"] as? [[String:Any]] else {return}
                for result in searchResults {
                    guard let title = result["Title"] as? String,
                          let id = result["imdbID"] as? String else {return}
                    moviesOnPage.append(Movie(name_: title, id_: id))
                }
                completion(moviesOnPage)
            }
            catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    // get details for movie
    static func getDetail(forMovie movie_: Movie, completion: @escaping (Movie) -> ()) {
        var movie = movie_
        let path = "\(Constants.path)i=\(movie.id)"
        guard let url = URL(string: path) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                guard let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] else {return}
                completion(movie.setDetails(fromJson: json))
            }
            catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    // get poster for movie
    static func getPoster(withUrl url: String, completion: @escaping (UIImage) -> ()) {
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                completion(image)
            } else {
                completion(#imageLiteral(resourceName: "question"))
            }
        }
    }
    
}


