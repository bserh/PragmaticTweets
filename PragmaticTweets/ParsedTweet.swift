//
//  ParsedTweet.swift
//  PragmaticTweets
//
//  Created by Sergey Bavykin on 3/16/16.
//  Copyright © 2016 Sergey Bavykin. All rights reserved.
//

import Foundation

public struct ParsedTweet {
    public var tweetText: String?
    public var userName: String?
    public var createdAt: String?
    public var userAvatarURL: NSURL?
    public var tweetIdString: String?
    
    public init() {
        
    }
}