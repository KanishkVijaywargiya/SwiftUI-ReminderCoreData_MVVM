//
//  ReminderViewModel.swift
//  ReminderCoreData
//
//  Created by KANISHK VIJAYWARGIYA on 29/11/21.
//

import SwiftUI
import CoreData

class ReminderViewModel: ObservableObject {
    @Published var categories = [Category]()
    @Published var items = [Item]()
    private var _context: NSManagedObjectContext
    
    var newCategoryName: String = "" {
        didSet {
            if !newCategoryName.isEmpty {
                saveCategory(name: newCategoryName)
            }
        }
    }
    
    var category: Category? {
        didSet {
            loadItems()
        }
    }
    
    init(context: NSManagedObjectContext) {
        self._context = context
        loadCategories()
    }
    
    private func save() {
        do {
            if _context.hasChanges {
                try _context.save()
            }
        } catch {
            print(error.localizedDescription)
            _context.rollback()
        }
        
        loadCategories()
    }
}

// MARK: CATEGORY RELATED FUNCTIONS
extension ReminderViewModel {
    private func loadCategories() {
        // fetch categories
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try _context.fetch(request)
        } catch {
            print("Error in loading categories: \(error.localizedDescription)")
            assertionFailure()
        }
    }
    
    private func saveCategory(name: String) {
        let newCategory = Category(context: _context)
        newCategory.id = UUID()
        newCategory.name = name
        
        save()
    }
    
    func delete(_ category: Category) {
        _context.delete(category)
        save()
    }
    
    func canDelete(_ category: Category) -> Bool{
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@", #keyPath(Item.category), category)
        
        do {
            return try _context.fetch(request).count == 0
        } catch {
            assertionFailure()
        }
        return false
    }
    
    func itemCount(_ category: Category) -> Int {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@", #keyPath(Item.category), category)
        
        do {
            return try _context.fetch(request).count
        } catch {
            assertionFailure()
        }
        return 0
    }
}

// MARK: ITEMS
extension ReminderViewModel {
    private func loadItems() {
        guard let category = category
        else {
            assertionFailure("Category cannot be nil")
            return
        }
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@", #keyPath(Item.category), category)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.name, ascending: true)]
        
        do {
            items = try _context.fetch(request)
        } catch {
            print("Error loading items for \(category.name): \(error.localizedDescription)")
            assertionFailure()
        }
    }
    
    func saveItem() {
        _context.performAndWait {
            save()
        }
        loadItems()
    }
    
    func deleteItem(_ item: Item) {
        _context.performAndWait {
            _context.delete(item)
            save()
        }
        loadItems()
    }
    
    func newItem() -> Item {
        guard let category = category
        else {
            assertionFailure("Category cannot be nil")
            return Item()
        }
        let item = Item(context: _context)
        item.id = UUID()
        item.completed = false
        item.category = category
        
        return item
    }
}
