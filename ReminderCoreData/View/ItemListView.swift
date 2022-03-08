//
//  ItemListView.swift
//  ReminderCoreData
//
//  Created by KANISHK VIJAYWARGIYA on 04/12/21.
//

import SwiftUI
import AwesomeToast

struct ItemListView: View {
    @EnvironmentObject private var viewModel: ReminderViewModel
    @State private var showAddItem = false
    @State private var showAlert = false
    @State private var isHide: Bool = false
    private var _category: Category
    
    var results: [Item] {
        if isHide {
            return viewModel.items.filter({$0.completed != true})
        } else {
            return viewModel.items
        }
    }
    
    var disableToggle: Bool {
        if (results.count == 0 || viewModel.items.filter({$0.completed == true }).count == 0) {
            return true
        } else {
            return false
        }
    }
    
    init(category: Category) {
        self._category = category
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            List {
                Toggle("Hide Completed", isOn: $isHide)
                    .disabled(disableToggle)
                
                ForEach(results, id: \.id) { item in
                    ItemCell(itemCellVM: ItemCellViewModel(viewModel: viewModel, item: item))
                }
                .onDelete(perform: self.removeRow)
                
                if showAddItem {
                    ItemCell(itemCellVM: ItemCellViewModel(viewModel: viewModel, item: viewModel.newItem()))
                }
            }
            .listStyle(InsetGroupedListStyle())
            
            HStack {
                Button(action: {showAddItem.toggle()}) {
                    if showAddItem {
                        Button(action: {showAddItem.toggle()}) {
                            Text("Done")
                        }
                        .padding()
                    } else {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25, alignment: .center)
                            
                            Text("New Item")
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationBarTitle(_category.name)
        .onAppear {
            viewModel.category = _category
        }
        .showToast(title: "Delete Failed", "Remove Filter", isPresented: $showAlert, color: Color(#colorLiteral(red: 0.9374369979, green: 0.2989863157, blue: 0.3855088353, alpha: 1)), alignment: .bottom, image: Image(systemName: "flame.fill"))
    }
    
    private func removeRow(at offsets: IndexSet) {
        if !isHide {
            for offset in offsets {
                let item = viewModel.items[offset]
                viewModel.deleteItem(item)
            }
        } else {
            self.showAlert.toggle()
        }
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView(category: Category())
    }
}
