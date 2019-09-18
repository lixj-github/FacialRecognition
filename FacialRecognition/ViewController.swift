//
//  ViewController.swift
//  FacialRecognition
//
//  Created by Xuejun Li on 9/16/19.
//  Copyright © 2019 Xuejun Li. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Converting image to CIImage failed")
            }
            
            detect(image: ciImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)

        
    }
    
    func detect(image: CIImage) {
        
        //        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
        //            fatalError("Loading CoreML Model Failed.")
        //        }
        guard let model = try? VNCoreMLModel(for: FacialMLModel3().model) else {
            fatalError("Loading Facial CoreML Model Failed.")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
            print(results.first)
            
//            if let firstResult = results.first {
//                if firstResult.identifier.contains("Pepsi CAN"){
//                    self.nameLabel.text = "Pepsi CAN"
//                }
//                else if firstResult.identifier.contains("Diet Pepsi CAN"){
//                    self.nameLabel.text = "Diet Pepsi CAN"
//                }
//                else if firstResult.identifier.contains("Pepsi PET"){
//                    self.nameLabel.text = "Pepsi PET"
//                }
//                else {
//                    self.nameLabel.text = "Other, Not Identified!"
//                }
//            }

            var confidence : Float = 0
            confidence = Float(results.first!.confidence)
            print("confidence is \(confidence)")
            
            if let firstResult = results.first {
                if firstResult.identifier.contains("Steven Li"){
                    self.nameLabel.text = "Steven Li \(confidence)"
                }
                else if firstResult.identifier.contains("Sophia Li"){
                    self.nameLabel.text = "Sophia Li \(confidence)"
                }
                else if firstResult.identifier.contains("Steve Jobs"){
                    self.nameLabel.text = "Steve Jobs \(confidence)"
                }
                else if firstResult.identifier.contains("Bruce Willis"){
                    self.nameLabel.text = "Bruce Willis \(confidence)"
                }
                else {
                    self.nameLabel.text = "Other, Not Identified!"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }

    
    @IBAction func cameraButtonClicked(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func photoButtonClicked(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

