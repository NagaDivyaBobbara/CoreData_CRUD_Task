// EmployeeDataManager.swift
import UIKit
import CoreData

class EmployeeDataManager {
    static let shared = EmployeeDataManager() // Singleton instance for shared access
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // Fetch all employee records
    func fetchEmployeeDetails() -> [EmployeeDetails]? {
        do {
            let fetchRequest = EmployeeDetails.fetchRequest()
            let empData = try context.fetch(fetchRequest)
            return empData
        } catch {
            print("Failed to fetch EmployeeDetails: \(error)")
            return nil
        }
    }

    // Create a new employee record
    func createEmployeeDetails(name: String?, email: String?, dob: Date?, mobile: String?, gender: String?, company: String?, designation: String?, experience: String?) {
        let newEmp = EmployeeDetails(context: context)
        newEmp.name = name
        newEmp.email = email
        newEmp.dob = dob
        newEmp.mobile = mobile
        newEmp.gender = gender
        newEmp.company = company
        newEmp.designation = designation
        newEmp.experience = experience
        saveContext()
    }

    // Update an existing employee record
    func updateEmployeeDetails(details: EmployeeDetails, updatedName: String?, updatedEmail: String?, updatedDOB: Date?, updatedMobile: String?, updatedGender: String?, updatedCompany: String?, updatedDesignation: String?, updatedExperience: String?) {
        details.name = updatedName
        details.email = updatedEmail
        details.dob = updatedDOB
        details.mobile = updatedMobile
        details.gender = updatedGender
        details.company = updatedCompany
        details.designation = updatedDesignation
        details.experience = updatedExperience
        saveContext()
    }

    // Delete an existing employee record
    func deleteEmployeeDetails(details: EmployeeDetails) {
        context.delete(details)
        saveContext()
    }
    
    func saveEmployeeDetails(_ employeeDetails: [EmployeeDetails]) {
        for employee in employeeDetails {
            let newEmployee = EmployeeDetails(context: context)
            newEmployee.name = employee.name
            newEmployee.email = employee.email
            newEmployee.dob = employee.dob
            newEmployee.mobile = employee.mobile
            newEmployee.gender = employee.gender
            newEmployee.company = employee.company
            newEmployee.designation = employee.designation
            newEmployee.experience = employee.experience
        }
        saveContext()
    }

    // Save changes to Core Data
    private func saveContext() {
        do {
            try context.save()
            print("Context saved successfully.")
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
