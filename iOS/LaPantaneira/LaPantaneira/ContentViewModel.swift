//
//  ContentViewModel.swift
//  LaPantaneira
//
//  Created by Allan Melo on 11/03/22.
//

import Foundation
import Network
import SwiftUI
import Combine
import CoreMotion

class ContentViewModel: ObservableObject {
    var connection: NWConnection?
    var hostUDP: NWEndpoint.Host = "192.168.1.1"
    var portUDP: NWEndpoint.Port = 9999
    
    private var motionManager: CMMotionManager
    
    @Published var x: Int = 0
    @Published var inputText: String = ""
    @Published var leftEsc: Float = 49
    @Published var rightEsc: Float = 49
    @Published var throttle: Float = 0
    @Published var enableAccelerometer: Bool = false
    @Published var testMode: Bool = false
    
    let accelerometerData = PassthroughSubject<CMAccelerometerData, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    var leftEscValue: Int {
        var value = leftEsc + throttle
        if enableAccelerometer {
            value += Float(x)
        }
        return Int(value)
    }
    
    var rightEscValue: Int {
        var value = rightEsc + throttle
        if enableAccelerometer {
            value -= Float(x)
        }
        
        return Int(value)
    }
    
    init() {
        self.motionManager = CMMotionManager()
        self.motionManager.accelerometerUpdateInterval = 1/200

        self.motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
            guard let data = data else { return }
            self.accelerometerData.send(data)
        }
        
        accelerometerData
            .throttle(for: .milliseconds(200), scheduler: DispatchQueue.main, latest: true)
            .map { $0.acceleration.y }
            .map { $0 * 100 }
            .map { Int($0) }
            .map { $0 / 3 }
            .removeDuplicates()
            .sink { value in
                self.x = value
                self.sendValues()
            }
            .store(in: &subscriptions)
        
        connectToUDP()
    }
   
    func resetValues() {
        self.leftEsc = 49
        self.rightEsc = 49
        sendValues()
    }
    
    func sendValues() {
        sendUDP("leftEsc;\(leftEscValue)")
        sendUDP("rightEsc;\(rightEscValue)")
    }
    
    func connectToUDP() {
        connectToUDP(hostUDP,portUDP)
    }
    
    func connectToUDP(_ hostUDP: NWEndpoint.Host, _ portUDP: NWEndpoint.Port) {
        // Transmited message:
        let messageToUDP = "Test message"

        self.connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)
        self.connection?.stateUpdateHandler = { (newState) in
            print("This is stateUpdateHandler:")
            switch (newState) {
                case .ready:
                    print("State: Ready\n")
                    self.sendUDP(messageToUDP)
                    self.receiveUDP()
                case .setup:
                    print("State: Setup\n")
                case .cancelled:
                    print("State: Cancelled\n")
                case .preparing:
                    print("State: Preparing\n")
                default:
                    print("ERROR! State not defined!\n")
            }
        }

        self.connection?.start(queue: .global())
    }

    func sendUDP(_ content: Data) {
        self.connection?.send(content: content, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if (NWError == nil) {
                print("Data was sent to UDP")
            } else {
                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
                print("try to connect again!")
                self.connectToUDP()
            }
        })))
    }

    func sendUDP(_ content: String) {
        guard let contentToSendUDP = content.data(using: String.Encoding.utf8) else {
            print("contentToSendUDP is invalid")
            return
        }
        
        sendUDP(contentToSendUDP)
    }

    func receiveUDP() {
        self.connection?.receiveMessage { (data, context, isComplete, error) in
            if (isComplete) {
                print("Receive is complete")
                if (data != nil) {
                    let backToString = String(decoding: data!, as: UTF8.self)
                    print("Received message: \(backToString)")
                } else {
                    print("Data == nil")
                }
            }
        }
    }
}
