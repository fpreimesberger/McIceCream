//
//  ViewController.swift
//  Group1Alpha
//
//  Created by Preimesberger, Freya M on 3/28/18.
//  Copyright © 2018 Preimesberger, Freya M. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var icecream: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loginButton.layer.cornerRadius = 10
        registerButton.layer.cornerRadius = 10
        loginButton.center.x = self.view.center.x
        registerButton.center.x = self.view.center.x
        logo.center.x = self.view.center.x + 25.0
        icecream.center.x = self.view.center.x - 150.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

