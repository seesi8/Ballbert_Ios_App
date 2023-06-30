//
//  Hal_Ios_AppApp.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 6/27/23.
//

import SwiftUI

@main
struct Hal_Ios_AppApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView(coreDM: DataController())
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
