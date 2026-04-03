//
//  Vehicle+CoreDataProperties.swift
//  OBD Insight V2.0
//
//  Created by Никита on 30.03.2026.
//
//

import Foundation
import CoreData


extension Vehicle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vehicle> {
        return NSFetchRequest<Vehicle>(entityName: "Vehicle")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var brand: String?
    @NSManaged public var model: String?
    @NSManaged public var engine: String?
    @NSManaged public var year: Int16
    @NSManaged public var createdAt: Date?

}

extension Vehicle : Identifiable {

}
