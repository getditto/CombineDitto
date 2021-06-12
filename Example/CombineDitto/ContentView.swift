//
//  ContentView.swift
//  CombineDitto_Example
//
//  Created by Maximilian Alexander on 6/11/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import Combine
import CombineDitto

import Fakery

class DataSource: ObservableObject {

    @Published var todos = [ToDo]()
    var cancellables = Set<AnyCancellable>()

    private let todoPublisher = AppDelegate.ditto.store["todos"].findAll().publisher()
    private let faker = Faker()

    func start() {
        todoPublisher
            .map({ snapshot in
                return snapshot
                    .documents
                    .map({ ToDo(document: $0) })
                    .reversed()
            })
            .assign(to: &$todos)
    }

    func addRandom() {
        try! AppDelegate.ditto.store["todos"].insert([
            "body": faker.lorem.sentence(),
            "isCompleted": faker.number.randomBool()
        ])
    }

    func add(text: String) {
        try! AppDelegate.ditto.store["todos"].insert([
            "body": text,
            "isCompleted": faker.number.randomBool()
        ])
    }

    func clear() {
        AppDelegate.ditto.store["todos"].findAll().remove()
    }


    func delete(_ indexSet: IndexSet) {
        let todoIds = indexSet.map({ todos[$0].id })
        todoIds.forEach { id in
            AppDelegate.ditto.store["todos"].findByID(id).remove()
        }
    }

    func toggle(id: String, isCompleted: Bool) {
        AppDelegate.ditto.store["todos"].findByID(id).update { mutableDoc in
            mutableDoc?["isCompleted"].set(isCompleted)
        }
    }

}

struct ContentView: View {

    @ObservedObject var dataSource: DataSource
    @State private var newText: String = ""

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Create new to do")) {
                    HStack {
                        TextField("New To Do", text: $newText)
                        Button(action: {}) {
                            Text("Add")
                                .fontWeight(.bold)
                                .padding()
                        }.onTapGesture {
                            dataSource.add(text: newText)
                        }
                    }
                }
                Section(header: Text("Current to do items"))  {
                    ForEach(dataSource.todos, id: \.id) { todo in
                        HStack(spacing: 10) {
                            Button(action: {
                                dataSource.toggle(id: todo.id, isCompleted: !todo.isCompleted)
                            }){
                                Image(todo.isCompleted ? "box_checked": "box_empty").scaledToFit()
                            }
                            Text(todo.body)
                        }

                    }.onDelete(perform: dataSource.delete)
                    .animation(.default)
                }
            }
            .navigationTitle("CombineDitto")
            .toolbar(content: {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Clear") {
                        dataSource.clear()
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Add Random") {
                        dataSource.addRandom()
                    }
                }
            })
        }.onAppear(perform: {
            dataSource.start()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dataSource: DataSource())
    }
}
