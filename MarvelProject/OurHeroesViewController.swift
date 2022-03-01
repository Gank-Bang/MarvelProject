//
//  OurHeroesViewController.swift
//  MarvelProject
//
//  Created by Rafiq Messai on 28/02/2022.
//

import UIKit

class OurHeroesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    
    var characterSearch: [OurHeroes] = []{
        didSet {
            self.ourHeroes.reloadData()
        }
    }
    
    var characters: [OurHeroes] = []
    {
        didSet {
            self.ourHeroes.reloadData()
        }
    }
    

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var marvelButton: UIButton!
    @IBOutlet weak var apiButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var ourHeroes: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.searchBar.backgroundImage = UIImage()
        self.ourHeroes.reloadData()
        
            MarvelServices.getOurCharacters() { err, characters in
                guard err == nil else {
                    return
                }
                
                let allCharacters = characters
                
                DispatchQueue.main.async {
                    for j in allCharacters!{
                        self.characterSearch.append(j)
                        self.characters.append(j)
                    }
                }
            }
        
        
        self.searchBar.delegate = self
        self.ourHeroes.delegate = self
        self.ourHeroes.dataSource = self
        let CharacterCellNib = UINib(nibName: "CharacterCollectionViewCell", bundle: nil)
        self.ourHeroes.register(CharacterCellNib, forCellWithReuseIdentifier: "CharacterCell")
        
    }
        
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.characterSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCollectionViewCell

        let character = self.characterSearch[indexPath.row]
        
        cell.characterImage.setImage(at: URL(string: character.thumbnail!)!, placeholderImage: UIImage(named: "marvelLoader.gif"), errorImage: UIImage(named: "marvelLoader.gif"))
        cell.characterName.text = character.name
        /*cell.redraw(character: character)
        print(character.thumbnail?.pathExtension)
        print(character.name)*/
    
        return cell
    }

    @IBAction func marvelHub(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print("\(searchText)")

        let searchTextLowerCase = searchText.lowercased()
        guard !searchText.isEmpty else {
           characterSearch = characters
            ourHeroes.reloadData()
            return
        }
        characterSearch = characters.filter({ character -> Bool in
            //return (character.name.contains(searchTextLowerCase) || character.name.contains(searchText))
            //return character.name.localizedCaseInsensitiveContainsString(searchText)
            //character.name.localizedCaseInsensitiveContainsString(searchText)
            if let range3 = character.name.range(of: searchText, options: .caseInsensitive) {
                return true
            } else {
                return false
            }
            
        })
        ourHeroes.reloadData()
        }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell:CharacterCollectionViewCell = self.ourHeroes.cellForItem(at: indexPath) as! CharacterCollectionViewCell
        let character = self.characterSearch[indexPath.row]
        
        let CharacterViewController = OurCharacterViewController.newInstance(cell: cell, character: character)
        self.navigationController?.pushViewController(CharacterViewController, animated: true)
        print(character.name)
        print(character.thumbnail)
        print(character.id)
        //print(character.comics![1])
        //print(self.listComics[1].listNames)
        //print(character.thumbnail?.pathExtension)
        print(character.id)
    }
    
    @IBAction func addHero(_ sender: Any) {
        
        self.navigationController?.pushViewController(AddViewController(), animated: true)
        
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        
        characters = []
        characterSearch = []
        
        MarvelServices.getOurCharacters() { err, characters in
            guard err == nil else {
                return
            }
            
            let allCharacters = characters
            
            DispatchQueue.main.async {
                for j in allCharacters!{
                    self.characterSearch.append(j)
                    self.characters.append(j)
                }
            }
        }
        self.ourHeroes.reloadData()
        
    }
    
}
 
