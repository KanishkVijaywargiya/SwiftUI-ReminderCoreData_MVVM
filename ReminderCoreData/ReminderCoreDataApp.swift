//
//  ReminderCoreDataApp.swift
//  ReminderCoreData
//
//  Created by KANISHK VIJAYWARGIYA on 29/11/21.
//

import SwiftUI

@main
struct ReminderCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CategoryListView()
                .environmentObject(ReminderViewModel(context: persistenceController.container.viewContext))
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
