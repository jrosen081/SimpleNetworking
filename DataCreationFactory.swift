//
//  DataCreationFactory.swift
//  SimpleNetworking
//
//  Created by Jack Rosen on 8/20/20.
//

import Foundation

/// An implementation of the `DataTaskCreatorFactory`
public struct DataCreationFactory: DataTaskCreatorFactory {
	public func createNetworkURLRequest(urlSessionConfiguration: URLSessionConfiguration, delegate: URLSessionDataDelegate) -> NetworkURLRequest {
		return URLSession(configuration: urlSessionConfiguration, delegate: delegate, delegateQueue: nil)
	}
	
	
}
