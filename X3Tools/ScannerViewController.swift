//
//  ScannerViewController.swift
//  X3Tools
//
//  Created by Alex Hirzel on 5/24/18.
//  Copyright © 2018 Alex Hirzel. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var query: String!
    var pallet: Pallet!
    
    var statusHeight: CGFloat = 0.0;
    var defaultSearchViewY: CGFloat = 0.0;
    
    @IBOutlet weak var queryInputField: UITextField!
    
    //Establish connections for the various views. These will be necessary later
    @IBOutlet weak var contentView: UIStackView!
    @IBOutlet weak var videoPreviewView: UIView!
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set and format the placeholder text on the search field
        queryInputField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)])
        
        //Hide the search button when the view first loads
        searchButton.isHidden = true
        
        //Add observers for the keyboard. This allows us to change formatting when the keyboard appears
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        captureSession = AVCaptureSession()
        
        // If the device has a camera, initialize it and establish the capture session output as a Code 39 barcode. More barcode types can be added.
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {return}
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            //Add additional barcode types to this array
            metadataOutput.metadataObjectTypes = [.code39]
        } else {
            failed()
            return
        }
        
        //Add the video preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = videoPreviewView.layer.frame
        previewLayer.bounds = videoPreviewView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        videoPreviewView.layer.addSublayer(previewLayer)

        //Start the capture session
        captureSession.startRunning()
        
        self.queryInputField.delegate = self


    } //End viewDidLoad
    
    //If the view is loading, and the capture session has not started, start the capture session
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            (captureSession.startRunning())
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        defaultSearchViewY = searchView.frame.origin.y;
        statusHeight =  UIApplication.shared.statusBarFrame.size.height;
    }
    
    //If the view is unloading, and the capture session hasn't stopped, stop the capture session
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    //If the capture session has stopped, the user can touch anywhere on the screen to start it again
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    //Failure message when the device cannot initialize the camera
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support barcode scanning. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    //Collect metadata captured by the camera
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        //Check to make sure that the object received is a string
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            //If the string starts with an "L" (such as on location stickers), strip off the L, and assign the string to the query display text field
            var query: String = stringValue
            print("query: \(query)")
            if query.starts(with: "L") {
                query.removeFirst()
            }
            queryInputField.text = query
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            found(code: stringValue)
        }
        
    }
    
    //Set the query to the found metadata object, and if the query is greater than 7 characters, enable the search button
    func found(code: String) {
        print(code)
        
        self.query = code
        
        // This was used to test for an actual product before leaving this screen. It was removed to reduce unecessary server queries. It could be added again
//        if query.starts(with: "L") || query.count == 7 {
//            print(query)
//            let location = LocationLookup()
//            location.fetchItems(matching: query) { (location) in
//                print(location ?? "")
//                DispatchQueue.main.async {
//                    self.searchButton.isHidden = false
//                }
//            }
//        } else {
//            let palnum = Palnum()
//            palnum.fetchItems(matching: query, completion: { (pallet) in
//                if let pallet = pallet {
//                    print(pallet)
//                    self.pallet = pallet
//                    DispatchQueue.main.async {
//                        self.searchButton.isHidden = false
//                    }
//                }
//            })
//        }
    }

    //When the keyboard appears, adjust the position of the saerch field, and hide the capture button
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var origin = searchView.frame.origin;
            
            origin.y = keyboardSize.origin.y - searchView.frame.size.height - statusHeight;
            
            searchView.frame = CGRect(origin: origin, size: searchView.frame.size);
            
            captureButton.isHidden = true
        }
    }
    
    //When the keyboard disappears, adjust the position of the saerch field, and display the capture button
    @objc func keyboardWillHide(notification: NSNotification) {
        searchView.frame.origin.y = defaultSearchViewY;
        
        captureButton.isHidden = false;
    }
    
    //Hide the keyboard when the users presses the done key on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Lock the capture to portrait orientation. Currently the entire app is locked to portrait orientation, but if that were to change, this should remain. Shifting to landscape mode with an active capture session can cause unusual behavior.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //Set the status bar to light text, dark background
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //Prepare for segue by capturing anything from the input field to the query
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !(queryInputField.text?.isEmpty)! {
            query = queryInputField.text
        }

    }
    
    //When the user edits the input field, check the length, and when 7 or more characters are entered, run the Found function
    @IBAction func queryFieldEdited(_ sender: Any) {
        let input = queryInputField.text
        
        if (input?.count)! >= 7 {
            found(code: queryInputField.text!)
            DispatchQueue.main.async {
                self.searchButton.isHidden = false
            }
        } else {
            DispatchQueue.main.async {
                self.searchButton.isHidden = true
            }
        }
        
    }
    
}
