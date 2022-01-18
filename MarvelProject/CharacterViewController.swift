//
//  CharacterViewController.swift
//  MarvelProject
//
//  Created by Rafiq Messai on 16/01/2022.
//

import UIKit

class CharacterViewController: UIViewController {


    
    @IBOutlet weak var imageCharacter: UIImageView!
    @IBOutlet weak var detailsCharacter: UILabel!
    
    var character: MarvelCharacters!
    var cellChoosed: CharacterCollectionViewCell!
    
    static func newInstance(cell:CharacterCollectionViewCell,character:MarvelCharacters) -> CharacterViewController {

        let CharacterViewController = CharacterViewController()
        CharacterViewController.character = character
        CharacterViewController.cellChoosed = cell
        
        return CharacterViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageCharacter.image = self.cellChoosed.characterImage.image
        self.detailsCharacter.text = self.character.details
       
    }

    
}
