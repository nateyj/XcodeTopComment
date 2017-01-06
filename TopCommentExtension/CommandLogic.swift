
import Foundation

let DATE_FORMAT = "M/d/yy"

enum TopCommentPrefix: String {
    case createdBy = "// Created by"
    case lastModifiedBy = "// Last modified by"
}

func removeTopComment(from lines: NSMutableArray) {
    guard let _ = getFirstLine(in: lines) else {
        return
    }
    
    var firstEmpty = 0
    for (i, bufferLine) in lines.enumerated() {
        let line = bufferLine as! String
        if line == "\n" {
            firstEmpty = i
            break
        }
    }
    
    lines.removeObjects(in: NSRange(location: 0, length: firstEmpty))
}

func updateDate(in lines: NSMutableArray, with prefix: TopCommentPrefix) {
    guard let _ = getFirstLine(in: lines) else {
        return
    }
    
    let dateLine: String?
    
    switch prefix {
        case .createdBy: dateLine = getCreatedByLine(in: lines)
        case .lastModifiedBy: dateLine = getLastModifiedByLine(in: lines)
    }
    
    guard let oldDateLine = dateLine else {
        return
    }
    
    let pattern = "\\d{1,2}([/])\\d{1,2}([/])\\d{2,4}" // x/x/xx to xx/xx/xxxx
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    
    let newLine = regex.stringByReplacingMatches(in: oldDateLine, options: [], range: oldDateLine.fullRange, withTemplate: today(with: DATE_FORMAT))
    
    lines.replaceObject(at: lines.index(of: oldDateLine), with: newLine)
}

func addLastModifiedBy(in lines: NSMutableArray) {
    guard let _ = getFirstLine(in: lines), let createdByLine = getCreatedByLine(in: lines) else {
        return
    }
    
    if let _ = getLastModifiedByLine(in: lines) {
        updateDate(in: lines, with: TopCommentPrefix.lastModifiedBy)
    } else {
        let lastModifiedByLine = "//  Last modified by \(NSFullUserName()) on \(today(with: DATE_FORMAT))."
        lines.insert(lastModifiedByLine, at: lines.index(of: createdByLine) + 1)
    }
}


// MARK: Helper functions

private func getFirstLine(in lines: NSMutableArray) -> String? {
    guard let firstLine = (lines.firstObject as? String), firstLine.hasPrefix("//") else {
        return nil
    }
    
    return firstLine
}

private func getCreatedByLine(in lines: NSMutableArray) -> String? {
    return lines.first(where: { ($0 as! String).hasPrefix("//  Created by") }) as? String
}

private func getLastModifiedByLine(in lines: NSMutableArray) -> String? {
    return lines.first(where: { ($0 as! String).hasPrefix("//  Last modified by") }) as? String
}

private func today(with dateFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter.string(from: Date())
}


extension String {
    
    var fullRange: NSRange {
        return NSRange(location: 0, length: characters.count)
    }
    
}
