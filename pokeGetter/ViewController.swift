//
//  ViewController.swift
//  pokeGetter
//
//  Created by Spencer Casteel on 10/24/18.
//  Copyright © 2018 Spencer Casteel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var pokemonNameOrIDText: UITextField!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var weightAndHeightLabel: UILabel!
    @IBOutlet weak var spriteImageView: UIImageView!
    
    let baseURL = "https://pokeapi.co/api/v2/pokemon/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let pokemonNameOrID =  pokemonNameOrIDText.text, pokemonNameOrID != "" else {
            return
        }
        
        pokemonNameOrIDText.text = ""
        
        //url that we will use for our request
        let requestURL = "\(baseURL)\(pokemonNameOrID.lowercased().replacingOccurrences(of: " ", with: "+"))"
        print(requestURL)
        
        //make our request
        let request = Alamofire.request(requestURL)
        
        //carry out the request
        request.responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                var typeString = ""
                var weightAndHeight = ""
                
                if let speciesName = json["species"]["name"].string {
                    print(speciesName)
                    self.pokemonNameLabel.text = speciesName
                }
                
                if let ID = json["id"].int {
                    print(ID)
                    self.IDLabel.text = "ID:\(ID)"
                }
                
                //                if let abilitiesJSON = json["abilities"].array {
                //                    for ability in abilitiesJSON {
                //                        if let abilityName = ability["ability"]["name"].string {
                //                            print(abilityName)
                //                        }
                //                    }
                //                }
                
                
//                if let typesJson = json["types"].array {
//
//                    var types = ""
//
//                    for type in typesJson {
//                        if let typeName = type["type"]["name"].string {
//                            types += "\(typeName) / "
//                        }
//                    }
//                    print(types)
//                    self.typeLabel.text = types
//                }
                
                if let type1 = json["types"][0]["type"]["name"].string {
                    typeString += "Type: \n \(type1)"
                }
                
                if let type2 = json["types"][1]["type"]["name"].string {
                    typeString += " / \(type2)"
                }
                
                if let weight = json["weight"].int {
                    weightAndHeight += "Weight: \(weight) / "
                }
                
                if let height = json["height"].int {
                    weightAndHeight += "height: \(height)"
                }

                print(typeString)
                print(weightAndHeight)
                
                if let spriteURL = json["sprites"]["front_default"].string {
                    if let url = URL(string: spriteURL) {
                        //Load this into the image view
                        self.spriteImageView.sd_setImage(with: url, completed: nil)
                    }
                }
                self.typeLabel.text = typeString
                self.weightAndHeightLabel.text = weightAndHeight
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
      pokemonNameOrIDText.text = ""
    }
    
}

