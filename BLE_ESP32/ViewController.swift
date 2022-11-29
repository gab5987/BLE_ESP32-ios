//
//  ViewController.swift
//  BLE_ESP32
//
//  Created by Gabriel on 27/11/22.
//

import UIKit

class ViewController: UIViewController {
    var simpleBluetoothIO: SimpleBluetoothIO! // Creates a BLE interface
    
    // This method creates a gradient color for the background
    func setGradientBackground() {
        let colorTop =  UIColor(red: 21.0/255.0, green: 147.0/255.0, blue: 195.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 38.0/255.0, green: 28.0/255.0, blue: 71.0/255.0, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    // This method is called right before everything is loaded on screen, it calls the gradient method
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
    }
    
    @IBOutlet weak var testeInputField: UITextField!
    @IBOutlet weak var serviceInputField: UITextField!                   // Holds the device name (Input from User)
    @IBOutlet weak var creatingAdapterActivity: UIActivityIndicatorView! // Used to create a loading animation
    @IBAction func connectToAdapter(_ sender: Any) {                     // Function that connects to the device specified in serviceInputField
        simpleBluetoothIO = SimpleBluetoothIO(
            serviceUUID: "4fafc201-1fb5-459e-8fcc-c5c9c331914b",
            delegate: self,
            serviceName: serviceInputField.text!
        )
        createConnection = true
        showAnim()
    }
    
    var createConnection: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This listen to any tap on the screen to hide the keyboard
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        )
        // Creates a timer to fire up the segue for the initial pop up view, function declared down on "timeToMoveOn"
        let _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
    }
    
    // Simply performs a segue for the presentation view
    @objc func timeToMoveOn() {
        self.performSegue(withIdentifier: "initialPresentationSegue", sender: self)
    }
    
    @IBAction func buttonTeste(_ sender: Any) {
        simpleBluetoothIO.writeValue(value: testeInputField.text!)
    }
    
    func showAnim() {
        if(createConnection == true) {
            creatingAdapterActivity.startAnimating()
        }
        else {
            creatingAdapterActivity.stopAnimating()
        }
    }
}

extension ViewController: SimpleBluetoothIODelegate {
    func simpleBluetoothIO(simpleBluetoothIO: SimpleBluetoothIO, didReceiveValue value: String) {
        print(value)
    }
}
