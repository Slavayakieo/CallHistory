//
//  CallCallViewModel.swift
//  CallHistory
//
//  Created by Viacheslav Yakymenko on 06.05.2022.
//

import Foundation
import UIKit

protocol InfoCellViewModelProtocol {
    var statusImage: UIImage? { get }
    var duration: String { get }
    var name: String? { get }
    var phone: String { get }
    var time: String { get }
}

class InfoCellViewModel: NSObject, InfoCellViewModelProtocol {
    
    private var call: Request
    
    var statusImage: UIImage? {
        return UIImage(named: "missed")
    }
    
    var duration: String {
        return formatDuration(input: call.duration)
    }
    
    var name: String? {
        if let name = call.client.Name {
            return name
        }
        return nil
    }
    
    var phone: String {
        var phone = call.businessNumber.number
        phone.insert(" ", at: phone.index(phone.startIndex, offsetBy: 2))
        phone.insert(" ", at: phone.index(phone.startIndex, offsetBy: 6))
        phone.insert("-", at: phone.index(phone.startIndex, offsetBy: 10))
        return phone
    }
    
    var time: String {
        return formatCreationTime(input: call.created)
    }
    
    init(call: Request) {
        self.call = call
    }
    
    private func formatCreationTime(input: String) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        inputDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let date = inputDateFormatter.date(from: input) else {
            return ""
        }
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.timeZone = .current
        outputDateFormatter.dateFormat = "HH:mm a"
        return  outputDateFormatter.string(from: date)
    }
    
    private func formatDuration(input: String) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "HH:mm:ss"
        let calendar = Calendar.current
        
        guard let date = inputDateFormatter.date(from: input) else {
            return ""
        }
        
        let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: date)
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = dateComponents.hour != 0 ? "H:mm:ss" : "mm:ss"
        return  outputDateFormatter.string(from: date)

    }
}
