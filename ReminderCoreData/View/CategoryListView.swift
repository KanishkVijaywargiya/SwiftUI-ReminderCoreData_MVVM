//
//  CategoryListView.swift
//  ReminderCoreData
//
//  Created by KANISHK VIJAYWARGIYA on 02/12/21.
//

import SwiftUI
import AwesomeToast

struct CategoryListView: View {
    @EnvironmentObject private var viewModel: ReminderViewModel
    @State private var showingAlert: Bool = false
    @State private var showNoDelete = false
    @State private var textEntered = ""
    @State private var catName = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 10) {
                    List {
                        ForEach(viewModel.categories, id: \.id) { category in
                            NavigationLink(destination: ItemListView(category: category)) {
                                Text("\(category.name) - \(viewModel.itemCount(category))")
                            }
                        }
                        .onDelete (perform: self.removeRow)
                    }
                    .listStyle(InsetGroupedListStyle())
                    
                    HStack {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                showingAlert.toggle()
                            }
                        }) {
                            if !showingAlert {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 35, height: 35, alignment: .center)
                                    
                                    Text("New Category")
                                }
                                .padding()
                            }
                        }
                    }
                }
                
                if showingAlert {
                    AlertView(textEntered: $textEntered, showingAlert: $showingAlert)
                        .onDisappear {
                            if !textEntered.isEmpty {
                                viewModel.newCategoryName = textEntered
                            }
                        }
                }
            }
            .navigationBarTitle("Category")
        }
        .showToast(title: "Delete Failed", "There are items currently attached to this \(catName)", isPresented: $showNoDelete, color: Color(#colorLiteral(red: 0.9374369979, green: 0.2989863157, blue: 0.3855088353, alpha: 1)), alignment: .bottom, image: Image(systemName: "flame.fill"))
        
    }
    
    private func removeRow(at offsets: IndexSet) {
        for offset in offsets {
            let category = viewModel.categories[offset]
            self.catName = category.name
            
            if viewModel.canDelete(category) {
                viewModel.delete(category)
            } else {
                self.showNoDelete.toggle()
            }
        }
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
