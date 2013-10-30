class Language
	attr_accessor :fullname, :name, :content

	def initialize(fullname, name, content = {})
		@fullname = fullname
		@name = name
		@content = content
	end

	def add_content_pair(key, value)
		@content[key] = value 
	end

	def get_fullname
		return @fullname
	end

	def get_name
		return @name
	end

	def get_content
		return @content
	end
end