//
//  Ditto+Combine.swift
//  CombineDitto
//
//  Created by Maximilian Alexander on 9/28/21.
//

import DittoSwift
import Combine

extension Ditto {
    
    struct RemotePeersPublisher: Combine.Publisher {

        public typealias Output = [DittoRemotePeer]
        public typealias Failure = Never

        private let ditto: Ditto

        init(_ ditto: Ditto) {
            self.ditto = ditto
        }

        public func receive<S>(subscriber: S) where S : Subscriber, RemotePeersPublisher.Failure == S.Failure, RemotePeersPublisher.Output == S.Input {
            let subscription = Subscription(subscriber: subscriber, ditto: ditto)
            subscriber.receive(subscription: subscription)
        }

    }

    fileprivate final class Subscription<SubscriberType: Subscriber>: Combine.Subscription where SubscriberType.Input == [DittoRemotePeer], SubscriberType.Failure == Never {
        private var peersObserver: DittoPeersObserver?

        init(subscriber: SubscriberType, ditto: Ditto) {
            peersObserver = ditto.observePeers(callback: { peers in
                _ = subscriber.receive(peers)
            })
        }

        func request(_ demand: Subscribers.Demand) {
            // We do nothing here as we only want to send events when they occur.
            // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
        }

        func cancel() {
            peersObserver?.stop()
            peersObserver = nil
        }

        deinit {
            cancel()
        }
    }


    /// A Combine publisher that shows all the remote connected peers.
    /// - Returns: A `RemotePeersPublisher` which has an output of `[DittoRemotePeer]`
    func remotePeersPublisher() -> RemotePeersPublisher {
        return RemotePeersPublisher(self)
    }
}
