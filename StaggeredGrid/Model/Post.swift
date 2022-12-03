//
//  Post.swift
//  StaggeredGrid
//
//  Created by 程信傑 on 2022/7/9.
//

import Foundation

struct Post: Identifiable, Hashable {
    var id = UUID().uuidString
    var imageURL: String
}
