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
    var objMainVC = ViewController()
    var receivedData: String!
    
    @IBOutlet weak var buttonScreenSelector: UIButton!
    
    @IBAction func unconnectButton(_ sender: UIButton) {
        let disconectFromPeripheral = {(action: UIAlertAction) in
            self.performSegue(withIdentifier: "unwindToMain", sender: self)
        }
        
        let alert = UIAlertController(title: "Atenção", message: "Você tem certerteza que deseja desconectar?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: disconectFromPeripheral))
        self.present(alert, animated: true, completion: nil)
    }
    
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
