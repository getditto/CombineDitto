import Combine
import DittoSwift

public struct Snapshot {
    public var documents: [DittoDocument]
    public var event: DittoLiveQueryEvent
}

public extension DittoPendingCursorOperation {

    struct Publisher: Combine.Publisher {

        public typealias Output = Snapshot
        public typealias Failure = Never

        private let cursor: DittoPendingCursorOperation

        init(_ cursor: DittoPendingCursorOperation) {
            self.cursor = cursor
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Publisher.Failure == S.Failure, Publisher.Output == S.Input {
            let subscription = Subscription(subscriber: subscriber, cursor: cursor)
            subscriber.receive(subscription: subscription)
        }

    }

    fileprivate final class Subscription<SubscriberType: Subscriber>: Combine.Subscription where SubscriberType.Input == Snapshot, SubscriberType.Failure == Never {
        private var liveQuery: DittoLiveQuery?

        init(subscriber: SubscriberType, cursor: DittoPendingCursorOperation) {
            liveQuery = cursor.observe { (docs, event) in
                _ = subscriber.receive(Snapshot(documents: docs, event: event))
            }
        }

        func request(_ demand: Subscribers.Demand) {
            // We do nothing here as we only want to send events when they occur.
            // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
        }

        func cancel() {
            liveQuery?.stop()
            liveQuery = nil
        }

        deinit {
            cancel()
        }
    }

    func publisher() -> AnyPublisher<Snapshot, Never> {
        return Publisher(self).eraseToAnyPublisher()
    }
}


public struct SingleSnapshot {
    public var document: DittoDocument?
    public var event: DittoSingleDocumentLiveQueryEvent
}

public extension DittoPendingIDSpecificOperation {

    struct Publisher: Combine.Publisher {

        public typealias Output = SingleSnapshot
        public typealias Failure = Never

        private let cursor: DittoPendingIDSpecificOperation

        init(_ cursor: DittoPendingIDSpecificOperation) {
            self.cursor = cursor
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Publisher.Failure == S.Failure, Publisher.Output == S.Input {
            let subscription = Subscription(subscriber: subscriber, cursor: cursor)
            subscriber.receive(subscription: subscription)
        }

    }

    fileprivate final class Subscription<SubscriberType: Subscriber>: Combine.Subscription where SubscriberType.Input == SingleSnapshot, SubscriberType.Failure == Never {
        private var liveQuery: DittoLiveQuery?

        init(subscriber: SubscriberType, cursor: DittoPendingIDSpecificOperation) {
            liveQuery = cursor.observe { (doc, event) in
                _ = subscriber.receive(SingleSnapshot(document: doc, event: event))
            }
        }

        func request(_ demand: Subscribers.Demand) {
            // We do nothing here as we only want to send events when they occur.
            // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
        }

        func cancel() {
            liveQuery?.stop()
            liveQuery = nil
        }

        deinit {
            cancel()
        }
    }

    func publisher() -> AnyPublisher<SingleSnapshot, Never> {
        return Publisher(self).eraseToAnyPublisher()
    }
}
