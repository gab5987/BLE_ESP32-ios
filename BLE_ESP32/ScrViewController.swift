//
//  ScrViewController.swift
//  BLE_ESP32
//
//  Created by Gabriel on 28/11/22.
//

import UIKit

var dataGlobal: String?

@available(iOS 15.0, *)
class ScrViewController: UIViewController {
    
    // Gets the bluetooth interface from the past controller
    var simpleBluetoothIO = ViewController.simpleBluetoothIO
    
    // This method creates a gradient color for the background
    func setGradientBackground() {
        let colorTop =  UIColor(red: 227.0/255.0, green: 70.0/255.0, blue: 57.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 225.0/255.0, green: 196.0/255.0, blue: 48.0/255.0, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
    }
    
    var receivedData: String!
    
    @IBOutlet weak var buttonScreenSelector: UIButton!
    
    @IBOutlet weak var labelTeste: UILabel!
    @IBOutlet weak var inputTeste: UITextField!
    @IBOutlet weak var switchTeste: UISwitch!
    
//    @IBAction func sendTeste(_ sender: Any) {
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        
        buttonScreenSelector.showsMenuAsPrimaryAction = true
        buttonScreenSelector.changesSelectionAsPrimaryAction = true
        
        let menuClosure = {(action: UIAction) in
            //self.update(number: action.title)
        }
        
        buttonScreenSelector.menu = UIMenu(children: [
            UIAction(title: "Motor", state: .on, handler: menuClosure),
            UIAction(title: "Câmbio", handler: menuClosure),
        ])
    }
    
    @objc func updateData() {
        receivedData = dataGlobal ?? "<ERROR>"
        // labelTeste.text = receivedData
    }

    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
