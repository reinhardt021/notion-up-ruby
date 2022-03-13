require 'rest-client'
require 'json'
require 'dotenv'

# a mapping for numbers (1-5) to Notion IDs and names
MOOD_MAPPINGS = {
  "1": {
    "id": "30e63781-10c4-45bb-bc25-4446468089f2",
    "name": '\ud83d\ude22',
    "color": "default"
  },
  "2": {
    "id": "67a2a6af-ab60-4f5f-b2f2-458174d7a488",
    "name": '\ud83d\ude41',
    "color": "default"
  },
  "3": {
    "id": "cf4df1d3-7df8-49de-a296-c217f63677f2",
    "name": '\ud83d\ude10',
    "color": "default"
  },
  "4": {
    "id": "d6ca8b86-ada7-45bf-ae46-c84dc50a7660",
    "name": '\ud83d\ude42',
    "color": "default"
  },
  "5": {
    "id": "6c17921e-6838-4d01-911b-c74a844e7163",
    "name": '\ud83d\ude04',
    "color": "default"
  },
}

#TODO: ADD EMOTIONS: find multi-select example >> approximation added
# a mapping for emotions to Notion IDs and names
EMOTION_MAPPINGS = {
    "chill": {
        "id": "dd43926e-6df4-4322-b15d-85ca1dd2f99f",
        "name": 'chill',
        "color": "default"
    }
}

class Notion
    @@emotions = [];

    def get_emotions(tags)
        emotions = []
        for tag in tags do
            if tag["type"] != "Emotions"
                continue;
            end 

            for emotion in tag["entries"] do 
                # just for global visibility
                if !@@emotions.include? emotion
                    @@emotions.push(emotion) 
                end

                if EMOTION_MAPPINGS.has_key? emotion.to_sym
                    emotions.push(EMOTION_MAPPINGS[emotion.to_sym])
                end
                # if no then default to returning nothing
            end
        end

        return emotions
    end

    def build_page(curr_date, entry)
        entry_date = DateTime.iso8601(curr_date)
        #puts entry_date.strftime("%FT%T.%LZ")
        new_notion_page = {
            "Date": {
                "date": {
                    "start": entry_date.strftime("%FT%T.%LZ"),
                    "end": nil
                }
            },
            "Name": {
                "title": [
                    "text": {
                        "content": curr_date,
                    }
                ]
            },
            "isHighlighted": {
                "checkbox": entry["isHighlighted"] 
            },
            "notes": {
                "rich_text": [
                    {
                        "type": "text",
                        "text": {
                            "content": entry["notes"],
                            "link": nil
                        },
                        "annotations": {
                            "bold": false,
                            "italic": false,
                            "strikethrough": false,
                            "underline": false,
                            "code": false,
                            "color": "default"
                        },
                        "plain_text": entry["notes"],
                        "href": nil
                    }
                ]
            },
            "Emotions": {
                "multi_select": get_emotions(entry["tags"])
            },
            "Mood": {
                "select": MOOD_MAPPINGS[entry["value"].to_s.to_sym]        
            }
        };
    end

    def main
        Dotenv.load
        notion_version = ENV["NOTION_VERSION"]
        secret = ENV["BEARER_TOKEN"]
        database_id = ENV["DATABASE_ID"]
        #puts notion_version
        #puts secret
        #puts database_id
        
        # get user provided file path for json
        file_path = ARGV[0]

        if !file_path 
          puts "no file path given"
          return
        end

        puts "we can find the file here: ", file_path
        file = File.open(file_path)

        if !file
          puts "Not able to access file"
          return
        end

        raw_data = file.read()
        #puts raw_data
        #puts raw_data.class

        my_json = JSON.parse(raw_data)
        #puts my_json

        for pixel in my_json do
          curr_date = pixel["date"]
          #puts curr_date
          for entry in pixel["entries"] do 
            #puts "entry: ", entry
            notion_page = build_page(curr_date, entry)
            #puts "notion page: ", notion_page
            # TODO: do API call to POST new page to NOTION
          end 
        end

        puts "unique emotions: ", @@emotions.sort

        # API TESTS
        url_get_database = "https://api.notion.com/v1/databases/#{database_id}"
        headers = {
          "Authorization": "Bearer #{secret}",
          "Content-Type": "application/json",
          "Notion-Version": notion_version
        }
        #get_database_response = RestClient.get(url_get_database, headers)
        #puts get_database_response.body

        url_query_database = "https://api.notion.com/v1/databases/#{database_id}/query"
        query_database_payload = {
            "filter": {
                "property": "Name",
                "select": {
                    "equals": "TEST"
                }
            }
        }
        #query_response = RestClient.post(url_query_database, query_database_payload, headers)
        #puts "----"
        #puts query_response.body

        url_create_page = "https://api.notion.com/v1/pages/"
        #create_page_payload = {
            #"parent": {
        #TODO:
                #"database_id": "{{DATABASE_ID}}"
            #},
            #"properties": {
                #"Date": {
                #},
                #"Name": {
                #},
                #"isHighlighted": {
                #},
                #"notes": {
                #},
                #"Emotions": {
                #}
                #"Mood": {
                #}
            #}
        #}
        #response = RestClient.post(url_create_page, create_page_payload, headers)

    end
end

notion_up = Notion.new
notion_up.main()

