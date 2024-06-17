//
//  CustomizeNB + CustomizeTB.swift
//  ZMusic
//
//  Created by Анна on 17.06.2024.
//

import Foundation
import SwiftUI

struct BlurredTabBar: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundEffect = blurEffect
        
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .darkRed
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.darkRed]
        
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .myGray
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.myGray]
        
        tabBarAppearance.backgroundColor = UIColor.clear
        
        let tabBar = UITabBar.appearance()
        tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        
        view.addSubview(blurEffectView)
        blurEffectView.frame = view.bounds
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct BlurredNavigationBar: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        let blurEffect = UIBlurEffect(style: .dark) // Используем темный стиль размытия
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Настраиваем внешний вид NavigationBar
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundEffect = blurEffect
        navBarAppearance.backgroundColor = UIColor.black
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        let navigationBar = UINavigationBar.appearance()
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationBar.compactAppearance = navBarAppearance
        
        view.addSubview(blurEffectView)
        blurEffectView.frame = view.bounds
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

extension View {
    func customizeNavigationBar() -> some View {
        self.background(BlurredNavigationBar())
    }
    
    func customizeTabBar() -> some View {
        self.background(BlurredTabBar())
    }
}
