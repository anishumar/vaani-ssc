//
//  File.swift
//  Vaani
//
//  Created by Anish Umar on 28/02/2026.
//

import Foundation


struct Story {
    let id = UUID()
    let storyImage: String
    let title: String
    let storyScenes: [StoryScene]
    let mcqScene: MCQScene
    let finalScene: StoryScene
}

struct StoryScene {
    let id = UUID()
    let descriptions: [String]
    let backgroundImageName: String
    let characterImageName: String
}

struct MCQScene{
    let id = UUID()
    let question: String
    let options: [String]
    let correctOptionIndex: Int
    let backgroundImageName: String
    let characterImageName: String
}
