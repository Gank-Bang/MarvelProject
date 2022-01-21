//
//  CharacterViewController.swift
//  MarvelProject
//
//  Created by Rafiq Messai on 16/01/2022.
//

import UIKit

class CharacterViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    

    @IBOutlet weak var ComicsView: UICollectionView!
    @IBOutlet weak var buttonMenu: UIButton!
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
        
        self.ComicsView.isHidden = true
        
        
        
        //Initialisation du menu de selection
        
        let optionsClosure = { (action: UIAction) in
          print(action.title)
        }
        
        let usersItem = UIAction(title: "Description", image: UIImage(systemName: "person.text.rectangle")) { (action) in
            self.detailsCharacter.isHidden = false
            self.ComicsView.isHidden = true
            }
        
            let addUserItem = UIAction(title: "Comics", image: UIImage(systemName: "books.vertical")) { (action) in
                self.detailsCharacter.isHidden = true
                self.ComicsView.isHidden = false
                
            }
            let menu = UIMenu(title: "Categorie", options: .displayInline, children: [usersItem , addUserItem ])
        
        self.buttonMenu.menu = menu
        buttonMenu.showsMenuAsPrimaryAction = true
        
        
        self.ComicsView.delegate = self
        self.ComicsView.dataSource = self
        let CharacterCellNib = UINib(nibName: "ComicsCollectionViewCell", bundle: nil)
        self.ComicsView.register(CharacterCellNib, forCellWithReuseIdentifier: "ComicsCell")

    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.character.comics!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicsCell", for: indexPath) as! ComicsCollectionViewCell
        let comic = self.character.comics![indexPath.row]
        cell.redraw(comic: comic)
        return cell
    }
    
    
    
}
