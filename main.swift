//
//  main.swift
//  ProcessMyDocument
//
//  Created by Nick on 23/01/2018.
//  Copyright © 2018 NICOLASDELEE. All rights reserved.
//

import Foundation

// use command $file --mime `filepath` to get the encoding of the file
let estr = "iso-8859-1"
let cfe = CFStringConvertIANACharSetNameToEncoding(estr as CFString)
let se = CFStringConvertEncodingToNSStringEncoding(cfe)
let encoding = String.Encoding(rawValue: se)

let filePath = "/Users/nick/Desktop/ToTheLighthouse.txt"
print(FileManager.default.isReadableFile(atPath: filePath))
let fileData = FileManager.default.contents(atPath: filePath)
print(fileData ?? "`fileData` is nil")
var fileString = String.init(data: fileData!, encoding: .utf8)

let tagger = NSLinguisticTagger.init(tagSchemes: [.lemma], options: 0)
tagger.string = fileString
let range = NSRange.init(location: 0, length: (fileString?.utf16.count)!)
let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]

var lemmaArray = [String]()
tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options) { (tag, tokenRange, stop) in
    if let lemma = tag?.rawValue {
        lemmaArray.append(lemma.lowercased())
    }
}
print("unfiltered lemma array -> \(lemmaArray.count)")
lemmaArray = Array(Set(lemmaArray))
print("filtered lemma array -> \(lemmaArray.count)")
lemmaArray.sort()

var seperatedString = ""
for s in lemmaArray {
    seperatedString.append(String(s))
    seperatedString.append("\n")
}
print("file done")

let seperatedData = seperatedString.data(using: .utf8)
let seperatedPath = "/Users/nick/Desktop/ToTheLighthouseWords.txt"
let res = FileManager.default.createFile(atPath: seperatedPath, contents: seperatedData, attributes: nil)
print("new file created -> \(res)")



