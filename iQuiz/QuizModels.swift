//
//  QuizModels.swift
//  iQuiz
//
//  Created by Christina Wang on 2/22/26.
//
import Foundation

struct QuizQuestion {
    let text: String
    let answers: [String]
    let correctIndex: Int
}

struct Quiz {
    let title: String
    let desc: String
    let iconName: String
    let questions: [QuizQuestion]
}
