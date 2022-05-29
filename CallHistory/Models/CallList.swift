//
//  Requests.swift
//  CallHistory
//
//  Created by Viacheslav Yakymenko on 04.05.2022.
//

import Foundation

class CallList: NSObject, Decodable {
    var requests: [Request]
}

struct Request: Decodable {
    let id: String
    let state: String
    let client: Client
    let type: String
    let created: String
    let businessNumber: BusinessNumber
    let origin: String?
    let favourite: Bool?
    let duration: String
}

struct Client: Decodable {
    let address: String?
    var Name: String?
}

struct BusinessNumber: Decodable {
    let number: String
    let label: String?
}
