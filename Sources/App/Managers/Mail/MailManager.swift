//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 29.12.2022.
//

import Foundation
import SwiftSMTP
import Vapor

class MailManager {
    
    let smtp = SMTP(
        hostname: "smtp.gmail.com",
        email: Enviroment.senderEmail,
        password: Enviroment.senderPassword
    )
    let admin = Mail.User(name: "Admin", email: Enviroment.adminEmail)
    
    func sendConfirmedMail(user: User, onError: @escaping (Error) -> Void) {
        
        let userMail = Mail.User(name: user.name, email: user.email)
        
        let htmlAttachment = Attachment(
            htmlContent: """
                            <p>Hello!</p>
                            <p>\(user.name)(\(user.email)) want to be a driver</p>
                            <form action="\(Enviroment.selfLink)/driver/confirm" method="POST">
                                <input type="hidden" name="email" value="\(user.email)">
                                <button>Confirm</button>
                            </form>
                        """
        )

        let mail = Mail(
            from: userMail,
            to: [admin],
            subject: "Driver request",
            text: "",
            attachments: [htmlAttachment]
        )

        smtp.send(mail) { error in
            if let error = error {
                onError(error)
            }
        }
        
    }
    
}
