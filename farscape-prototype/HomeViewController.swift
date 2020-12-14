//
//  HomeViewController.swift
//  farscape-prototype
//
//  Created by Nirvana Choudhury on 7/17/20.
//  Copyright © 2020 Sugar Glider/. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBAction func aboutButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "AboutSegue", sender: self)
    }
    
    @IBAction func databaseButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "DatabaseSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


