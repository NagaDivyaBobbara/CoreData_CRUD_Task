//
//  EmployeeDetails+CoreDataProperties.swift
//  CRUD_CoreData_App
//
//  Created by Naga Divya Bobbara on 08/11/24.
//
//

import Foundation
import CoreData


extension EmployeeDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeeDetails> {
        return NSFetchRequest<EmployeeDetails>(entityName: "EmployeeDetails")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var dob: Date?
    @NSManaged public var mobile: String?
    @NSManaged public var gender: String?
    @NSManaged public var company: String?
    @NSManaged public var designation: String?
    @NSManaged public var experience: String?

}

extension EmployeeDetails : Identifiable {

}
