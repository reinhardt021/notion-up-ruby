NOTION UP
---

Learning a little Rust lang
to read from a json file
parse it into the format needed for 
uploading to a Notion database

```
//run from command line
$ ruby main.rb ./Pixels-20210531-22_00_37.649.json
```

Questions to answer:

* how to parse from string to json?
* convert string to Notion format?
* how to make API call?
* how to read from an .env file?

```
// Pixels.json
// mood 
// 1 😢
// 2 🙁
// 3 😐
// 4 🙂
// 5 😄 

// example:
    {
        "date": "2019-01-09",
        "entries": [
            {
                "isHighlighted": false,
                "notes": "All the previous day 3xwrcise had me sleeping late and woke up early to meet with anita. Then spent the evening with M",
                "tags": [
                    {
                        "entries": [
                            "happiness",
                            "love",
                            "tiredness",
                            "nerves",
                            "anger",
                            "stress",
                            "anxiety",
                            "chill"
                        ],
                        "type": "Emotions"
                    }
                ],
                "type": "Mood",
                "value": 5
            }
        ]
    },


// Notion example:
// CREATE a PAGE:
POST https://api.notion.com/v1/pages/
// HEADERS:
Authorization = Bearer {{BEARER_TOKEN}}
Content-Type = application/json
Notion-Version = {{NOTION_VERSION}}
// BODY:
{
    "parent": {
        "database_id": "{{DATABASE_ID}}"
    },
    "properties": {
        "Type": {
            "select": {
                "id": "f96d0d0a-5564-4a20-ab15-5f040d49759e",
                "name": "Article",
                "color": "default"
            }
        },
        "Score /5": {
            "select": {
                "id": "9b1e1349-8e24-40ba-bbca-84a61296bc81",
                "name": "⭐️⭐️⭐️",
                "color": "default"
            }
        },
        "Name": {
            "title": [
                {
                    "text": {
                        "content": "CUSTOM Media Article"
                    }
                }
            ]
        },
        "Status": {
            "select": {
                "id": "8c4a056e-6709-4dd1-ba58-d34d9480855a",
                "name": "Ready to Start",
                "color": "yellow"
            }
        },
        "Publisher": {
            "select": {
                "id": "01f82d08-aa1f-4884-a4e0-3bc32f909ec4",
                "name": "The Atlantic",
                "color": "red"
            }
        },
        "Publishing/Release Date": {
            "date": {
                "start": "2020-12-08T12:00:00Z",
                "end": null
            }
        },
        "Link": {
            "url": "https://www.nytimes.com/2018/10/21/opinion/who-will-teach-silicon-valley-to-be-ethical.html"
        },
        "Summary": {
            "rich_text": [
                {
                    "type": "text",
                    "text": {
                        "content": "Some think chief ethics officers could help technology companies navigate political and social questions.",
                        "link": null
                    },
                    "annotations": {
                        "bold": false,
                        "italic": false,
                        "strikethrough": false,
                        "underline": false,
                        "code": false,
                        "color": "default"
                    },
                    "plain_text": "Some think chief ethics officers could help technology companies navigate political and social questions.",
                    "href": null
                }
            ]
        },
        "Read": {
            "checkbox": false
        }
    }
}
```

