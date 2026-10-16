*** Settings ***
Library           Browser

Suite Setup       New Browser    chromium    headless=False
Suite Teardown    Close Browser
Test Setup        New Page    ${URL}


*** Variables ***
${URL}    https://todomvc.com/examples/react/dist/


*** Test Cases ***
Todo Hinzufügen
    Fill Text    css=.new-todo    Robot Framework lernen
    Keyboard Key    press    Enter
    Get Text    css=.todo-list li label    ==    Robot Framework lernen

Todo Erledigen
    Fill Text    css=.new-todo    Demo vorbereiten
    Keyboard Key    press    Enter
    Click    css=.todo-list li .toggle
    Get Classes    css=.todo-list li    contains    completed

Todo Löschen
    Fill Text    css=.new-todo    Weg damit
    Keyboard Key    press    Enter
    Hover    css=.todo-list li
    Click    css=.todo-list li .destroy
    Get Element Count    css=.todo-list li    ==    0
