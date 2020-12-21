//
//  ObjectDataViewController.swift
//  farscape-table-view
//
//  Created by Nirvana Choudhury on 12/20/20.
//  Copyright © 2020 Sugar Glider/. All rights reserved.
//

import Foundation
import UIKit


class ObjectDataViewController: UIViewController {
    var planet: [String:String] = [:]
    @IBOutlet weak var objectDataTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var idx = indexRowBuffer
        
        print(nameBuffer)
        print("\(nameBuffer)@\(idx)")
        
//        print(planetDataBuffer.map { $0["name"] ?? "\($0)"})
        if(idx == -1) {
            self.planet = [:]
        } else {
        self.planet = planetDataBuffer[idx]
        }
        
        print(self.planet)
        
        
    }
}
