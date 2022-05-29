//
//  Call+CoreDataProperties.swift
//  CallHistory
//
//  Created by Viacheslav Yakymenko on 10.05.2022.
//
//

import Foundation
import CoreData


extension Call {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Call> {
        return NSFetchRequest<Call>(entityName: "Call")
    }

    @NSManaged public var address: String?
    @NSManaged public var created: String
    @NSManaged public var duration: String
    @NSManaged public var favourite: Bool
    @NSManaged public var id: String
    @NSManaged public var label: String?
    @NSManaged public var name: String?
    @NSManaged public var number: String
    @NSManaged public var origin: String?
    @NSManaged public var state: String
    @NSManaged public var type: String
    @NSManaged public var order: Int16

}

extension Call : Identifiable {

}
