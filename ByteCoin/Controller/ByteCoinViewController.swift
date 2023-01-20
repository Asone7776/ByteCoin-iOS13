//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ByteCoinViewController: UIViewController {
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    var brain = CoinManager();
    override func viewDidLoad() {
        super.viewDidLoad();
        brain.delegate = self;
        currencyPicker.delegate = self;
        brain.fetchExchangeRates(currency: brain.currencyArray[0]);
    }
    
}

extension ByteCoinViewController:UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brain.currencyArray.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        brain.fetchExchangeRates(currency: brain.currencyArray[row]);
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return brain.currencyArray[row];
    }
}
//MARK: Update UI
extension ByteCoinViewController: CanUpdateRates{
    func updateRateSuccess(rate: Rate) {
        DispatchQueue.main.async {
            self.currencyLabel.text = rate.asset_id_quote;
            self.coinLabel.text = rate.rateAsString;
        }
    }
    
    func updateRateFailure(error: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert);
            let action = UIAlertAction(title: "Cancel", style: .cancel);
            alert.addAction(action);
            self.present(alert,animated: true);
        }
    }
}
