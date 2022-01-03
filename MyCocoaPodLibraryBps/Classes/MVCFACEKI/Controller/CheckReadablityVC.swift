//
//  CheckReadablityVC.swift
//  FaceKi
//
//  Created by Logictrix on 03/11/21.
//

import UIKit

class CheckReadablityVC: UIViewController {

    @IBOutlet weak var powerByImgView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    var captureImage = UIImage()
    
    var frontSideScanedImagesArry = [UIImage]()
    var backSideScanedImagesArry = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = captureImage
        
        frontSideScanedImagesArry.removeAll()
        frontSideScanedImagesArry = CommonFunctions.getTargetList(keyName: "FrontScanImages")
        print("frontSideScanedImagesArry append",frontSideScanedImagesArry)
        
        backSideScanedImagesArry.removeAll()
        backSideScanedImagesArry = CommonFunctions.getTargetList(keyName: "BackScanImages")
        print("backSideScanedImagesArry append",backSideScanedImagesArry)
        
        let imgPowerBy = UIImage(named: "appstore", in: resourcesBundleImg, compatibleWith: nil)
        powerByImgView.image = imgPowerBy
    }
    
    @IBAction func retakeBtnAction(_ sender: Any) {
        performSegueToReturnBack()
    }
    
    @IBAction func confirmBtnAction(_ sender: Any) {
        if DataManager.isFromtScanComplete == false {
            DataManager.isFromtScanComplete = true
            
            frontSideScanedImagesArry.append(captureImage)
            
            CommonFunctions.archive(customObject: self.frontSideScanedImagesArry, keyName: "FrontScanImages")
            print("DataManager.passportDocNumber ", DataManager.passportDocNumber!)
            if (DataManager.passportDocNumber == numberOfScannedDoc+1) && (DataManager.passportDocNumber! > 0) {
                passportScanDirect()
            }
            else {
                let vc = Storyboard.instantiateViewController(withIdentifier: "CameraSCannerVC") as! CameraSCannerVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if DataManager.isBackScanComplete == false {
            DataManager.isBackScanComplete = true

            numberOfScannedDoc += 1
            print("numberOfScannedDoc ",numberOfScannedDoc)
            
            backSideScanedImagesArry.append(captureImage)
            
            CommonFunctions.archive(customObject: self.backSideScanedImagesArry, keyName: "BackScanImages")
            
            if numberOfScannedDoc == DataManager.numberOfDoc {
                let vc = Storyboard.instantiateViewController(withIdentifier: "TakeSelfieVC") as! TakeSelfieVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                DataManager.isFromtScanComplete = false
                DataManager.isBackScanComplete = false
                let vc = Storyboard.instantiateViewController(withIdentifier: "CameraSCannerVC") as! CameraSCannerVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    

    func passportScanDirect(){
        DataManager.isBackScanComplete = true

        backSideScanedImagesArry.append(captureImage)
        CommonFunctions.archive(customObject: self.backSideScanedImagesArry, keyName: "BackScanImages")
        
        numberOfScannedDoc += 1
        print("numberOfScannedDoc ",numberOfScannedDoc)
        
        if numberOfScannedDoc == DataManager.numberOfDoc {
            let vc = Storyboard.instantiateViewController(withIdentifier: "TakeSelfieVC") as! TakeSelfieVC
            vc.backSideScanedImagesArry = backSideScanedImagesArry
            vc.frontSideScanedImagesArry = frontSideScanedImagesArry
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            DataManager.isFromtScanComplete = false
            DataManager.isBackScanComplete = false
            let vc = Storyboard.instantiateViewController(withIdentifier: "CameraSCannerVC") as! CameraSCannerVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
