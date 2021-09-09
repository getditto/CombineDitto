//
//  GalleryPage.swift
//  CombineDitto_Example
//
//  Created by Maximilian Alexander on 9/9/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import UIKit
import Combine

class GalleryPageViewModel: ObservableObject {

    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var isShowingPicker = false
    @Published var pictures = [Picture]()

    var cancellables = Set<AnyCancellable>()

    init() {
        AppDelegate
            .ditto
            .store["pictures"]
            .findAll()
            .publisher()
            .map({ snapshot in snapshot.documents.map({ Picture(document: $0) }) })
            .assign(to: \.pictures, on: self)
            .store(in: &cancellables)
    }

    func selectedCamera() {
        sourceType = .camera
        isShowingPicker = true
    }

    func selectedPhotoLibrary() {
        sourceType = .photoLibrary
        isShowingPicker = true
    }

    func selectedImage(_ image: UIImage) {
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else { return }
        let fileName = "\(UUID().uuidString).jpg"
        guard let filePath = directory.appendingPathComponent(fileName) else {
            fatalError()
        }
        try? image.jpeg(.low)?.write(to: filePath)
        let attachment = AppDelegate.ditto.store["pictures"].newAttachment(path: filePath.path)
        try! AppDelegate.ditto.store["pictures"].insert([
            "image": attachment,
            "name": fileName,
            "mimeType": "image/jpeg",
        ])
    }

    func delete(_id: String) {
        
    }
}

struct GalleryPage: View {

    @ObservedObject var viewModel = GalleryPageViewModel()

    var body: some View {
        List {
            ForEach(viewModel.pictures) { galleryImage in
                GalleryImage(attachmentToken: galleryImage.image!)
            }
        }
        .navigationTitle("Gallery")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Section {
                        Button(action: {
                            viewModel.selectedCamera()
                        }) {
                            Label("Camera", systemImage: "camera")
                        }

                        Button(action: {
                            viewModel.selectedPhotoLibrary()
                        }) {
                            Label("Photo Library", systemImage: "folder")
                        }
                    }
                }
                label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowingPicker, content: {
            ImagePicker(sourceType: viewModel.sourceType) { selectedImage in
                viewModel.selectedImage(selectedImage)
            }
        })
    }
}

struct GalleryPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GalleryPage()
        }
    }
}
