//
//  ItemCellViewModel.swift
//  ReminderCoreData
//
//  Created by KANISHK VIJAYWARGIYA on 04/12/21.
//

import SwiftUI

class ItemCellViewModel: ObservableObject {
    @Published var item: Item
    private var _viewModel: ReminderViewModel
    
    init(viewModel: ReminderViewModel, item: Item) {
        self._viewModel = viewModel
        self.item = item
    }
    
    func saveItem() {
        _viewModel.saveItem()
    }
    
    func deleteItem() {
        _viewModel.deleteItem(item)
    }
}
