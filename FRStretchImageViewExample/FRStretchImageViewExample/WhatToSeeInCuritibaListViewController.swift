//
//  WhatToSeeInCuritibaListViewController.swift
//  FRStretchImageViewExample
//
//  Created by Felipe Ricieri on 17/03/17.
//  Copyright © 2017 Ricieri Labs. All rights reserved.
//

import UIKit
import Foundation
import FRStretchImageView

class WhatToSeeInCuritibaListViewController : UITableViewController {
    
    @IBOutlet weak var stretchableImageView: FRStretchImageView!
    
    struct Segue {
        static let toDetails = "toDetails"
    }
    
    fileprivate var source : [String] = [
        "Jardim Botânico",
        "Parque Barigui",
        "Parque Tanguá",
        "Unilivre",
        "Ópera de Arame",
        "Pedreira Paulo Leminski",
        "Museu Oscar Niemyer",
        "Parque Tinguí",
        "Santa Felicidade",
        "Museu do Expedicionário",
        "Av. Batel"
    ]
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "What to see in Curitiba 🇧🇷"
        
        // Setting FRStretchImageView
        stretchableImageView.stretchHeightWhenPulledBy(scrollView: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == Segue.toDetails {
            let vc = segue.destination as! WhatToSeeInCuritibaDetailsViewController
            vc.touristicPointName = sender as! String
        }
    }
}

// MARK: - Table Methods
extension WhatToSeeInCuritibaListViewController {
    
    // Rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WhatToSeeInCuritibaCell.objectID, for: indexPath) as! WhatToSeeInCuritibaCell
        let object = source[indexPath.row]
        cell.configure(title: object)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let object = source[indexPath.row]
        self.performSegue(withIdentifier: Segue.toDetails, sender: object)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    // Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

// MARK: - Resources
class WhatToSeeInCuritibaCell : UITableViewCell {
    static let objectID = "cell"
    @IBOutlet weak var titleLabel: UILabel!
    func configure(title: String) {
        self.titleLabel.text = title
    }
}

