//
//  ItemCell.swift
//  ReminderCoreData
//
//  Created by KANISHK VIJAYWARGIYA on 04/12/21.
//

import SwiftUI

struct ItemCell: View {
    @ObservedObject var itemCellVM: ItemCellViewModel
    
    var body: some View {
        HStack {
            Image(systemName: itemCellVM.item.completed ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(itemCellVM.item.completed ? .red : Color(.lightGray))
                .onTapGesture {
                    itemCellVM.item.completed.toggle()
                    itemCellVM.saveItem()
                }
            
            TextField(
                "Enter item name",
                text: $itemCellVM.item.name,
                onEditingChanged: { editing in
                    if !editing, itemCellVM.item.name.isEmpty {
                        itemCellVM.deleteItem()
                    }
                },
                onCommit: {
                    update(itemCellVM.item)
                }
            )
        }
        .onDisappear {
            update(itemCellVM.item)
        }
    }
    
    private func update(_ item: Item) {
        if item.name.isEmpty {
            itemCellVM.deleteItem()
        } else {
            itemCellVM.saveItem()
        }
    }
}

struct ItemCell_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ReminderViewModel(context: PersistenceController.preview.container.viewContext)
        
        ItemCell(itemCellVM: ItemCellViewModel(viewModel: viewModel, item: viewModel.newItem()))
    }
}
