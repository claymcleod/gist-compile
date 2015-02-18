#!/usr/bin/env ruby
# coding: utf-8

require "uri"
require "json"
require "paint"
require "rubygems"
require "nokogiri"
require "rest-client"

GIST_BASE_URL             = "https://gist.github.com"
GIST_USERCONTENT_BASE_URL = "https://gist.githubusercontent.com"
GIST_XPATH_IDENTIFIER     = "//*[@id=\"js-flash-container\"]/div/div/div/div/div/span/a[3]"

GIST_METADATA_HOOKS = Hash.new
GIST_METADATA_HOOKS["Title"] = "Title:"
GIST_METADATA_HOOKS["Authors"] = "Authors:"
GIST_METADATA_HOOKS["Description"] = "Description:"
GIST_METADATA_HOOKS["Section"] = "Section:"
GIST_METADATA_HOOKS["Subsection"] = "Subsection:"

class GistCompile
  def load_gists(gist_url)
    thread_arr = []
    metadata = []
    elements = []
    gists_data = Hash.new
    
    page = 1
    while page < 1000
      gist_url_current_page = URI::join(gist_url+'/', "?page=#{page}").to_s
      raw_html = Nokogiri::HTML(RestClient.get(gist_url_current_page))
      new_elements = raw_html.css(GIST_XPATH_IDENTIFIER)
      if new_elements.length == 0
        break
      else
        elements.concat(new_elements)
      end
      page = page + 1
    end
    
    puts "Processing #{elements.length} gists..."
    
    elements.each do |element|
      thread_arr.push(
        Thread.new {
          individual_gist_url = URI::join(GIST_BASE_URL, element['href']+'/').to_s
          individual_gist_url_raw = URI::join(GIST_USERCONTENT_BASE_URL, element['href']+'/', 'raw').to_s
          individual_gist_html = Nokogiri::HTML(RestClient.get(individual_gist_url_raw))
          metadata_for_gist = process_raw_gist(individual_gist_html.xpath("//*/body/p")[0].text)
          if metadata_for_gist != nil && !metadata_for_gist.empty?
            puts "    • #{individual_gist_url}: " + Paint["[", :yellow] + Paint["OK", :green] + Paint["]",:yellow]
            GIST_METADATA_HOOKS.each do |key, value|
              if !metadata_for_gist.key? key
                metadata_for_gist[key] = nil
              end
            end
            metadata_for_gist["URL"] = individual_gist_url
            metadata_for_gist["URL_RAW"] = individual_gist_url_raw
            metadata.push(metadata_for_gist)
          else
            puts "    • #{individual_gist_url}: " + Paint["[", :yellow] + Paint["ERR", :red] + Paint["]",:yellow]
          end
        }
      )
    end
    
    thread_arr.each{ |t| t.join() }
    File.open("./prod/gists.json","w") do |f|
      pretty_string = JSON.pretty_generate(metadata)
      f.write(pretty_string)
      f.close()
    end
  end
  
  def process_raw_gist (raw_text)
    metadata = Hash.new
    
    comment_char = nil
    lines = raw_text.lines()
    last_known_key = nil
    
    hooks_remaining = GIST_METADATA_HOOKS.clone
    
    for index in 0..lines.length-1
      stripped_line = lines[index].strip()
      if stripped_line != nil && !stripped_line.empty?
        if stripped_line.start_with?("#!")
          next
        end
        
        if comment_char == nil
          comment_char = stripped_line[0]
        end
        if stripped_line.start_with?(comment_char)
          stripped_line = stripped_line.sub(comment_char,'').strip()
          if stripped_line.empty?
            last_known_key = nil
            break
          end
          hook_data = search_line_for_hooks(hooks_remaining, last_known_key, stripped_line)
          if hook_data == nil
            break
          else
            parsed_key = hook_data[0]
            parsed_value = hook_data[1]
            
            last_known_key = parsed_key
            if metadata.key? parsed_key # is the key already in the hash?
              metadata[parsed_key] = metadata[parsed_key] + " #{parsed_value}" # append
            else
              metadata[parsed_key] = parsed_value
            end
          end
        else
          last_known_key = nil
          break
        end
      end
    end
    
    return metadata
  end
  
  def search_line_for_hooks(hooks_remaining, last_known_key, line)
    hooks_remaining.each do |key, value|
      if line.include? value
        hooks_remaining.delete(key)
        return [key, line.sub(value, '')]
      end
    end
    
    if last_known_key != nil
      return [last_known_key, line];
    end
    
    return nil
  end
end
  
