//
//  NetworkURLRequest.swift
//  SimpleNetworking
//
//  Created by Jack Rosen on 8/17/20.
//

import Foundation

/// A protocol for sending values to the network
/// This is used to mock `URLSession` in tests
public protocol NetworkURLRequest {
	func dataTask(request urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Resumable
	func finishTasksAndInvalidate()
}

/// A protocol to mock `URLSessionDataTask`.
public protocol Resumable {
	func resume()
}

extension URLSessionDataTask: Resumable {}

extension URLSession: NetworkURLRequest {
	public func dataTask(request urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Resumable {
		return self.dataTask(with: urlRequest, completionHandler: completionHandler)
	}
	
	
}
