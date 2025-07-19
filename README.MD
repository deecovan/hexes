# hexes GitHub repo

## 25.07.19 FSM
- Start Turn Sequence from current_stage:
  - Draw a Hex 
- Compare EnumStateController with ConstStateController
  - Use Enum

## 25.07.19 Draw
- Add Owners
  - PLAYER
  - OPPONENT
- Add States
  - Begin turn state
  - Draw state
  - End turn state
- Add turn_sequence
  - For each Owner each State
- Add current_stage 
  - is Const: index is Turn number, value is Owner+State number
  - in Enum: index is Turn number, value is pair of Owner and State 

## 25.07.18 Drag-and-Drop 
- Update Hex
  - Add Polygon2D
  - Change Lines to Segments
- Add and Remove logic
  - Optimize Drag Implement Drop
- Move DropData to TablePart
  - Leave DragData in Card
- Add principal Drag-and-Drop control
  - can track Drop possition
  - need to get proper Drag data
    - Use KanbanApp source code to do it
- Add TablePart script with basic ..._data() functions
- Update Styles and Table arrangement
- Try video Drag and Drop Godot 4
  [YouTube](https://www.youtube.com/watch?v=8cV-5ByZLOE)


## 25-07-17 Learn
- Its CRASHED
  - move project into [subfolder](./Godot_v4.4.1_project)

- Investigate Inheritance, classes and interfaces in Godot
  - Interfaces: Use Object References and Callables:
    [Docs en](https://docs.godotengine.org/en/stable/tutorials/best_practices/godot_interfaces.html)
    [Docs ru](https://docs.godotengine.org/ru/4.x/tutorials/best_practices/godot_interfaces.html)
  - Classes, Inheritance and super.method() calls
    [Page en](https://www.gotut.net/inheritance-in-godot-4)
  - Stored in 
    [PDFs](./UseThis/PDFs)

- Add submodules
  - UseThis/KanbanAppTutorial
  - UseThis/DragAndDropDemos

- Try Using template, command and interpreter patterns

## 25-07-14
- Continue Video "Drag and drop in Godot part 1, UI Control nodes" 2:00
- @BAD version 3.4 - find it
- Find Drag and drop in Godot part 2
- Find Kanban App in Godot #godot #tutorial videos

## 25-07-14
- Proto Table containers

## 25-07-13
- Initialize project structure 
- Create vector Hex
- Implement Drag-and-Drop
  - [use video](https://www.youtube.com/watch?v=cNvzGKCkNXg)
  - [use repos](https://github.com/exploregamedev/Godot-demos)
 
