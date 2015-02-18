require 'json'

class JSONSerializer
  attr_accessor :json
  
  def initialize(json)
    @json = json
  end

  def compile
    structured_gists = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }

    entries = JSON.parse(json)
    entries.each do |arr|
      title = arr["Title"] != nil ? arr["Title"].strip() : nil
      authors = arr["Authors"] != nil ? arr["Authors"].strip() : nil
      description = arr["Description"] != nil ? arr["Description"].strip() : nil
      section = arr["Section"] != nil ? arr["Section"].strip() : nil
      subsection = arr["Subsection"] != nil ? arr["Subsection"].strip() : nil
      url = arr["URL"] != nil ? arr["URL"].strip() : nil
      
      if title == nil
        puts "Error: A title must be included for #{url}"
        next
      end
      
      if section == nil || subsection == nil
        puts "Error: #{title} must have a section and subsection to be compiled!"
        next
      end

      structured_gists[section][subsection][title] = {"Authors"=>authors, "Description"=>description, "URL"=>url}
    end
    return structured_gists
  end

  def to_md
    structured_gists = compile()
    File.open("./prod/gists.md","w") do |f|
      structured_gists.each do |j, v|
        f.puts("# #{j}\r")
        structured_gists[j].each do |k, v|
          f.puts("### #{k}\r")
          f.puts("\r\n")
          structured_gists[j][k].each do |t, v|
            f.puts("##### #{t}\r")
            structured_gists[j][k][t].each do |l, v|
              f.puts("* #{l}: #{v}\r")
            end
            f.puts("\r\n")
          end
        end
      end
      f.close()
    end
  end
end
