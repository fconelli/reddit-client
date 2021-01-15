//
//  HelpersExtensions.swift
//  reddit-client
//
//  Created by Francisco Conelli on 15/01/2021.
//

import Foundation

extension Date {
    
    func timeAgoDisplay() -> String {
        
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute {
            return "\(secondsAgo) seconds ago"
        }
            
        else if secondsAgo < hour {
            return secondsAgo / minute > 1 ? "\(secondsAgo / minute) minutes ago" : "\(secondsAgo / minute) minute ago"
        }
            
        else if secondsAgo < day {
            return secondsAgo / hour > 1 ? "\(secondsAgo / hour) hours ago" : "\(secondsAgo / hour) hour ago"
        }
        
        else if secondsAgo < week {
            return secondsAgo / day > 1 ? "\(secondsAgo / day) days ago" : "\(secondsAgo / day) day ago"
        }
        
        return secondsAgo / week > 1 ? "\(secondsAgo / week) weeks ago" : "\(secondsAgo / week) week ago"
    }
    
    func secondsAgo() -> Int {
        
        let secondsAgo = Int(Date().timeIntervalSince(self).rounded())
        return secondsAgo
    }
    
    func monthsAgo() -> Int {
        
        let monthsAgo = Int(Date().timeIntervalSince(self).rounded()) / (((60*60)*24)*30)
        return monthsAgo
    }

    func millisecondsAgo() -> Int {
        let milisAgo = Int(Date().timeIntervalSince(self)*1000.rounded())
        return milisAgo
    }
}
