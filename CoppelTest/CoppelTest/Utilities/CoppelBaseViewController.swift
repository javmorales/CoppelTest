//
//  CoppelBaseViewController.swift
//  CoppelTest
//
//  Created by Javier Morales on 26/10/21.
//

import Foundation
import UIKit

class CoppelBaseViewController: UIViewController {
    
    var spinnerVC: SpinnerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showSpinner() {
        spinnerVC = SpinnerViewController()
        guard let spinner = spinnerVC  else {
            return
        }
        
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)

    }
    
    func hideSpinner() {
        guard let spinner = spinnerVC else {
            return
        }
        
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
        spinnerVC = nil
        
    }

}
