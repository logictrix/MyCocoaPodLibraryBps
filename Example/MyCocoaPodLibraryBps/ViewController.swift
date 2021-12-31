//
//  ViewController.swift
//  MyCocoaPodLibraryBps
//
//  Created by logictrix on 12/30/2021.
//  Copyright (c) 2021 logictrix. All rights reserved.
//

import UIKit
import MyCocoaPodLibraryBps

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let val = Logger()
//        val.printLog()
//        val.startFirstScreen()
    }

    @IBAction func captureScan(_ sender: Any) {
        let smManagerVC = Logger.initiateSMSDK()
        navigationController?.pushViewController(smManagerVC, animated: true)
//        present(smManagerVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

