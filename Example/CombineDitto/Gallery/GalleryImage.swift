//
//  GalleryImage.swift
//  CombineDitto_Example
//
//  Created by Maximilian Alexander on 9/9/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import DittoSwift
import Combine
import CombineDitto

struct GalleryImage: View {

    class ViewModel: ObservableObject {
        @Published var data: Data?
        @Published var errorMessage: String?
        @Published var progress: Float = 0

        var cancellables = Set<AnyCancellable>()

        init(attachmentToken: DittoAttachmentToken) {
            AppDelegate.ditto.store["pictures"]
                .fetchAttachmentPublisher(attachmentToken: attachmentToken)
                .sink { [weak self] e in
                    switch e {
                    case .progress(let downloadedBytes, let totalBytes):
                        self?.progress = Float(downloadedBytes) / Float(totalBytes)
                        break
                    case .completed(let attachment):
                        do {
                            self?.data = try attachment.getData()
                            self?.progress = 1.0
                        } catch (let error) {
                            self?.errorMessage = error.localizedDescription
                        }
                        break
                    case .deleted:
                        self?.data = nil
                        break
                    @unknown default:
                        self?.data = nil
                        self?.errorMessage = "There was an unknown error "
                        break
                    }
                }.store(in: &cancellables)
        }
    }

    @ObservedObject var viewModel: ViewModel

    init(attachmentToken: DittoAttachmentToken) {
        viewModel = ViewModel(attachmentToken: attachmentToken)
    }

    var body: some View {
        HStack {
            if let errorMessage = viewModel.errorMessage {
                ZStack {
                    Image("placeholder_image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(0.5)
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            else if let data = viewModel.data, viewModel.progress == 1.0 {
                Image(uiImage: UIImage(data: data) ?? UIImage(named: "placeholder_image")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if viewModel.progress < 1.0 {
                ZStack {
                    Image("placeholder_image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(0.5)
                    ProgressView(value: viewModel.progress)
                        .padding()
                }

            } else {
                Image("placeholder_image")
                    .resizable()
                    .opacity(0.5)
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}
