# DoorDash TPS: Building an Item Detail UI

### Background
 
 This small coding challenge will test your ability to code a simple, API driven UI from a design spec. More specifically, your task is to:

1. Consume the data from the `ContentService` api by deserializing into a native type(s), and
2. Use your type(s) to populate a UI as spec'ed in `ItemDetailTPSSpec.png`


### Where to start
Currently, there exists a `ContentService`, which exposes a function for retrieving some data from a mock API. The class `ViewController` currently makes use of this function to print the data in the console. 


### Some files you should know about

`ItemDetailTPSSpec.png` - A design-provided UI spec for the exercise. This will show you what you need to build
`ContentService.swift` - provides a single function for retrieving data from a mock API.
`Content.json` - Provides the mocked API response served by the ContentService. 


### Some quick pointers:

1. You have limited time (about 30 minutes) so move quickly!
2. Your code does not need to be perfect, but you should still try to build in a clean & maintable fashion. If you want to make a tradeoff for speed, mention it & explain why you're doing so.
3. If you are unclear about requirements, clarify! Your interviewer is there to help.


### API Schema Details

header_image_url: String (non-nil)
content_items.title: String (nullable)
content_items.image_url: String (nullable)
content_items.content: String (non-nill)
