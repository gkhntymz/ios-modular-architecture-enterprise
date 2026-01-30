//
//  AuthCoordinating.swift
//  EnterpriseApp
//
//  Created by Gökhan Taymaz on 29.01.2026.
//

protocol AuthCoordinating: AnyObject {
    func handleAuthenticated()
    func handleLogout()
}
