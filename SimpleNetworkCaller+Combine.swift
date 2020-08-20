//
//  SimpleNetworkCaller+Combine.swift
//  SimpleNetworking
//
//  Created by Jack Rosen on 8/17/20.
//

import Foundation
import Combine

@available(iOS 13, *)
public extension SimpleNetworkCaller {
	func makeNetworkRequest<Request: NetworkRequest>(request: Request, waitsForNetwork: Bool) -> AnyPublisher<UrlResponseValue<Request.ResponseDataType>, Never> {
		let publisher = PassthroughSubject<UrlResponseValue<Request.ResponseDataType>, Never>()
		self.makeNetworkRequest(request: request, waitsForNetwork: waitsForNetwork, completion: { response in
			publisher.send(response)
		})
		return publisher.eraseToAnyPublisher()
	}
	
	func makeNetworkRequest<Request: NetworkRequest>(request: Request) -> Future<UrlResponseValue<Request.ResponseDataType>, Never> {
		return Future { resolver in
			self.makeNetworkRequest(request: request, waitsForNetwork: false) { response in
				resolver(.success(response))
			}
		}
	}
}
