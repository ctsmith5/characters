//
//  ViewModel.swift
//  TheSimpsons
//
//  Created by Colin Smith on 9/5/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit


class ViewModel {
    static let shared = ViewModel()
    
    let simpsonsURL = URL(string: "https://api.duckduckgo.com/?q=simpsons+characters&format=json")
    let wireURL = URL(string: "https://api.duckduckgo.com/?q=the+wire+characters&format=json")
    
    var characters: [CSCharacter] = []
    
    func fetchSimpsons(completion: @escaping ([CSCharacter]) -> Void) {
        guard let url = simpsonsURL else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = nil
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(" \(error.localizedDescription) \(error) in function \(#function) ")
                completion([])
                return
            }
            guard let data = data else {return}
            do{
                let data = try JSONDecoder().decode(TopLevel.self, from: data)
                let characters = data.relatedTopics
                completion(characters)
            }catch{
                print("could not load from dictionary \(error.localizedDescription)")
                completion([])
            }
            }.resume()
    }
    
    func fetchWire(){
        
    }
    
    func fetchCharacterImage(character: CSCharacter, completion: @escaping (UIImage?) -> Void ){
        
        guard let url = URL(string: character.icon.url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = nil
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(" \(error.localizedDescription) \(error) in function \(#function) ")
                completion(nil)
                return
            }
            if let data = data {
                let image = UIImage(data: data)
                completion(image)
            }
            else {
                print("there was a problem fetching photos. complete with unavailable photo")
                completion(UIImage(named: "bob"))
            }
            }.resume()
    }
}
