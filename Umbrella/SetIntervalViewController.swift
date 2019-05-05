//
//  SetIntervalViewController.swift
//  Umbrella
//
//  Created by Dias Zhassanbay on 5/5/19.
//  Copyright © 2019 Dias Zhassanbay. All rights reserved.
//

import UIKit

class SetIntervalViewController: UIViewController {
    
    @IBOutlet weak var timeInterval: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func setTime(_ sender: Any) {
        performSegue(withIdentifier: "set", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "set" {
            let viewController = segue.destination as! ViewController
            viewController.time = Double(timeInterval.text!)!
            
        }
    }
    

}
