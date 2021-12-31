//
//  Logger.swift
//  MyCocoaPodLibraryBps
//
//  Created by Logictrix on 30/12/21.
//

import Foundation
import UIKit

public class Logger {
    

    public func printLog(){
        print("Hello World")
    }
    
    func privateMethod(){
        print("Private")
    }
    
    public static func initiateSMSDK() -> UIViewController {
//        let SMDKStoryboard = UIStoryboard(name: "SMstoryBoard", bundle: nil)
        
        let VC = Storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        VC.modalTransitionStyle = .crossDissolve
        VC.modalPresentationStyle = .overCurrentContext
//        VC.paramsSet = params
//        VC.delegateSm = delegate
        
        return VC
    }
    
}
