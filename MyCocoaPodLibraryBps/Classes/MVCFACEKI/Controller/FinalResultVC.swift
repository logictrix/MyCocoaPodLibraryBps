//
//  FinalResultVC.swift
//  FaceKi
//
//  Created by Logictrix on 03/11/21.
//

import UIKit

class FinalResultVC: UIViewController {

    
    @IBOutlet weak var imageGifVw: UIView!
    
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var resulInfotLbl: UILabel!
    @IBOutlet weak var linkLbl: UILabel!
    
    var dictionaryContent = [String:Any]()
    var isSuccess = Bool()
    var errorMsg = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isSuccess == true {
            linkLbl.isHidden = true
            startLoaderGif(gifName: "24-approved-checked-outline")
            resultLbl.text = "SUCCESSFUL"
            resulInfotLbl.text = "\(DataManager.successMeaasge ?? "Process is complete check dashboard for details.")"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                guard let url = URL(string: "\(DataManager.successRedirectUrl!)") else { return }
                UIApplication.shared.open(url)
            }
        }
        else {
            linkLbl.isHidden = false
            linkLbl.text = errorMsg
            startLoaderGif(gifName: "25-error-cross-outline")
            resultLbl.text = "DECLINED"
            resulInfotLbl.text = "\(DataManager.declinedMessage ?? "Process is complete check dashboard for details.")"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                guard let url = URL(string: "\(DataManager.declinedRedirectUrl!)") else { return }
                UIApplication.shared.open(url)
            }
        }
        
        let emptyImagesArry = [UIImage]()
        CommonFunctions.archive(customObject: emptyImagesArry, keyName: "FrontScanImages")
        CommonFunctions.archive(customObject: emptyImagesArry, keyName: "BackScanImages")
    }
    
//    func navigateAfterScan(){
//        if numberOfScannedDoc < DataManager.numberOfDoc! {
//            DataManager.isFromtScanComplete = false
//            DataManager.isBackScanComplete = false
//
//            let vc = Storyboard.instantiateViewController(withIdentifier: "CameraSCannerVC") as! CameraSCannerVC
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
    
    func startLoaderGif(gifName: String){
        DispatchQueue.main.async {
        do {
                let gif = try UIImage(gifName: gifName)
                let imageview = UIImageView(gifImage: gif, loopCount: 3) // Will loop 3 times
                imageview.frame = self.imageGifVw.bounds
                self.imageGifVw.addSubview(imageview)
            
        } catch {
            print(error)
        }
        }
    }

}
