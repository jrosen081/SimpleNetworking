//
//  ViewController.swift
//  SimpleNetworking
//
//  Created by jrosen081 on 08/17/2020.
//  Copyright (c) 2020 jrosen081. All rights reserved.
//

import UIKit
import SimpleNetworking
import Combine

@available(iOS 13.0, *)
class ViewController: UIViewController {
	@IBOutlet weak var completionHandlerLabel: UILabel!
	@IBOutlet weak var publisherLabel: UILabel!
	@IBOutlet weak var futureLabel: UILabel!
	var anyCancellables: Set<AnyCancellable> = []
	let requestLoader = NetworkRequestCaller()

	@IBAction func performRequestWithCompletionHandler(_ sender: Any) {
		self.completionHandlerLabel.text = "Making Request"
		self.requestLoader.makeNetworkRequest(request: ExampleRequest(), waitsForNetwork: true) { response in
			DispatchQueue.main.async {
				switch response {
				case .waitForNetwork: self.completionHandlerLabel.text = "Waiting for Network"
				case .error(let error): self.completionHandlerLabel.text = "Something went wrong: \(error)"
				case .success(let val): self.completionHandlerLabel.text = "User id: \(val.userId)"
				}
			}
		}
	}
	@IBAction func performRequestWithPublisher(_ sender: Any) {
		self.publisherLabel.text = "Making Request"
		self.requestLoader.makeNetworkRequest(request: ExampleRequest(), waitsForNetwork: true)
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: { response in
				switch response {
				case .waitForNetwork: self.publisherLabel.text = "Waiting for Network"
				case .error(let error): self.publisherLabel.text = "Something went wrong: \(error)"
				case .success(let val): self.publisherLabel.text = "User id: \(val.userId)"
				}
			}).store(in: &self.anyCancellables)
		
	}
	@IBAction func performRequestWithFuture(_ sender: Any) {
		self.futureLabel.text = "Making Request"
		self.requestLoader.makeNetworkRequest(request: ExampleRequest())
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: { response in
				switch response {
				case .waitForNetwork: self.futureLabel.text = "Waiting for Network"
				case .error(let error): self.futureLabel.text = "Something went wrong: \(error)"
				case .success(let val): self.futureLabel.text = "User id: \(val.userId)"
				}
			}).store(in: &self.anyCancellables)

	}
}

