//
//  ContentView.swift
//  PushUp
//
//  Created by Andi Fachrul Destama on 27/05/22.
//

import SwiftUI
import UIKit

class Counter: ObservableObject {
    @Published var count = 0
    
    @objc func proximityChanged(notification: NSNotification) {
        
        if UIDevice.current.proximityState {
            count += 1
        }
    }
    
    func reset() {
        count = 0
    }
}


struct ContentView: View {
    
    @ObservedObject var counter = Counter()

    func activateProximitySensor() {
        UIDevice.current.isProximityMonitoringEnabled = true
        
        if UIDevice.current.isProximityMonitoringEnabled {
            NotificationCenter.default.addObserver(counter, selector: #selector(counter.proximityChanged), name: UIDevice.proximityStateDidChangeNotification, object: UIDevice.current)
        }
    }
    
    func deactivateProximitySensor() {
        UIDevice.current.isProximityMonitoringEnabled = false
        NotificationCenter.default.removeObserver(counter, name: UIDevice.proximityStateDidChangeNotification, object: UIDevice.current)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Let's Push Up")
                    .font(.title)
                    .fontWeight(.medium)
                
                ZStack {
                    Text("\(counter.count)")
                        .font(.system(size: 80))
                }
                .frame(width: 300, height: 300)
                .background(Color(UIColor.systemGray5) , in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                
                Button("Reset") {
                    counter.reset()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color(UIColor.systemBlue))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
        }
        .onAppear {
            activateProximitySensor()
        }
        .onDisappear {
            deactivateProximitySensor()
        }
        
        
    }

}



struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
        
    }
}

