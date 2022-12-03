//
//  ScrViewController.swift
//  BLE_ESP32
//
//  Created by Gabriel on 28/11/22.
//

import UIKit

@available(iOS 15.0, *)
class ScrViewController: UIViewController {
    
    var bluetoothDevice: SimpleBluetoothIO!
    weak var testTime: Timer!
    var receivedData: String!
    @IBOutlet weak var buttonScreenSelector: UIButton!
    @IBOutlet weak var testeLabel: UILabel!
    @IBAction func dismissTapped(_ sender: Any) { dismiss(animated: true) }
    
    
    // This method creates a gradient color for the background
    func setGradientBackground() {
        let colorTop =  UIColor(red: 1, green: 1, blue: 1, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0).cgColor
                    
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
    override var preferredStatusBarStyle: UIStatusBarStyle { return .darkContent }
    
    
    
    @IBAction func unconnectButton(_ sender: UIButton) {
        let disconectFromPeripheral = {(action: UIAlertAction) in
            self.performSegue(withIdentifier: "unwindToMain", sender: self)
        }
        
        let alert = UIAlertController(title: "Atenção", message: "Você tem certerteza que deseja desconectar?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: disconectFromPeripheral))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func testConnection() {
        if bluetoothDevice.isConnected! == false {
            let disconectFromPeripheral = {(action: UIAlertAction) in
                self.performSegue(withIdentifier: "unwindToMain", sender: self)
            }
            testTime.invalidate()
            
            let alert = UIAlertController(title: "Erro", message: """
                                                                  A conexão foi perdida
                                                                  Error 0x42 Connection Lost
                                                                  """, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: disconectFromPeripheral))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creates a bluetooth instance
        bluetoothDevice = SimpleBluetoothIO(
            serviceUUID: "4fafc201-1fb5-459e-8fcc-c5c9c331914b",
            delegate: self,
            serviceName: serviceName!
        )
        
        // Timers for update the data printed on screen and the test connection
        let _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        testTime = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(testConnection), userInfo: nil, repeats: true)
        
        
        let menuClosure = {(action: UIAction) in
            //self.update(number: action.title)
        }
        
        buttonScreenSelector.showsMenuAsPrimaryAction = true
        buttonScreenSelector.changesSelectionAsPrimaryAction = true
        buttonScreenSelector.menu = UIMenu(children: [
            UIAction(title: "Motor", state: .on, handler: menuClosure),
            UIAction(title: "Câmbio", handler: menuClosure),
        ])
    }
        
    @objc func updateData() {
        receivedData = dataGlobal ?? "<ERROR>"
        testeLabel.text = "Início: " + receivedData
    }
    
    @IBAction func avanteButton(_ sender: Any) {
        
    }
}

@available(iOS 15.0, *)
extension ScrViewController: SimpleBluetoothIODelegate {
    func simpleBluetoothIO(simpleBluetoothIO: SimpleBluetoothIO, didReceiveValue value: String) {
        dataGlobal = value
        print(value)
    }
}
