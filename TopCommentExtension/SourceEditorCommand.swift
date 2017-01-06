
import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    public func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        switch invocation.commandIdentifier {
        
        case "com.alejandromp.XcodeTopComment.TopCommentExtension.RemoveTopComment":
            removeTopComment(from: invocation.buffer.lines)
        case "com.alejandromp.XcodeTopComment.TopCommentExtension.AddLastModifiedBy":
            addLastModifiedBy(in: invocation.buffer.lines)
        case "com.alejandromp.XcodeTopComment.TopCommentExtension.UpdateDateModified":
            updateDate(in: invocation.buffer.lines, with: .lastModifiedBy)
        case "com.alejandromp.XcodeTopComment.TopCommentExtension.ChangeDate":
            updateDate(in: invocation.buffer.lines, with: .createdBy)
        default:
            fatalError("\(invocation.commandIdentifier) not supported.")
        }
        
        completionHandler(nil)
    }
    
}

