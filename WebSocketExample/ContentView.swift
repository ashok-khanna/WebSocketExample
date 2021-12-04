//
//  ContentView.swift
//  WebSocketExample
//
//  Created by Ashok Khanna on 3/12/21.
//

import Foundation
import SwiftUI

struct ContentView: View {
    
    init() {
        webSocketTask.resume()
    }
    
    var body: some View {
        
        Text("Hello, world!")
            .padding()
    }
  
}

