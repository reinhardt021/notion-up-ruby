require 'rest-client'
require 'json'
require 'dotenv'
Dotenv.load

notion_version = ENV["NOTION_VERSION"]
puts notion_version
secret = ENV["BEARER_TOKEN"]
puts secret
database_id = ENV["DATABASE_ID"]
puts database_id

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
puts raw_data.class

my_json = JSON.parse(raw_data)
#puts my_json
for pixel in my_json do
  curr_date = pixel["date"]
  puts curr_date
end

# TODO: loop through emotions to see all posibilities that need a map 

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
query_response = RestClient.post(url_query_database, query_database_payload, headers)
puts "----"
puts query_response.body

url_create_page = "https://api.notion.com/v1/pages/"
#create_page_payload = {
    #"parent": {
#TODO:
        #"database_id": "{{DATABASE_ID}}"
    #},
    #"properties": {
        #"Date": {
            #"date": {
#TODO: 
                #"start": "2020-12-08T12:00:00Z",
                #"end": null
            #}
        #},
        #"Name": {
            #"title": [
                #{
                    #"text": {
#TODO:  use the date as the name as well
                        #"content": "CUSTOM Media Article"
                    #}
                #}
            #]
        #},
        #"isHighlighted": {
#TODO:
            #"checkbox": false 
        #},
        #"notes": {
            #"rich_text": [
                #{
                    #"type": "text",
                    #"text": {
#TODO:
                        #"content": "Some think chief ethics officers could help technology companies navigate political and social questions.",
                        #"link": null
                    #},
                    #"annotations": {
                        #"bold": false,
                        #"italic": false,
                        #"strikethrough": false,
                        #"underline": false,
                        #"code": false,
                        #"color": "default"
                    #},
#TODO:
                    #"plain_text": "Some think chief ethics officers could help technology companies navigate political and social questions.",
                    #"href": null
                #}
            #]
        #},
#TODO: ADD EMOTIONS: find multi-select example
# TODO: create mapping for IDs and NAMES
        #"Mood": {
            #"select": {
                #"id": "f96d0d0a-5564-4a20-ab15-5f040d49759e",
                #"name": "Article",
                #"color": "default"
            #}
        #}
# a mapping for numbers (1-5) to IDs and names
mood_mappings = {
  "1": {
    "id": "30e63781-10c4-45bb-bc25-4446468089f2",
    "name": "\ud83d\ude22"
  },
  "2": {
    "id": "67a2a6af-ab60-4f5f-b2f2-458174d7a488",
    "name": "\ud83d\ude41"
  },
  "3": {
    "id": "cf4df1d3-7df8-49de-a296-c217f63677f2",
    "name": "\ud83d\ude10"
  },
  "4": {
    "id": "d6ca8b86-ada7-45bf-ae46-c84dc50a7660",
    "name": "\ud83d\ude42"
  },
  "5": {
    "id": "6c17921e-6838-4d01-911b-c74a844e7163",
    "name": "\ud83d\ude04"
  },
}
    #}
#}
#response = RestClient.post(url_create_page, create_page_payload, headers)



