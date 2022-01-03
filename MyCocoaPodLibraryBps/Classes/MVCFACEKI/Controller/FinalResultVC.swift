//
//  FinalResultVC.swift
//  FaceKi
//
//  Created by Logictrix on 03/11/21.
//

import UIKit

class FinalResultVC: UIViewController {

    @IBOutlet weak var resultImge: UIImageView!
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
//            startLoaderGif(gifName: "24-approved-checked-outline")
            
            let imgSucces = UIImage(named: "Successful", in: resourcesBundleImg, compatibleWith: nil)
            resultImge.image = imgSucces
            
            resultLbl.text = "SUCCESSFUL"
            resulInfotLbl.text = "\(DataManager.successMeaasge ?? "Process is complete check dashboard for details.")"
        }
        else {
            linkLbl.isHidden = false
            linkLbl.text = errorMsg
            
            let imgInvalid = UIImage(named: "Extra Check Required", in: resourcesBundleImg, compatibleWith: nil)
            resultImge.image = imgInvalid
            
//            startLoaderGif(gifName: "25-error-cross-outline")
            resultLbl.text = "DECLINED"
            resulInfotLbl.text = "\(DataManager.declinedMessage ?? "Process is complete check dashboard for details.")"
        }
        
        let emptyImagesArry = [UIImage]()
        CommonFunctions.archive(customObject: emptyImagesArry, keyName: "FrontScanImages")
        CommonFunctions.archive(customObject: emptyImagesArry, keyName: "BackScanImages")
    }
    
    @IBAction func backToHome(_ sender: Any) {
        self.navigateToStart()
    }
    
    func navigateToStart(){
        DataManager.isFromtScanComplete = false
        DataManager.isBackScanComplete = false
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
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
