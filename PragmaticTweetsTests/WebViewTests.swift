//
//  WebViewTests.swift
//  PragmaticTweets
//
//  Created by Sergey Bavykin on 3/15/16.
//  Copyright © 2016 Sergey Bavykin. All rights reserved.
//

import XCTest
@testable import PragmaticTweets

class WebViewTests: XCTestCase, UIWebViewDelegate {
    var loadedWebViewExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAutomaticWebLoad() {
        guard let viewController = UIApplication.sharedApplication().windows[0].rootViewController
            as? ViewController else {
                XCTFail("couldn't get root view controller")
                return
        }
        
        viewController.twitterWebView.delegate = self
        loadedWebViewExpectation = expectationWithDescription("web view auto-load tesst")
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        XCTFail("web view load failed")
        loadedWebViewExpectation?.fulfill()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if let webViewContents = webView.stringByEvaluatingJavaScriptFromString(
            "document.documentElement.textContent") where webViewContents != "" {
                loadedWebViewExpectation?.fulfill()
        }
    }
}
