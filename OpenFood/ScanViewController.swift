//
//  ScanViewController.swift
//  OpenFood
//
//  Created by MAFFINI Florian on 12/5/16.
//  Copyright © 2016 MAFFINI Florian. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
        
    var session: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var ARFrameView: UIVisualEffectView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Scan a product"
        
        // Create a session object.
        session = AVCaptureSession()
        
        // Set the captureDevice.
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // Create input object.
        let videoInput: AVCaptureDeviceInput?
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            alertNoCamera()
            return
        }
        
        // Add input to the session.
        if (session.canAddInput(videoInput)) {
            session.addInput(videoInput)
        } else {
            alertNoCamera()
            return
        }
        
        // Create output object.
        let metadataOutput = AVCaptureMetadataOutput()
        
        // Add output to the session.
        if (session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)
            
            // Send captured data to the delegate object via a serial queue.
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Set barcode type for which to scan: EAN-13.
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code]
            
        } else {
            alertNoCamera()
        }
        
        // Add previewLayer and have it show the video data.
        previewLayer = AVCaptureVideoPreviewLayer(session: session);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        
        // Add Augmented Reality View
        //ARFrameView = UIView()
        //ARFrameView.layer.borderColor = UIColor.green.cgColor
        //ARFrameView.layer.borderWidth = 2
        //view.addSubview(ARFrameView)
        view.bringSubview(toFront: ARFrameView)
        ARFrameView.frame = CGRect.zero
        
        // Begin the capture session.
        session.startRunning()

    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // Get the first object from the metadataObjects array.
        if let barcodeData = metadataObjects.first {
            // Turn it into machine readable code
            if let readableCode = barcodeData as? AVMetadataMachineReadableCodeObject {
                
                // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
                let formerFrame = ARFrameView.frame
                let bounds = (previewLayer.transformedMetadataObject(for: readableCode))!.bounds
                let width = CGFloat(smooth(Float(bounds.width), Float(formerFrame.width)))
                let frame = CGRect(
                    x: CGFloat(smooth(Float(bounds.minX), Float(formerFrame.minX))),
                    y: CGFloat(smooth(Float(bounds.minY - width/4), Float(formerFrame.minY))),
                    width: width,
                    height: width/2
                )
                
                ARFrameView.frame = frame
                
                return;
                
                // Send the barcode as a string to barcodeDetected()
                barcodeDetected(readableCode.stringValue);
            }
            
            // Vibrate the device to give the user some feedback.
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            // Avoid a very buzzy device.
            session.stopRunning()
        } else {
            ARFrameView.frame = CGRect.zero
        }
        

    }
    
    func smooth (_ demand: Float, _ forecast: Float, factor: Float = 0.2) -> Float {
        return (demand * factor) + (forecast * (1 - factor))
    }
    
    func barcodeDetected(_ code: String) {
        
        // Let the user know we've found something.
        let alert: UIAlertController = self.alertSearchProduct()

        // Instantiate a detail view controller
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail") as! DetailViewController
        
        // Remove the spaces.
        let trimmedCode = code.trimmingCharacters(in: CharacterSet.whitespaces)
        
        // EAN or UPC?
        // Check for added "0" at beginning of code.
        
        let trimmedCodeString = "\(trimmedCode)"
        var trimmedCodeNoZero: String
        
        if trimmedCodeString.hasPrefix("0") && trimmedCodeString.characters.count > 1 {
            trimmedCodeNoZero = String(trimmedCodeString.characters.dropFirst())
            
            // Send the doctored UPC to DataService.searchAPI()
            FoodDataService.getProduct(trimmedCodeNoZero, callback: { (product) in
                
                if let product = product {

                    detailViewController.food = Food.fromDictionnary(product)

                    DispatchQueue.main.async {
                        alert.dismiss(animated: true, completion: nil)
                        let pageViewController = self.navigationController?.parent as! UIPageViewController
                        let pvc = pageViewController.delegate as! PageViewController
                        pvc.disable ()
                        self.navigationController?.pushViewController(detailViewController, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                          alert.dismiss(animated: true, completion: {
                            self.alertNoProduct(code)
                        })
                    }
                }
            })
        } else {
            
            // Send the doctored EAN to DataService.searchAPI()
            FoodDataService.getProduct(trimmedCodeString, callback: { (product) in
                

                if let product = product {

                    detailViewController.food = Food.fromDictionnary(product)
                    
                    
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true, completion: nil)
                        let pageViewController = self.navigationController?.parent as! UIPageViewController
                        let pvc = pageViewController.delegate as! PageViewController
                        pvc.disable ()
                        self.navigationController?.pushViewController(detailViewController, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true, completion: {
                            self.alertNoProduct(code)
                        })
                    }
                }
            })
        }
        
    }
    
    func alertNoCamera() -> UIAlertController {
        // Let the user know that scanning isn't possible with the current device.
        let alert = UIAlertController(title: "Can't Scan.", message: "Let's try a device equipped with a camera.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.session = nil

        DispatchQueue.main.async {
            self.view.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }

        return alert;
    }

    func alertSearchProduct() -> UIAlertController {
        let alert = UIAlertController(title: "Found a barcode", message: "Looking for the product...\n\n", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
            alert.dismiss(animated: true, completion: nil)
            if (self.session?.isRunning == false) {
                self.session.startRunning()
            }
        }))

        // Start waiting with a loading indicator
        let loadingIndicator = UIActivityIndicatorView(frame: alert.view.bounds) as UIActivityIndicatorView
        //loadingIndicator.center = alert.view.center;
        loadingIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()

        DispatchQueue.main.async {
            self.view.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
        return alert
    }

    func alertNoProduct(_ code: String) -> UIAlertController {
        let alert = UIAlertController(title: "No product found", message: "for \(code)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
            if (self.session?.isRunning == false) {
                self.session.startRunning()
            }
        }))

        self.view.window?.rootViewController?.present(alert, animated: true, completion: nil)

        return alert
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (session?.isRunning == false) {
            session.startRunning()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let pageViewController = self.navigationController?.parent as! UIPageViewController
        let pvc = pageViewController.delegate as! PageViewController
        pvc.enable()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.layer.bounds;
    }

}
