//
//  NetworkRequest.swift
//  SimpleNetworking
//
//  Created by Jack Rosen on 8/17/20.
//

import Foundation

public protocol NetworkRequest {
	associatedtype ResponseDataType: Codable
	
	var urlRequest: URLRequest { get }
}
