//
//  DetailsViewController.swift
//  farscapetabular
//
//  Created by Nirvana Choudhury on 7/24/21.
//  Copyright © 2021 Sugar Glider/. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButtonClicked(_ sender: Any) {
//        performSegue(withIdentifier: "DetailsToListSegue", sender: self )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "DetailsToListSegue" {
                guard let vc = segue.destination as? ListViewController else { return }
    //            vc.segueText = segueTextField.text
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
