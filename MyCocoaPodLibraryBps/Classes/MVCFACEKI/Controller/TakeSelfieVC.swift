//
//  TakeSelfieVC.swift
//  FaceKi
//
//  Created by Logictrix on 03/11/21.
//

import UIKit
import AVKit
import AVFoundation
import Vision

class TakeSelfieVC: BaseViewController {

    @IBOutlet weak var camView: UIView!
    
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var videoCaptureDevice: AVCaptureDevice?
    var input: AnyObject?
    
    var isFrontCameraOn = true
    var session: AVCaptureSession?
    
    lazy var previewLayer: AVCaptureVideoPreviewLayer? = {
        guard let session = self.session else { return nil }

        var previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill

        return previewLayer
    }()
    
    var frontCamera: AVCaptureDevice? = {
        return AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
    }()
    
    var isRotation = true
    var landscape = false
    var lastOreintationOfDevice = "Portrait"
    var imageCapture = UIImage()
    
    let captureSession = AVCaptureSession()
    let movieOutput = AVCaptureMovieFileOutput()
    var activeInput: AVCaptureDeviceInput!
    
    var viewAd = PassableUIButton()
    let faceLandmarks = VNDetectFaceLandmarksRequest()
    
    var screenName = String()
    var isFaceDetect = Bool()
    
    var frontSideScanedImagesArry = [UIImage]()
    var backSideScanedImagesArry = [UIImage]()
    var isSuccess = true
    var errorMsg = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frontSideScanedImagesArry.removeAll()
        frontSideScanedImagesArry = CommonFunctions.getTargetList(keyName: "FrontScanImages")
        print("frontSideScanedImagesArry append",frontSideScanedImagesArry)
        
        backSideScanedImagesArry.removeAll()
        backSideScanedImagesArry = CommonFunctions.getTargetList(keyName: "BackScanImages")
        print("backSideScanedImagesArry append",backSideScanedImagesArry)
        
        print("frontSideScanedImagesArry.count ",frontSideScanedImagesArry.count)
        print("backSideScanedImagesArry.count ",backSideScanedImagesArry.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        landscape = false
        isRotation = true
       
        DispatchQueue.main.async {
            print("View Will Appaper")
            self.startCamera(caputreMode: "Potrait")
            self.session?.startRunning()
        }
    }
    
    //MARK:- Camra Button Action
    @IBAction func camraBtnAction(_ sender: UIButton) {
        detectFaces(img: imageCapture)
    }
    
    func startCamera(caputreMode: String){
        session = AVCaptureSession()
        session?.sessionPreset = AVCaptureSession.Preset.high
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session!)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.name = "prevVideolayer"
        var agle_Rotate = CGFloat()   ////////// for orientation of video //////
        //agle_Rotate = degreeToRadian(0)
        lastOreintationOfDevice = caputreMode
            if caputreMode == "LandscapeLeft" {
                agle_Rotate = degreeToRadian(-90)
            }
            else if caputreMode == "LandscapeRight" {
                agle_Rotate = degreeToRadian(90)
            }
            else  {
                agle_Rotate = degreeToRadian(0)
            }
        let affineTransform = CGAffineTransform(rotationAngle: agle_Rotate)
        previewLayer?.setAffineTransform(affineTransform)  ////////// for orientation of video //////
    
        if landscape == false {
            previewLayer?.frame = camView.layer.bounds
        }
        else if landscape == true {
//            previewLayer?.frame = self.view.layer.bounds
            previewLayer?.frame = camView.layer.bounds
        }
        camView.layer.addSublayer(previewLayer!)
        
       if isFrontCameraOn == true {
          self.videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,for: .video, position: .front)
        }
        else {
           self.videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,for: .video, position: .back)
        }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: self.videoCaptureDevice!)
            session?.beginConfiguration()
            
            if (session?.canAddInput(deviceInput))! {
                session?.addInput(deviceInput)
            }
            
            let output = AVCaptureVideoDataOutput()
            output.videoSettings = [
                String(kCVPixelBufferPixelFormatTypeKey) : Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
            ]
            output.alwaysDiscardsLateVideoFrames = true
            if (session?.canAddOutput(output))! {
                session?.addOutput(output)
            }
            
            session?.commitConfiguration()
            let queue = DispatchQueue(label: "output1.queue")
            output.setSampleBufferDelegate(self, queue: queue)
            print("setup delegate")
            
        }
        catch {
            print("video device error")
        }
    }
    
    func degreeToRadian(_ x: CGFloat) -> CGFloat {
        return .pi * x / 180.0
    }
    
}

//MARK:- for output of camera
extension TakeSelfieVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let attachments = CMCopyDictionaryOfAttachments(allocator: kCFAllocatorDefault, target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate)
        let ciImage = CIImage(cvImageBuffer: pixelBuffer!, options: attachments as! [CIImageOption : Any]?)
        
        //leftMirrored for front camera
        let ciImageWithOrientation = ciImage.oriented(forExifOrientation: Int32(UIImage.Orientation.leftMirrored.rawValue))
        
        var image = UIImage()
        if lastOreintationOfDevice == "LandscapeLeft" {
            image = convert(cmage:ciImage)
        }
        else if lastOreintationOfDevice == "LandscapeRight" {
            image = convert(cmage: ciImage.oriented(forExifOrientation: Int32(UIImage.Orientation.right.rawValue)))
        }
        else {
            image = convert(cmage:ciImageWithOrientation)
        }
        
        DispatchQueue.main.async {
//            self.headImag.image = image
        }
        imageCapture = image
//        detectFaces(img: image)
    }
    
    //MARK:- Coverting CGImage into UIImage
    func convert(cmage:CIImage) -> UIImage    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    
    
    func detectFaces(img: UIImage){
        // Create Face Detection Request
        let request = VNDetectFaceRectanglesRequest { (req, err)
            in
            if let err = err{
                print("Failed to detect faces !! \(err)")
                return
            }
            else {

                DispatchQueue.main.async {
                    self.camView.subviews.forEach({ (subview) in
                        
                        if self.camView.subviews.contains(subview) {
                            subview.removeFromSuperview() // Remove it
                        } else {
                            // Do Nothing
                        }
                        
                    })
                }
                
                if let landmarksResults = self.faceLandmarks.results as? [VNFaceObservation] {
                guard landmarksResults.first != nil else {return}
            }
         }
            req.results?.forEach({ (res) in
                // Get face observations
                guard let faceObservation = res as? VNFaceObservation else {return}
               
                DispatchQueue.main.async {
                        self.viewAd = self.createBttn()
                        self.viewAd.frame = self.transformRect(fromRect: faceObservation.boundingBox, toViewRect: self.camView)
                                        
                    print("self.viewAd.frame.origin.y ",self.viewAd.frame.origin.y)
                    
//                        self.viewAd.addTarget(self, action: #selector(CameraSCannerVC.webButtonTouched(_:)), for: .touchDown)
                        self.viewAd.params["img"] = img
                        self.viewAd.params["BoundingBox"] = faceObservation.boundingBox
                        self.viewAd.params["originX"] = faceObservation.boundingBox.origin.x
                        self.viewAd.params["originY"] = faceObservation.boundingBox.origin.y
                        self.viewAd.params["height"] = faceObservation.boundingBox.height
                        self.viewAd.params["width"] = faceObservation.boundingBox.width
                    
                    self.setCropField(img: img, originX: faceObservation.boundingBox.origin.x, originY: faceObservation.boundingBox.origin.y, rectHeight: faceObservation.boundingBox.height, rectWidth: faceObservation.boundingBox.width)
                    
                    self.camView.addSubview(self.viewAd)
                                        
                }
            })
        }
        
        // Convert Image to cgImage and pass to request handler
        let cgImage = img.cgImage
        let handler = VNImageRequestHandler(cgImage: cgImage!, options: [:])
        
        // Perform vision request
        do{
            try handler.perform([request])
           // print("[request]:=> ",[request])
        }
        catch let reqErr{
            print("Failed to perform request: \(reqErr)")
        }
  }
    
    func navigateToScreen(cropedImage: UIImage){
        if frontSideScanedImagesArry.count > 0 {
            self.startLoaderGif(isLoaderStart: true)
            kycVerificationApiHit(faceImage: cropedImage, frontSideImage: frontSideScanedImagesArry[0], backSideSideImage: backSideScanedImagesArry[0])
        }
    }
    
    func createBttn() -> PassableUIButton {
        let view = PassableUIButton()
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.borderWidth = 2
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.dropShadow(color: .red, opacity: 1, offSet: CGSize(width: -100, height: 100), radius: 3, scale: false)
        return view
    }

    //Convert Vision Frame to UIKit Frame
    func transformRect(fromRect: CGRect , toViewRect :UIView) -> CGRect {
        
        var toRect = CGRect()
        toRect.size.width = (fromRect.size.width * toViewRect.frame.size.width)
        
        toRect.size.height = (fromRect.size.height * toViewRect.frame.size.height)
        let origin = CGPoint(x: fromRect.minX * toViewRect.bounds.width,y: (1 - fromRect.minY) * toViewRect.bounds.height - toRect.size.height)
        toRect.origin.y = origin.y
        toRect.origin.x = origin.x
        
        return toRect
    }
    
    @objc func webButtonTouched(_ sender: PassableUIButton) {
        print(sender.params["img"] ?? "")
        session?.stopRunning()
            var cropImag = UIImage()
            let img = sender.params["img"] as! UIImage
            let rectX = sender.params["originX"] as! CGFloat
            let rectY = sender.params["originY"] as! CGFloat
            let rectHeight = sender.params["height"] as! CGFloat
            let rectWidth = sender.params["width"] as! CGFloat
        
            cropImag = cropImage(screenshot: img, originX: rectX, originY: rectY, getWidth: rectWidth, getHeight: rectHeight)
            print("cropImag :==>> ",cropImag)
        navigateToScreen(cropedImage: cropImag)
    }
    
    // func cropImage(screenshot: UIImage, vw: CGRect) -> UIImage {
    func cropImage(screenshot: UIImage, originX: CGFloat, originY: CGFloat, getWidth: CGFloat, getHeight: CGFloat) -> UIImage {
        let cgimage = screenshot.cgImage!
        print("x", originX)
        print("y", originY)
        print("height", getWidth)
        print("width", getHeight)
        
        let width = getWidth * CGFloat(cgimage.width)
        let height = getHeight * CGFloat(cgimage.height)
        let x = originX * CGFloat(cgimage.width)
        let y = (1 - originY) * CGFloat(cgimage.height) - height
        
        let croppingRect = CGRect(x: x-20, y: y-50, width: width+50, height: height+60)
        let faceImage = cgimage.cropping(to: croppingRect)
        let image: UIImage = UIImage(cgImage: faceImage!)
        
        return image
    }
    
    func setCropField(img: UIImage, originX: CGFloat, originY: CGFloat, rectHeight: CGFloat, rectWidth: CGFloat){
        session?.stopRunning()
            var cropImag = UIImage()
            cropImag = cropImage(screenshot: img, originX: originX, originY: originY, getWidth: rectWidth, getHeight: rectHeight)
            print("cropImag :==>> ",cropImag)
//        navigateToScreen(cropedImage: cropImag)
        navigateToScreen(cropedImage: img)
    }
        
    //MARK:- kYC Verification Api Hit
    func kycVerificationApiHit(faceImage: UIImage, frontSideImage: UIImage, backSideSideImage: UIImage){
        
        var imagesData = [Data]()
        
        if let imageDataFrontSide = frontSideImage.jpeg(.high) {
            imagesData.append(imageDataFrontSide)
        }
        if let imageDataBackSide = backSideSideImage.jpeg(.high) {
            imagesData.append(imageDataBackSide)
        }
        if let imageDataFaceImage = faceImage.jpeg(.medium) {
            imagesData.append(imageDataFaceImage)
        }
        
//        imagesData.append(faceImage.pngData()!)
//        imagesData.append(frontSideImage.pngData()!)
//        imagesData.append(backSideSideImage.pngData()!)
        
        let params:[String: Any] = ["doc_front_image":frontSideImage,
             "doc_back_image":backSideSideImage,
            "selfie_image":faceImage]

        var imgParam = [String]()
        imgParam.append("doc_front_image")
        imgParam.append("doc_back_image")
        imgParam.append("selfie_image")
        AlamoFireWrapper.sharedInstance.verificationDocMultipartApiHit(action: kycVerificationUrl, imagesData: imagesData, fetchImageParamNameArray: imgParam, view: self.view, param: params, withName: "", fileName: "", mimeType: "", onSuccess: { (response) in
            
            switch(response.result) {
            case .success(let value):
                //                print("value = ",value)
                let  dictionaryContent = value as? [String:Any] ?? [:]
                print("kYC Verification Api Hit Response ",dictionaryContent)
                
                let error = dictionaryContent["error"] as? String ?? ""
                let status = dictionaryContent["status"] as? String ?? ""
                let status2 = dictionaryContent["status"] as? Int ?? -1
                
                if status == "Failed" || status2 == 0 || error == "Authentication failed..." {
                    self.isSuccess = false
                    if error == "Authentication failed..." {
                        self.errorMsg = "Authentication failed..."
                    }
                    else {
                        self.errorMsg = dictionaryContent["message"] as? String ?? ""
                    }
                }
            
//                if status != "Failed" && status2 != 0  {
//
//                }
//                if self.isSuccess == true {
                    self.frontSideScanedImagesArry.remove(at: 0)
                    self.backSideScanedImagesArry.remove(at: 0)
                    if self.frontSideScanedImagesArry.count > 0 {
                        self.kycVerificationApiHit(faceImage: faceImage, frontSideImage: self.frontSideScanedImagesArry[0], backSideSideImage: self.backSideScanedImagesArry[0])
                    }
                    else {
                        CommonFunctions.archive(customObject: self.frontSideScanedImagesArry, keyName: "FrontScanImages")
                        CommonFunctions.archive(customObject: self.backSideScanedImagesArry, keyName: "BackScanImages")
                        
                        self.startLoaderGif(isLoaderStart: false)
                        let vc = Storyboard.instantiateViewController(withIdentifier: "FinalResultVC") as! FinalResultVC
                        vc.dictionaryContent = dictionaryContent
                        vc.isSuccess = self.isSuccess
                        vc.errorMsg = self.errorMsg
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
//                }
                
                break
            case .failure(_):
                
                print("do nothing")
            }
        }) { (error) in
            
            self.startLoaderGif(isLoaderStart: false)
//            CommonFunctions.dismissProgressView(view: self.view)
            print(error.localizedDescription)
            CommonFunctions.showAlert(self, message: error.localizedDescription, title: "Error!")
            
            DispatchQueue.main.async {
                print("View Will Appaper")
                self.startCamera(caputreMode: "Potrait")
                self.session?.startRunning()
            }
        }
    }
    
    func showAlert(message: String){
        let alertController = UIAlertController(title: appName, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            //self.performSegueToReturnBack()
            DispatchQueue.main.async {
                self.startCamera(caputreMode: "Potrait")
                self.session?.startRunning()
            }
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

class CustomOval: UIView {

    override func draw(_ rect: CGRect) {
        let ovalPath = UIBezierPath(ovalIn: rect)
        UIColor.clear.setFill()
        ovalPath.fill()
    }
}

