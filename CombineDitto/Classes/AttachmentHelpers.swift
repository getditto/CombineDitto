//
//  AttachmentHelpers.swift
//  CombineDitto
//
//  Created by Maximilian Alexander on 9/9/21.
//

import DittoSwift
import Combine

public extension DittoStore {

    struct Publisher: Combine.Publisher {

        public struct Progress {
            var percentage: Float
            var downloadedBytes: UInt64
            var totalBytes: UInt64
        }

        public typealias Output = DittoAttachmentFetchEvent
        public typealias Failure = Never

        private let store: DittoStore
        private let collection: String
        private let attachmentToken: DittoAttachmentToken

        init(store: DittoStore, collection: String, attachmentToken: DittoAttachmentToken) {
            self.store = store
            self.collection = collection
            self.attachmentToken = attachmentToken
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Publisher.Failure == S.Failure, Publisher.Output == S.Input {
            let subscription = Subscription(subscriber: subscriber, store: store, collection: collection, attachmentToken: attachmentToken)
            subscriber.receive(subscription: subscription)
        }

        public func progress() -> AnyPublisher<Progress, Never> {
            return self.compactMap({ (event: DittoAttachmentFetchEvent) -> Progress? in
                switch event {
                    case .progress(let downloadedBytes, let totalBytes):
                        let percentage = Float(downloadedBytes) / Float(totalBytes)
                        return Progress(percentage: percentage, downloadedBytes: downloadedBytes, totalBytes: totalBytes)
                default:
                    return nil
                }
            })
            .eraseToAnyPublisher()
        }

        public func completed() -> AnyPublisher<DittoSwift.DittoAttachment, Never> {
            return self.compactMap({ (event: DittoAttachmentFetchEvent) -> DittoAttachment? in
                switch event {
                    case .completed(let attachment):
                        return attachment
                default:
                    return nil
                }
            })
            .eraseToAnyPublisher()
        }

    }

    fileprivate final class Subscription<SubscriberType: Subscriber>: Combine.Subscription where SubscriberType.Input == DittoAttachmentFetchEvent, SubscriberType.Failure == Never {
        private let collection: String
        private let store: DittoStore
        private var fetcher: DittoAttachmentFetcher?

        init(subscriber: SubscriberType, store: DittoStore, collection: String, attachmentToken: DittoAttachmentToken) {
            self.store = store
            self.collection = collection
            fetcher = store[collection].fetchAttachment(token: attachmentToken, onFetchEvent: { event in
                _ = subscriber.receive(event)
            })
        }

        func request(_ demand: Subscribers.Demand) {
            // We do nothing here as we only want to send events when they occur.
            // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
        }

        func cancel() {
            fetcher?.stop()
            fetcher = nil
        }

        deinit {
            cancel()
        }
    }

    func fetchAttachment(collection: String, attachmentToken: DittoAttachmentToken) -> Publisher {
        return Publisher(store: self, collection: collection, attachmentToken: attachmentToken)
    }

}
