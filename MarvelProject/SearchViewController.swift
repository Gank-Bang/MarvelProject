//
//  SearchViewController.swift
//  MarvelProject
//
//  Created by Rafiq Messai on 13/01/2022.
//

import UIKit


class SearchViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate{

    
    

    
    var listComics:[MarvelComics] = []
    var cellList:[CharacterCollectionViewCell] = []
    var numberOfRow:Int = 0
    var appelApi = [0,100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500]
    @IBOutlet weak var listCharacters: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var marvelButton: UIButton!
    @IBOutlet weak var apiButton: UIButton!
    
    
    
    var characters: [MarvelCharacters] = []
    {
        didSet {
            self.listCharacters.reloadData()
        }
    }
    
    var characterSearch: [MarvelCharacters] = []
        {
        didSet {
            self.listCharacters.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        
        // PETIT KIFF PERSO
        let url = URL(string: "https://mir-s3-cdn-cf.behance.net/project_modules/disp/da734b28921021.55d95297d71f4.gif")
        let url2 = URL(string: "https://img.wattpad.com/5cf46a0ac879eebf163d88f8247166a0560dea45/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f776174747061642d6d656469612d736572766963652f53746f7279496d6167652f6c6776346475706f6a6a626468773d3d2d3734323233343739342e313561623839666436316663383032623837353631363536373734362e676966")
        let url3 = URL(string: "https://c.tenor.com/atuEM9DqpxkAAAAC/the-avengers-team.gif")
        let url4 = URL(string: "https://data.whicdn.com/images/330349801/original.gif")
        let url5 = URL(string: "https://64.media.tumblr.com/071932debe3fb59e82d104b60f3d59ce/ffd12edd2f5bf40a-7d/s540x810/3c11d7c7175e9fb8767b36054d119b6237a7fc88.gifv")
        
        var listGifs:[URL] = []
        listGifs.append(url!)
        listGifs.append(url2!)
        listGifs.append(url3!)
        listGifs.append(url4!)
        listGifs.append(url5!)
        ///
        

        
        
        /*let loader = UIActivityIndicatorView(style: .white)
        self.loadingImage.setGifFromURL(listGifs.randomElement()!, customLoader: loader)

        //self.loadingImage.isHidden = true
        self.searchBar.backgroundImage = UIImage()
        self.listCharacters.isHidden = true
        self.searchBar.isHidden = true
        self.marvelButton.isHidden = true
        self.apiButton.isHidden = true*/
        

        for i in appelApi{
            MarvelServices.getCharacters(offset: i) { err, characters in
                guard err == nil else {
                    return
                }
            MarvelServices.getComics(offset: i) { err, comics in
                    guard err == nil else {
                        return
                    }
                
                
                let allComics = comics
                let allCharacters = characters
                DispatchQueue.main.async {
                    
                    for k in allComics!{
                        self.listComics.append(k)
                    }
                    
                    
                    for j in allCharacters!{
                        //print(j.id)
                        for z in self.listComics{
                            if ((z.listNames?.contains(j.name)) != false) {
                                j.comics?.append(z)
                            }
                            else{
                                
                            }
                        }
                        self.characters.append(j)
                        self.characterSearch.append(j)
                    }
                }
            }
            }
        }
    
        
        //self.switchButton.clipsToBounds = true
        //self.switchButton.layer.borderWidth = 1
        //self.switchButton.isUserInteractionEnabled = true

        self.searchBar.delegate = self
        self.listCharacters.delegate = self
        self.listCharacters.dataSource = self
        let CharacterCellNib = UINib(nibName: "CharacterCollectionViewCell", bundle: nil)
        self.listCharacters.register(CharacterCellNib, forCellWithReuseIdentifier: "CharacterCell")
        
        
        
    }
    
    //override func viewWillAppear(_ animated: Bool) {
       // self.loadingImage.isHidden = true
       // self.listCharacters.isHidden = false
   // }
    
    

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.characterSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.numberOfRow += 1
        
        if numberOfRow == 50{
            self.loadingImage.isHidden = true
            self.listCharacters.isHidden = false
            self.searchBar.isHidden = false
            self.marvelButton.isHidden = false
            self.apiButton.isHidden = false
        }
        print(numberOfRow)
        
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCollectionViewCell

            let character = self.characterSearch[indexPath.row]
            

            cell.characterImage.setImage(at: character.thumbnail!, placeholderImage: UIImage(named: "marvelLoader.gif"), errorImage: UIImage(named: "marvelLoader.gif"))
            cell.characterName.text = character.name
            /*cell.redraw(character: character)
            print(character.thumbnail?.pathExtension)
            print(character.name)*/
        
            return cell
        }

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell:CharacterCollectionViewCell = self.listCharacters.cellForItem(at: indexPath) as! CharacterCollectionViewCell
        let character = self.characterSearch[indexPath.row]
        
        let CharacterViewController = CharacterViewController.newInstance(cell: cell, character: character)
        self.navigationController?.pushViewController(CharacterViewController, animated: true)
        print(character.name)
        print(character.thumbnail)
        print(character.id)
        //print(character.comics![1])
        print(self.listComics[1].listNames)
        print(character.thumbnail?.pathExtension)
        print(character.id)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print("\(searchText)")

        let searchTextLowerCase = searchText.lowercased()
        guard !searchText.isEmpty else {
           characterSearch = characters
            listCharacters.reloadData()
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
        listCharacters.reloadData()
        }
    

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }


    @IBAction func libraryApi(_ sender: Any) {
        self.navigationController?.pushViewController(OurHeroesViewController(),animated: false)
    }
    
    

}
