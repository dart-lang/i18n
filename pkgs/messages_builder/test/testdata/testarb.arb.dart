String arbFile = '''
{
    "@@locale": "en",
    "@@x-reference": true,
    "helloAndWelcome": "Welcome {firstName} von {lastName} <",
    "@helloAndWelcome": {
        "description": "Initial welcome message",
        "placeholders": {
            "firstName": {},
            "lastName": {}
        }
    },
    "newMessages": "test {newMessages, plural, =0 {No new messages} =1 {One new message} two{Two new Messages} other {test {newMessages} new messages}}",
    "@newMessages": {
        "type": "text",
        "description": "Number of new messages in inbox.",
        "placeholders": {
            "newMessages": {
                "type": "int"
            }
        }
    },
    "newMessages2": "test {gender, select,male {No new messages} female {One new message} other {test {gender} new messages of type {newVar}}}",
    "@newMessages2": {
        "type": "text",
        "placeholders": {
            "gender": {
                "type": "String"
            },
            "newVar": {
                "type": "int"
            }
        }
    }
}
''';
