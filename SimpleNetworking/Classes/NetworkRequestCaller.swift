//
//  NetworkRequestCaller.swift
//  SimpleNetworking
//
//  Created by Jack Rosen on 8/17/20.
//

import Foundation

/// An Error relating to the network request
public enum NetworkError: Error {
	case noData
	case parse(underlyingError: Error)
}

internal class URLDelegate: NSObject, URLSessionDataDelegate {
	let waitingForNetworkCall: (() -> ())
	
	init(waitingForNetworkCall: @escaping () -> ()) {
		self.waitingForNetworkCall = waitingForNetworkCall
	}
	
	public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
		self.waitingForNetworkCall()
	}
}

/// An implementation of the `SimpleNetworkCaller` protocol. This will make requests
/// Feel free to make many copies of this, or just use one, there is no extra overhead for either
/// If you choose to make your own factory and return a `URLSession`, it is really important to
/// return a new url session for each request, since this will end all tasks and render the url session invalid
/// after each call
public class NetworkRequestCaller: NSObject, SimpleNetworkCaller, URLSessionDelegate, URLSessionDataDelegate {
	
	let factory: DataTaskCreatorFactory
	
	/// An initializer that supplies a default data factory. Use this if there are no specific settings
	/// That are needed for a custom `URLSession`
	public override init() {
		self.factory = DataCreationFactory()
	}
	
	/// An initializer that takes in a data factory. Use this one to customize the `URLSession` instances
	/// passed to the network request. As well, if you are looking to write unit tests for these calls,
	/// you can pass in a mock data task creator factory using this initializer.
	public init(factory: DataTaskCreatorFactory) {
		self.factory = factory
	}
	
	public func makeNetworkRequest<Request: NetworkRequest>(request: Request, waitsForNetwork: Bool, completion: @escaping (UrlResponseValue<Request.ResponseDataType>) -> ()){
		let urlConfiguration = URLSessionConfiguration.default
		if #available(iOS 11.0, *) {
			urlConfiguration.waitsForConnectivity = waitsForNetwork
		}
		urlConfiguration.timeoutIntervalForResource = 50
		let session = self.factory.createNetworkURLRequest(urlSessionConfiguration: urlConfiguration, delegate: URLDelegate { completion(.waitForNetwork) })
		let dataTask = session.dataTask(request: request.urlRequest) { (data, response, error) in
			guard error == nil else {
				completion(.error(error!))
				session.finishTasksAndInvalidate()
				return
			}
			
			guard let data = data else {
				completion(.error(NetworkError.noData))
				session.finishTasksAndInvalidate()
				return
			}
			
			do {
				completion(.success(try JSONDecoder().decode(Request.ResponseDataType.self, from: data)))
			} catch {
				completion(.error(NetworkError.parse(underlyingError: error)))
			}
			session.finishTasksAndInvalidate()
		}
		dataTask.resume()
	}
}
