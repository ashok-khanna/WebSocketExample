//
//  Sockets.swift
//  WebSocketExample
//
//  Created by Ashok Khanna on 3/12/21.
//

import Foundation

class WebSocket: NSObject, URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web Socket did connect")
        ping()
        send()
        receive()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web Socket did disconnect")
    }
}

let webSocketDelegate = WebSocket()
let session = URLSession(configuration: .default, delegate: webSocketDelegate, delegateQueue: OperationQueue())
let url = URL(string: "ws://localhost:12345/bongo")!
let webSocketTask = session.webSocketTask(with: url)


func ping() {
  webSocketTask.sendPing { error in
    if let error = error {
      print("Error when sending PING \(error)")
    } else {
        print("Web Socket connection is alive")
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            ping()
        }
    }
  }
}

func close() {
  let reason = "Closing connection".data(using: .utf8)
  webSocketTask.cancel(with: .goingAway, reason: reason)
}

func send() {
    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
        send()
        webSocketTask.send(.string("New Message")) { error in
          if let error = error {
            print("Error when sending a message \(error)")
          }
        }
    }
}


func receive() {
  webSocketTask.receive { result in
    switch result {
    case .success(let message):
      switch message {
      case .data(let data):
        print("Data received \(data)")
      case .string(let text):
        print("Text received \(text)")
      }
    case .failure(let error):
      print("Error when receiving \(error)")
    }
    
    receive()
  }
}
