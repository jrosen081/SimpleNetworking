//
//  DataTaskCreatorFactory.swift
//  SimpleNetworking
//
//  Created by Jack Rosen on 8/20/20.
//

import Foundation

/// A data task factory that creates something that can make a datatask.
public protocol DataTaskCreatorFactory {
	/// Create a network url request with the specific inputs
	func createNetworkURLRequest(urlSessionConfiguration: URLSessionConfiguration, delegate: URLSessionDataDelegate) -> NetworkURLRequest
}
