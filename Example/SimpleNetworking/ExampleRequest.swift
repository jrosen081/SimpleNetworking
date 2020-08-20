//
//  ExampleRequest.swift
//  SimpleNetworking_Example
//
//  Created by Jack Rosen on 8/17/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import SimpleNetworking

struct ExampleRequest: NetworkRequest {
	typealias ResponseDataType = JSONResponse
	
	var urlRequest: URLRequest {
		let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "GET"
		return urlRequest
	}
}
