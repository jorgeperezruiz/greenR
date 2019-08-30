//
//  launchVCViewController.swift
//  GreenR
//
//  Created by Pete Holdsworth on 30/08/2019.
//  Copyright © 2019 GreenR. All rights reserved.
//

import UIKit

class launchVCViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            
            self.present(tabBarVC, animated: false, completion: nil)
        }
    }
    
}
