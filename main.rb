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

# a mapping for emotions to Notion IDs and names
EMOTION_MAPPINGS = {
    "anger": {
        "color": "default",
        "id": "34599b68-278f-4469-818a-fe3ea15ac628",
        "name": "anger"
    },
    "anxiety": {
        "color": "default",
        "id": "a624b198-87e1-4245-8914-62ec271969a2",
        "name": "anxiety"
    },
    "chill": {
        "color": "default",
        "id": "dd43926e-6df4-4322-b15d-85ca1dd2f99f",
        "name": "chill"
    },
    "emptiness": {
        "color": "default",
        "id": "0148a002-b106-49fd-aa47-73658c1abeb5",
        "name": "emptiness"
    },
    "excitement": {
        "color": "default",
        "id": "f27870f2-dcfe-4304-8cce-72ed4be9aef9",
        "name": "excitement"
    },
    "fear": {
        "color": "default",
        "id": "4a98b2a0-bc12-4cc6-99cb-62ceb87b94d1",
        "name": "fear"
    },
    "happiness": {
        "color": "default",
        "id": "2f62b684-ac7c-4c47-9784-c45f838a851a",
        "name": "happiness"
    },
    "joy": {
        "color": "default",
        "id": "740541ce-826d-4b4d-aba0-7c2883ba4937",
        "name": "joy"
    },
    "love": {
        "color": "default",
        "id": "c7a739a3-6516-4bd9-968d-9c1b623ded60",
        "name": "love"
    },
    "nerves": {
        "color": "default",
        "id": "1b9bdfb8-15bf-469f-a07f-cc0ef7ac12fd",
        "name": "nerves"
    },
    "optimism": {
        "color": "default",
        "id": "0b0cd695-d6e6-43f4-807c-2bdeaa1fe36d",
        "name": "optimism"
    },
    "remorse": {
        "color": "default",
        "id": "324b6109-785c-480c-bd6a-c708f75b39b4",
        "name": "remorse"
    },
    "sadness": {
        "color": "default",
        "id": "b8fe7131-07f9-475c-bcbe-d08ccd579a26",
        "name": "sadness"
    },
    "stress": {
        "color": "default",
        "id": "3dade857-11cd-4c08-a490-4d5924084b9f",
        "name": "stress"
    },
    "tiredness": {
        "color": "default",
        "id": "5bde5007-e2ea-40e0-879f-7eddfdaddad3",
        "name": "tiredness"
    }
}

class Notion
    @@emotions = [];
    @@test_page = {};
    
    def load_json(file_path)
        if !file_path 
          puts "no file path given"
          return nil
        end

        puts "We can find the file here: ", file_path
        file = File.open(file_path)

        if !file
          puts "Not able to access file"
          return nil
        end

        raw_data = file.read()

        return my_json = JSON.parse(raw_data)
    end

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

    def build_page(database_id, curr_date, entry)
        #puts "entry:", entry
        entry_date = DateTime.iso8601(curr_date)
        curr_mood = MOOD_MAPPINGS[entry["value"].to_s.to_sym]
        #puts "MOOD basic:", curr_mood[:name]
        #puts "MOOD string:", curr_mood[:name].to_s 
        #puts "MOOD json:", curr_mood[:name].to_json 
        #puts "MOOD utf 8:", curr_mood[:name].encode('utf-8') 
        #puts "MOOD utf 8:", curr_mood[:name].encode('UTF-8') 
        #puts "MOOD force:", curr_mood[:name].force_encoding('utf-8') 
        #puts "MOOD force:", curr_mood[:name].force_encoding('iso-8859-1') 
        #page_name = "#{curr_mood[:name]} #{curr_date}";
        page_name = curr_date;
        emotions = get_emotions(entry["tags"])
        page_properties = {
            "Date": {
                "date": {
                    "start": entry_date.strftime("%FT%T.%LZ"),
                    "end": nil
                }
            },
            "Name": {
                "title": [
                    "text": {
                        "content": page_name
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
                "multi_select": emotions 
            },
            "Mood": {
                "select": curr_mood        
            }
        };
        new_notion_page = {
            "parent": {
                "database_id": database_id,
                #"page_id": nil
            },
            #"icon": {
                #"type": "emoji",
                #"emoji": curr_mood[:name].encode('utf-8'),
                #"external": nil
            #},
            "properties": page_properties
        }
        # TESTING 
        #@@test_page = notion_page
        #puts "notion page: ", notion_page
        #puts "notion page: ", notion_page.to_json
        #if emotions.count > 4
            #puts "found a page with emotions to test: ", new_notion_page
            #@@test_page = new_notion_page
            # EXCELLENT the emotions multi-select works
        #end
    end

    def get_database(headers, database_id, verbose = false)
        url_get_database = "https://api.notion.com/v1/databases/#{database_id}"
        get_database_response = RestClient.get(url_get_database, headers)
        if verbose
            puts "GET DATABASE"
            puts "----"
            puts get_database_response.body
        end
    end

    def query_database(headers, database_id, filter, verbose = false)
        url_query_database = "https://api.notion.com/v1/databases/#{database_id}/query"
        query_database_payload = { "filter": filter }
        query_response = RestClient.post(
            url_query_database, 
            query_database_payload, 
            headers
        )
        if verbose
            puts "QUERY DATABASE"
            puts "----"
            puts query_response.body
        end
    end

    def post_page(headers, new_page, verbose = false)
        url_create_page = "https://api.notion.com/v1/pages/"
        create_page_payload = new_page;
        if verbose
            puts "CREATE PAGE"
            puts "----"
        end
        begin
            create_response = RestClient.post(
                url_create_page, 
                create_page_payload.to_json, 
                headers
            )
            if verbose
                puts create_response.code
                puts create_response.body
            end
        rescue RestClient::ExceptionWithResponse => e
            puts "BAD REQUEST: ", e.response
        end
    end

    def main
        Dotenv.load
        
        # get user provided file path for json
        file_path = ARGV[0]
        my_json = load_json(file_path)
        if !my_json
            return
        end

        # API SETUP
        notion_version = ENV["NOTION_VERSION"]
        secret = ENV["BEARER_TOKEN"]
        database_id = ENV["DATABASE_ID"]
        headers = {
          "Authorization": "Bearer #{secret}",
          "Content-Type": "application/json",
          "Notion-Version": notion_version
        }

        for pixel in my_json do
          curr_date = pixel["date"]
          for entry in pixel["entries"] do 
            notion_page = build_page(database_id, curr_date, entry)
            #post_page(headers, notion_page)
          end 
        end

        # TESTING
        #puts "unique emotions: ", @@emotions.sort
        #get_database(headers, database_id, true)
        #filter = {
            #"property": "Name",
            #"select": {
                #"equals": "TEST 0"
            #}
        #}
        #query_database(headers, database_id, filter, true)
        #post_page(headers, @@test_page, true)
    end
end

notion_up = Notion.new
notion_up.main()

