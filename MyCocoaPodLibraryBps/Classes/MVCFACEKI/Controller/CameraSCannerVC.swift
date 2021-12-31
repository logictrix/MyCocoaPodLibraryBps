//
//  CameraSCannerVC.swift
//  FaceKi
//
//  Created by Logictrix on 03/11/21.
//
//var frontSideImage = UIImage()
//var backSideSideImage = UIImage()

class PassableUIButton: UIButton{
    var params: Dictionary<String, Any>
    override init(frame: CGRect) {
        self.params = [:]
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.params = [:]
        super.init(coder: aDecoder)
    }
}


import UIKit
import AVKit
import AVFoundation
import Vision

class CameraSCannerVC: UIViewController {

    @IBOutlet weak var sidePlaceholderImgView: UIImageView!
    @IBOutlet weak var headTitleLbl: UILabel!
    @IBOutlet weak var sideTextLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var backCamView: UIView!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var videoCaptureDevice: AVCaptureDevice?
    var input: AnyObject?
    
    var isFrontCameraOn = false
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
    
    private var isTapped = false
    private var maskLayer = CAShapeLayer()
    var cardRectangle = VNDetectRectanglesRequest()
    
    var viewAd = PassableUIButton()
    var isCapturePressed = Bool()
    
    var scannerTimer: Timer?
    
//    var frontSideScanedImagesArry = [UIImage]()
//    var backSideScanedImagesArry = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        backCamView.addGestureRecognizer(tap)
        logoTopConstraint.constant = UIScreen.main.bounds.height*0.35
      setLayoutValues()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        scannerTimer?.invalidate()
    }
    
    func startTimer() {
        scannerTimer = Timer.scheduledTimer(timeInterval: 0.5,
                                     target: self,
                                     selector: #selector(eventWith(timer:)),
                                     userInfo: [ "test" : "iOS" ],
                                     repeats: true)
    }
    // Timer expects @objc selector
    @objc func eventWith(timer: Timer!) {
        if self.sideTextLbl.textColor == .white {
            self.sideTextLbl.textColor = .green
        }
        else {
            self.sideTextLbl.textColor = .white
        }
    }
    
    func setLayoutValues(){
        headTitleLbl.text = CommonFunctions.getHeadTitleText()
        
        if headTitleLbl.text == "Scan your ID Card" {
            if DataManager.isFromtScanComplete == true {
                sidePlaceholderImgView.image = UIImage(named: "BACK SIDE -2")
                sideTextLbl.text = "BACK SIDE"
            }
            else {
                sidePlaceholderImgView.image = UIImage(named: "FRONT SIDE- 2")
                sideTextLbl.text = "FRONT SIDE"
            }
        }
        else if headTitleLbl.text == "Scan your Passport" {
            sidePlaceholderImgView.image = UIImage(named: "Passport")
            sideTextLbl.text = "PASSPORT"
        }
        else if headTitleLbl.text == "Scan your Driving License" {
            if DataManager.isFromtScanComplete == true {
                sidePlaceholderImgView.image = UIImage(named: "Driving back")
                sideTextLbl.text = "BACK SIDE"
            }
            else {
                sidePlaceholderImgView.image = UIImage(named: "Driving Front")
                sideTextLbl.text = "FRONT SIDE"
            }
        }
        infoLbl.text = CommonFunctions.getInfoLabelText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        landscape = false
        isRotation = true
       
        DispatchQueue.main.async {
            print("View Will Appaper")
            self.startCamera(caputreMode: "Potrait")
            self.session?.startRunning()
        }
        startTimer()
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
//            previewLayer?.frame = smalkamVw.layer.bounds
           
            previewLayer?.frame = backCamView.layer.bounds
        }
        else if landscape == true {
//            previewLayer?.frame = smalkamVw.layer.bounds
            
            previewLayer?.frame = backCamView.layer.bounds
        }
//        smalkamVw.layer.addSublayer(previewLayer!)
        
        backCamView.layer.addSublayer(previewLayer!)
        
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
    
    //MARK:- Camra Button Action
    @IBAction func camraBtnAction(_ sender: UIButton) {
        isCapturePressed = true
        detectFaces(img: imageCapture)
//        cameraActionMethod()
    }
    
    func cameraActionMethod(){
        session?.stopRunning()
        if isFrontCameraOn == true {
            isFrontCameraOn = false
        }
        else {
            isFrontCameraOn = true
        }
        startCamera(caputreMode: lastOreintationOfDevice)
        session?.startRunning()
    }

}

//MARK:- for output of camera
extension CameraSCannerVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    
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
        detectFaces(img: image)
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
        let request = VNDetectRectanglesRequest { (req, err)
            in
            if let err = err{
                print("Failed to detect faces !! \(err)")
                return
            }
            else {

                DispatchQueue.main.async {
                    self.backCamView.subviews.forEach({ (subview) in
                        
                        if self.backCamView.subviews.contains(subview) {
                            subview.removeFromSuperview() // Remove it
                        } else {
                            // Do Nothing
                        }
                        
                    })
                }
                
                if let landmarksResults = self.cardRectangle.results as? [VNDetectedObjectObservation] {
                guard landmarksResults.first != nil else {return}
            }
         }
            req.results?.forEach({ (res) in
                // Get face observations
                guard let faceObservation = res as? VNDetectedObjectObservation else {return}
               
                DispatchQueue.main.async {
                    
//                        self.viewAd = self.createBttn()
//                        self.viewAd.frame = self.transformRect(fromRect: faceObservation.boundingBox, toViewRect: self.backCamView)
//
//                    print("self.viewAd.frame.origin.x ",self.viewAd.frame.origin.x)
//                    print("self.viewAd.frame.origin.y ",self.viewAd.frame.origin.y)
//                    print("self.viewAd.frame.width ",faceObservation.boundingBox.width)
//
////                        self.viewAd.addTarget(self, action: #selector(CameraSCannerVC.webButtonTouched(_:)), for: .touchDown)
//                        self.viewAd.params["img"] = img
//                        self.viewAd.params["BoundingBox"] = faceObservation.boundingBox
//                        self.viewAd.params["originX"] = faceObservation.boundingBox.origin.x
//                        self.viewAd.params["originY"] = faceObservation.boundingBox.origin.y
//                        self.viewAd.params["height"] = faceObservation.boundingBox.height
//                        self.viewAd.params["width"] = faceObservation.boundingBox.width
//
//
//                    print("self.viewAd.frame.origin.x AF",self.viewAd.frame.origin.x-20)
//                    print("self.viewAd.frame.origin.y AF",self.viewAd.frame.origin.y)
//                    print("self.viewAd.frame.width AF",faceObservation.boundingBox.width+40)
                    
                    if self.isCapturePressed == true {
                        self.isCapturePressed = false
                        self.session?.stopRunning()
                        self.setCropField(img: img, originX: faceObservation.boundingBox.origin.x, originY: faceObservation.boundingBox.origin.y, rectHeight: faceObservation.boundingBox.height, rectWidth: faceObservation.boundingBox.width)
                    }
                                        
                    self.backCamView.addSubview(self.viewAd)
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
        toRect.size.width = (fromRect.size.width * toViewRect.frame.size.width+10)
        
        toRect.size.height = (fromRect.size.height * toViewRect.frame.size.height)
        let origin = CGPoint(x: fromRect.minX * toViewRect.bounds.width,y: (1 - fromRect.minY) * toViewRect.bounds.height - toRect.size.height)
        toRect.origin.y = origin.y
        toRect.origin.x = origin.x-5
        
        return toRect
    }
    
    func setCropField(img: UIImage, originX: CGFloat, originY: CGFloat, rectHeight: CGFloat, rectWidth: CGFloat){
//        session?.stopRunning()
        var cropImag = UIImage()
        cropImag = cropImage(screenshot: img, originX: originX, originY: originY, getWidth: rectWidth, getHeight: rectHeight)
        print("cropImag :==>> ",cropImag)
        
        let vc = Storyboard.instantiateViewController(withIdentifier: "CheckReadablityVC") as! CheckReadablityVC
        vc.captureImage = cropImag
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // func cropImage(screenshot: UIImage, vw: CGRect) -> UIImage {
    func cropImage(screenshot: UIImage, originX: CGFloat, originY: CGFloat, getWidth: CGFloat, getHeight: CGFloat) -> UIImage {
        let cgimage = screenshot.cgImage!
        print("x", originX)
        print("y", originY)
        print("width", getWidth)
        print("height", getHeight)
        
        let width = getWidth * CGFloat(cgimage.width)
        let height = getHeight * CGFloat(cgimage.height)
        let x = originX * CGFloat(cgimage.width)
        let y = (1 - originY) * CGFloat(cgimage.height) - height
        
        print("x crop", x)
        print("y crop", y)
        print("width crop", width)
        print("height crop", height)
        
//        let croppingRect = CGRect(x: x-20, y: y-50, width: width+50, height: height+60)
        let croppingRect = CGRect(x: x-40, y: y-40, width: width+80, height: height+80)
        let faceImage = cgimage.cropping(to: croppingRect)
        let image: UIImage = UIImage(cgImage: faceImage!)
        
        return image
    }
    
}

extension CGPoint {
   func scaled(to size: CGSize) -> CGPoint {
       return CGPoint(x: self.x * size.width,
                      y: self.y * size.height)
   }
}
    
        



