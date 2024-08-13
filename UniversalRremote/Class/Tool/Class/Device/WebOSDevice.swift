//
//  WebOSDevice.swift
//  UniversalRremote
//
//  Created by Hao Liu on 2024/8/8.
//

import Foundation
import WebOSClient

class WebOSDevice: Device {
        
    
    enum statusType {
        case didConnect
        case didDisplayPin
        case didRegister
        case error
        
    }
        // The client responsible for communication with the WebOS service.
    var client: WebOSClientProtocol?
    
    var callBackStatus:(_ status:statusType,_ content:String) -> () = {status,content in}
    
    override init(url: String, ip: String) {
        
        super.init(url: url, ip: ip)
        
        self.type = WebOS
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    
    func connectDevice() {
        
        guard let url = URL(string: "wss://" + self.ip + ":3001") else {return}
        
        
        
        client = WebOSClient(url: url, delegate: self, shouldLogActivity: true)
        
        client?.connect()
                
        // Send a registration request to the TV with the stored or nil registration token.
        // The PairingType option should be set to .pin for PIN-based pairing. The default value is .prompt.
        client?.send(.register(pairingType: .pin, clientKey: self.token))
    }
    
    func sendKey(key:String) {
        
        client?.sendKey(.right) 
    }
    
    func checkPin(pin: String) {
        
        client?.send(.setPin(pin))
    }
}

extension WebOSDevice:WebOSClientDelegate {
    
    func didPrompt() {
        
    }
    
    func didConnect() {
        
        self.callBackStatus(.didConnect, "")
    }
    
    func didDisplayPin() {
            // Send the correct PIN displayed on the TV screen to the TV here.
        self.callBackStatus(.didDisplayPin, "")
    }
    
    func didRegister(with clientKey: String) {
        
        self.callBackStatus(.didRegister, clientKey)
    }
    
    func didReceiveNetworkError(_ error: (any Error)?) {
        
        self.callBackStatus(.error, "")
    }
    
    func didReceive(_ result: Result<WebOSResponse, Error>) {
            if case .failure(let error) = result {
                let errorMessage = error.localizedDescription

                if errorMessage.contains("rejected pairing") {
                // Pairing rejected by the user or invalid pin.
                }
                
                if errorMessage.contains("cancelled") {
                // Pairing cancelled due to a timeout.
                }
            }
        }
    
}
