//
//  Item+CoreDataProperties.swift
//  ReminderCoreData
//
//  Created by KANISHK VIJAYWARGIYA on 02/12/21.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String
    @NSManaged public var completed: Bool
    @NSManaged public var category: Category

}

extension Item : Identifiable {

}
