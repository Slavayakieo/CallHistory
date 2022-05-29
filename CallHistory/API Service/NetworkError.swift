//
//  NetworkError.swift
//  CallHistory
//
//  Created by Viacheslav Yakymenko on 04.05.2022.
//

import UIKit

enum NetworkError: Error {
    case response(Int)
    case data(String)
    case unknown
}

