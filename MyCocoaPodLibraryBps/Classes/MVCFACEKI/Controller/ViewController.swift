//
//  ViewController.swift
//  FaceKi
//
//  Created by Logictrix on 28/10/21.
//

import UIKit

class ViewController: BaseViewController {
        
    @IBOutlet weak var scanbleDcosTabl: UITableView!
    
    var scanDocsArray = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let emptyImagesArry = [UIImage]()
        CommonFunctions.archive(customObject: emptyImagesArry, keyName: "FrontScanImages")
        CommonFunctions.archive(customObject: emptyImagesArry, keyName: "BackScanImages")
        
        DataManager.isFromtScanComplete = false
        DataManager.isBackScanComplete = false
        
        getUserTokenApiHit()
        
        scanbleDcosTabl.register(UINib(nibName: "DocsTableViewCell", bundle: frameworkBundle), forCellReuseIdentifier: "DocsTableViewCell")
        scanbleDcosTabl.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    //MARK:- get User Token Api Hit
    func getUserTokenApiHit(){
        self.startLoaderGif(isLoaderStart: true)
        ApiManager.shared.getAuthTokenApi(email: "demo@faceki.com",
                                        currentVC: self, onSuccess: { (response) in
                        print("get User Token Api Hit Response ",response)
                if let token = response["token"] as? String {
                    authorizationTokken = token
                    self.getSDKsettingsApiHit()
                }
        })
    }
    
    //MARK:- get SDK Settings Api Hit
    func getSDKsettingsApiHit(){
        self.startLoaderGif(isLoaderStart: true)
        ApiManager.shared.getSDKsettingsApi(currentVC: self, onSuccess: { (response) in
            self.startLoaderGif(isLoaderStart: false)
            print("get SDK Settings Api Response ",response)
            let status = response["success"] as! Int
            if status == 1 {
                objUser.parseSDKsettingsData(responseDict: response["response"] as? Dictionary ?? [:])
                self.updateScanDocOrder()
            }
        })
    }
    
    func updateScanDocOrder(){
        scanDocsArray.removeAll()
        scanDocsArray = CommonFunctions.getDocorder()
        scanbleDcosTabl.reloadData()
    }
    
    @IBAction func startBtnAction(_ sender: Any) {
        DataManager.passportDocNumber = 0
        if DataManager.docTypeOne == "Passport" {
            DataManager.passportDocNumber = 1
        }
        else if DataManager.docTypeTwo == "Passport" {
            DataManager.passportDocNumber = 2
        }
        else if DataManager.docTypeThree == "Passport" {
            DataManager.passportDocNumber = 3
        }
        let vc = Storyboard.instantiateViewController(withIdentifier: "CameraSCannerVC") as! CameraSCannerVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scanDocsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocsTableViewCell", for: indexPath) as! DocsTableViewCell
        
        let dict = scanDocsArray[indexPath.item]
        if dict["docName"] as? String ?? "Scan ID front side" == "Take a selfie picture"{
            cell.imageWidth.constant = 60
            cell.lblLeading.constant = 35
            cell.imageLeading.constant = 40
        }
        
        cell.seriesLbl_1.text = "\(indexPath.item+1)"
        
        let img = UIImage(named: dict["imageName"] as? String ?? "Scan ID front side", in: resourcesBundleImg, compatibleWith: nil)
        cell.docPhotoVw_1.image = img
        
        cell.docTextLbl_1.text = dict["docName"] as? String ?? "Scan ID front side"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
