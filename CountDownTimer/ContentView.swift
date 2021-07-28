//
//  ContentView.swift
//  CountDownTimer
//
//  Created by Terrance Griffith on 7/22/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        CustomControllerRepresentable()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomControllerRepresentable: UIViewControllerRepresentable{
    
    func makeUIViewController(context: Context) ->  UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyBoard.instantiateInitialViewController() as! EventViewController
        
        controller.presenter = EventPresenter.init(eventView: controller, events: [Event]())
                
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        return
    }
}
