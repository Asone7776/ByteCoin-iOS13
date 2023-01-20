//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CanUpdateRates {
    func updateRateSuccess(rate: Rate)
    func updateRateFailure(error: String);
}


struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC";
    let apiKey = "851C44BC-7762-45C0-A70D-64CA5E418FA7";
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CanUpdateRates?;
    
    func fetchExchangeRates (currency: String){
        let url = URL(string: "\(baseURL)/\(currency)");
        if let safeUrl = url{
            performRequest(url: safeUrl);
        }
    }
    
    private func performRequest(url:URL){
        var request = URLRequest(url: url);
        request.httpMethod = "GET";
        request.allHTTPHeaderFields = [
            "X-CoinAPI-Key": apiKey
        ];
        let session = URLSession(configuration: .default);
        session.dataTask(with: request, completionHandler: handler(data:response:error:)).resume();
    }
    private func handler (data:Data?,response:URLResponse?,error:Error?){
        if error != nil{
            print(error!);
            return;
        }
        if let safeData = data{
            if let safeRate = parseJSON(data: safeData){
                delegate?.updateRateSuccess(rate: safeRate);
            }
        }
    }
    private func parseJSON (data:Data) -> Rate?{
        let decoder = JSONDecoder();
        do {
            let parsed = try decoder.decode(Rate.self, from: data);
            return Rate(rate: parsed.rate, asset_id_quote: parsed.asset_id_quote);
        } catch  {
            delegate?.updateRateFailure(error: error.localizedDescription);
            return nil;
        }
    }
}
