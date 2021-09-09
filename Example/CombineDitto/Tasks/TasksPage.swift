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

class TasksPageViewModel: ObservableObject {

    @Published var newTaskBody = ""
    @Published var tasks = [Task]()

    var cancellables = Set<AnyCancellable>()

    private let faker = Faker()

    init() {
        AppDelegate.ditto.store["tasks"]
            .findAll()
            .publisher()
            .map({ snapshot in
                return snapshot
                    .documents
                    .map({ Task(document: $0) })
                    .reversed()
            })
            .assign(to: \.tasks, on: self)
            .store(in: &cancellables)
    }

    func addRandom() {
        try! AppDelegate.ditto.store["tasks"].insert([
            "body": faker.lorem.sentence(),
            "isCompleted": faker.number.randomBool()
        ])
    }

    func add() {
        try! AppDelegate.ditto.store["tasks"].insert([
            "body": newTaskBody,
            "isCompleted": faker.number.randomBool()
        ])
        newTaskBody = ""
    }

    func clear() {
        AppDelegate.ditto.store["tasks"].findAll().remove()
    }


    func delete(_ indexSet: IndexSet) {
        let todoIds = indexSet.map({ tasks[$0].id })
        todoIds.forEach { id in
            AppDelegate.ditto.store["tasks"].findByID(id).remove()
        }
    }

    func toggle(_id: String) {
        AppDelegate.ditto.store["tasks"].findByID(_id).update { mutableDoc in
            guard let mutableDoc = mutableDoc else { return }
            mutableDoc["isCompleted"].set(!mutableDoc["isCompleted"].boolValue)
        }
    }

}

struct TasksPage: View {

    @ObservedObject var viewModel = TasksPageViewModel()

    var body: some View {
        VStack {
            HStack {
                TextField("New Task", text: $viewModel.newTaskBody)
                Button("Add") {
                    viewModel.add()
                }
            }.padding()
            List {
                Section(header: Text("Current tasks"))  {
                    ForEach(viewModel.tasks, id: \.id) { task in
                        HStack(spacing: 10) {
                            Image(systemName: task.isCompleted ? "circle.fill": "circle")
                                .renderingMode(.template)
                                .foregroundColor(.accentColor)
                                .onTapGesture {
                                    viewModel.toggle(_id: task._id)
                                }
                            Text(task.body)
                        }

                    }.onDelete(perform: viewModel.delete)
                    .animation(.default)
                }
            }
        }
        .navigationTitle("Tasks")
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button("Clear") {
                    viewModel.clear()
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Add Random") {
                    viewModel.addRandom()
                }
            }
        })
    }
}

struct TasksPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TasksPage()
        }
    }
}
