//
//  EyePleasureProjectApp.swift
//  EyePleasureProject
//
//  Created by Lukas Soares do Nascimento on 06/05/25.
//

import SwiftUI

@main
struct EyePleasureProjectApp: App {
    @AppStorage("login") var login: String = ""
    
    var body: some Scene {
        WindowGroup {
            if login.isEmpty{
                LoginView()
            } else {
                MenuView()
            }
            
        }
    }
}
