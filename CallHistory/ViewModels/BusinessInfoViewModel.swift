//
//  BottomSheetViewModel.swift
//  CallHistory
//
//  Created by Viacheslav Yakymenko on 07.05.2022.
//

import Foundation
import UIKit

protocol BottomSheetViewModelProtocol: NSObject {
    var phone: String { get }
    var label: String { get }
}

class BusinessInfoViewModel: NSObject, BottomSheetViewModelProtocol {
    private var businessNumber: BusinessNumber
    
    var phone: String {
        var phone = businessNumber.number
        phone.insert(" ", at: phone.index(phone.startIndex, offsetBy: 2))
        phone.insert(" ", at: phone.index(phone.startIndex, offsetBy: 6))
        phone.insert("-", at: phone.index(phone.startIndex, offsetBy: 10))
        return phone
    }
    
    var label: String {
        return businessNumber.label ?? ""
    }
    
    init(businessNumber: BusinessNumber) {
        self.businessNumber = businessNumber
        print(businessNumber.number)
    }
}
