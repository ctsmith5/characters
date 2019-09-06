//
//  CharacterViewController.swift
//  TheSimpsons
//
//  Created by Colin Smith on 9/5/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class CharacterViewController: UIViewController {

    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    
    var character: CSCharacter? {
        didSet {
            loadView()
            setupUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setupUI () {
        guard let character = character else {return}
        titleLabel.text = character.name
        
        let description = character.description.split(separator: "-", maxSplits: 1, omittingEmptySubsequences: false)
        let second = String(description[1])
        descriptionLabel.text = second
        
        //fetch character image
        ViewModel.shared.fetchCharacterImage(character: character) { (image) in
            DispatchQueue.main.async {
                self.characterImageView.image = image
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension CharacterViewController: CharacterSelectionDelegate {
    func characterSelected(_ newCharacter: CSCharacter) {
        self.character = newCharacter
    }
}

