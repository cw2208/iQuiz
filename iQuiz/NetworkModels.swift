//
//  NetworkModels.swift
//  iQuiz
//
//  Created by Christina Wang on 2/22/26.
//
import Foundation

struct RemoteQuiz: Codable {
    let title: String
    let desc: String
    let questions: [RemoteQuestion]
}

struct RemoteQuestion: Codable {
    let text: String
    let answer: String    
    let answers: [String]
}
