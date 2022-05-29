//
//  Call+CoreDataClass.swift
//  CallHistory
//
//  Created by Viacheslav Yakymenko on 10.05.2022.
//
//

import Foundation
import CoreData


public class Call: NSManagedObject {
    convenience init(context: NSManagedObjectContext, request: Request, order: Int) {
        self.init(context: context)
        self.number = request.businessNumber.number
        self.label = request.businessNumber.label
        self.id = request.id
        self.state = request.state
        self.type = request.type
        self.created = request.created
        self.favourite = request.favourite ?? false
        self.duration = request.duration
        self.address = request.client.address
        self.name = request.client.Name
        self.origin = request.origin
        self.order = Int16(order)
    }
    
    func getCallInfo() -> Request {
        let client = Client(address: self.address, Name: self.name)
        let businessNumber = BusinessNumber(number: self.number, label: self.label)
        let request = Request(id: self.id, state: self.state, client: client, type: self.type, created: self.created, businessNumber: businessNumber, origin: self.origin, favourite: self.favourite, duration: self.duration)
        return request
    }
}
