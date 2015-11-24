class Jekyll::Compose::FileInfo
  attr_reader :params
  def initialize(params)
    @params = params
  end

  def file_name
    name = Jekyll::Utils.slugify params.title
    "#{name}.#{params.type}"
  end

  def content
    frontmatter = [
     "layout: #{params.layout}",
     "title: #{params.title}"
    ]
    frontmatter.push("date: #{params.date}") if params.date 
     
    <<-CONTENT.gsub /^\s+/, ''
      ---
      #{frontmatter.join("\n")}
      ---
    CONTENT
  end
end
