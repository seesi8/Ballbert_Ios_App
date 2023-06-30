//
//  tempAssistant.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 6/28/23.
//


func assistantFactory() -> Assistant{
    let assistant = Assistant()

    assistant.ipAddress = "192.168.86.143"
    assistant.name = "Joey Bot"
    assistant.location = "kitchen"
    assistant.selectedIcon = "house.fill"

    return assistant
}

var tempAssitant: Assistant = assistantFactory()
