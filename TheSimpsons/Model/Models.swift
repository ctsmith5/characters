//
//  Models.swift
//  TheSimpsons
//
//  Created by Colin Smith on 9/5/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

struct TopLevel: Decodable {
    let definitionSource: String
    let entity: String
    let abstractText: String
    let abstractURL: String
    let relatedTopics: [CSCharacter]
    
    init(definitionSource: String, entity: String, abstractText: String, abstractURL: String, relatedTopics: [CSCharacter]){
        self.definitionSource = definitionSource
        self.entity = entity
        self.abstractText = abstractText
        self.abstractURL = abstractURL
        self.relatedTopics = relatedTopics
    }
    
    enum CodingKeys: String, CodingKey {
        case definitionSource = "DefinitionSource"
        case entity = "Entity"
        case abstractText = "AbstractText"
        case abstractURL = "AbstractURL"
        case relatedTopics = "RelatedTopics"
    }
}
struct CSCharacter: Decodable {
    
    var name: String {
        get {
            let split = self.description.split(separator: "-", maxSplits: 1, omittingEmptySubsequences: false)
            let title = String(split[0])
            return title
        }
    }
    
    let description: String
    let icon: Icon
    
    init(description: String, icon: Icon) {
        self.description = description
        self.icon = icon
    }
    
    enum CodingKeys: String, CodingKey {
        case description = "Text"
        case icon = "Icon"
    }
}

struct Icon: Decodable {
    let width: String
    let url: String
    let height: String
    
    
    enum CodingKeys: String, CodingKey {
        case width = "Width"
        case url = "URL"
        case height = "Height"
    }
}

class CSImage : Decodable {
    var uiImage: UIImage?
    
    init(image: UIImage? = nil){
        self.uiImage = image
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let imageURL = try? values.decode(URL.self, forKey: .url) {
            UIImage.load(from: imageURL) { (result) in
                if let image = result {
                    self.uiImage = image
                }
            }
        } else if let imageData = try? values.decode(Data.self, forKey: .image),
            let image = UIImage(data: imageData) {
            self.uiImage = image
        }
    }
}

enum CodingKeys: String, CodingKey {
    case image = "uiImage"
    case url
}

protocol CharacterSelectionDelegate: class {
    func characterSelected(_ newCharacter: CSCharacter)
}


extension CSCharacter : SearchableCharacter {
    func titleMatches(searchTerm: String) -> Bool {
        return name.localizedCaseInsensitiveContains(searchTerm)
    }
    
    
}


protocol SearchableCharacter {
    func titleMatches(searchTerm: String) -> Bool
}
