//
//  DataController.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 6/28/23.
//
import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Assistants")
    
    func updateAssistant() {
            
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
        }
        
    }
    
    func deleteAssistant(assistant: Assistant) {
        
        container.viewContext.delete(assistant)
        
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            print("Failed to save context \(error)")
        }
        
    }
    
    func getAllAssistants() -> [Assistant] {
        
        let fetchRequest: NSFetchRequest<Assistant> = Assistant.fetchRequest()
        
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
        
    }
    
    func saveAssistant(ipAddress: String, name: String, location : String, selectedIcon: String) {
        
        let assistant = Assistant(context: container.viewContext)
        assistant.id = UUID()
        assistant.ipAddress = ipAddress
        assistant.name = name
        assistant.location = location
        assistant.selectedIcon = selectedIcon
        
        
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save Assistant \(error)")
        }
        
    }
    
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
