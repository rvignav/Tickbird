import Foundation
import UIKit
import AVFoundation
import TesseractOCR
import FirebaseDatabase

class ScanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate {
    
    
    
    @IBOutlet weak var prescriptionName: UITextField!
    
    
    @IBOutlet weak var imagePicked: UIImageView!
    
    let synthesizer = AVSpeechSynthesizer()
    let utterance = AVSpeechUtterance(string: "This is where you will scan prescriptions. Click the bottom button to open the camera and take the picture. While taking the picture, let accessibility guide you to where the prescription is. Then click use image in the bottom right hand corner. Then give your prescription a title, which is above the image. Finally, click the save prescription to confirm and save your prescription. ")
    
    private func configT() {
        prescriptionName.delegate = self
    }
    
    @IBAction func openCameraButton(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        /*
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
        {
            
        }
 */
    }
    @IBAction func openCameraRoll(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    var text = ""
    
     @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        dismiss(animated: true, completion: nil)
        
        if let selectedImage = selectedImageFromPicker {
            imagePicked.image = selectedImage
            //let synthesizer = AVSpeechSynthesizer()
            
           
            if let tesseract = G8Tesseract(language: "eng") {
                
                tesseract.delegate = self
                
                tesseract.image = convertToGrayScale(image: selectedImage)
                tesseract.recognize()
                text = tesseract.recognizedText
            }
            
            // DO FILTERING BEFORE SPEAKING
            
           // let myUtterance = AVSpeechUtterance(string: text)
           // synthesizer.speak(myUtterance)
        }
        
    }
    
    func convertToGrayScale(image: UIImage) -> UIImage {

        // Create image rectangle with current image width/height
        let imageRect:CGRect = CGRect(x:0, y:0, width:image.size.width, height: image.size.height)

        // Grayscale color space
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height

        // Create bitmap content with current image size and grayscale colorspace
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

        // Draw image into current context, with specified rectangle
        // using previously defined context (with grayscale colorspace)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.draw(image.cgImage!, in: imageRect)
        let imageRef = context!.makeImage()

        // Create a new UIImage object
        let newImage = UIImage(cgImage: imageRef!)

        return newImage
    }
    
    
    
    @IBAction func savePrescription(_ sender: Any) {
        view.endEditing(true)
        let lab = prescriptionName.text
        let rref = Database.database().reference()
        rref.child("Prescriptions/\(lab!)").setValue(text)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        synthesizer.speak(utterance)
        configT()
        configureTapGesture()
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}

extension ScanViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
