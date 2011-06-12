# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def strip_html a
		if a.blank?
			return a
		end
		
		a.gsub!( "\\", "" )
		a.gsub!( /<[^>]*>/, "" )
		return a
	end
	
	def link_subs line
		return line.gsub( /`([^,]*),([^`]*)`/ ) { |s| "<a onclick=\"loadPage('" + $1 + "',true)\">" + $2 + "</a>" }
	end
					
	def page_to_html a
		b = ""
		state = "in_p"
		b += "<p>"
		
		c = a.gsub( /</, "&lt;" )

		lines = c.split( "\n" )
		i = 0
		while i<lines.length
			line = lines[i]
		
			escape = line.match( /^:([^ ]*)\s*(.*)/ )
			li = line.match( /^\s*\*\s*(.*)/ )
			empty = line.match( /^\s*$/ )
				
			case state
			when "in_code"
				if escape && escape[1] == "end"
					b += "</div><p>"
					state = "in_p"
				else
					b += line + "<br/>"
				end
			when "in_ul"
				if li
					b += "</li><li>" + link_subs(li[1])
				elsif empty || escape
					b += "</li></ul><p>"
					i -= 1
					state = "in_p"
				else
					b += " " + link_subs( line )
				end
			when "in_p"
				if escape
					b += "</p>"
					if escape[1] == "h1"
						b += "<h1>" + escape[2] + "</h1><p>"
					elsif escape[1] == "h2"
						b += "<h2>" + escape[2] + "</h2><p>"
					elsif escape[1] == "code"
						b += "<div class='code'>"
						state = "in_code"
					end
				elsif li
					b += "<ul><li>" + link_subs( li[1] )
					state = "in_ul"
				elsif empty
					b += "</p><p>"
				else
					b += " " + link_subs( line )
				end
			end
			
			i += 1
		end
		return b
	end

	def strip_all_but_legal_program_name_chars( str )
		new_str = ""
		str.each_byte do |byte|
			if (byte.chr >= 'A' && byte.chr <= 'Z') || (byte.chr >= 'a' && byte.chr <= 'z') || (byte.chr >= '0' && byte.chr <= '9') || byte.chr == ' ' || byte.chr == '_' || byte.chr == '-'
				new_str << byte.chr 
			end
		end
		new_str
	end

	def load_program_from_id_or_name id, name
		program = nil
		begin
			if id && id != "null"
				program = Program.find( id )
			elsif name
				m = name.match( /(.+):(.+)/ )
				if m
					user = User.find( :first, :conditions=>[ "name=?", m[1] ] )
					name = m[2]
				else
					user = User.current_user
				end
				program = Program.find( :first, :conditions=>[ "user_id=? and name=?", user.id, name.downcase ] )
			end
		rescue
		end
		return program
	end
		
	def time_to_ago_string(created_at)
		sec = (Time.now - created_at).to_i
		min = (sec/60).to_i;
		hrs = (min/60).to_i;
		dys = (hrs/24).to_i;
		
		if sec <= 1
			ago = "1 second ago"
		elsif sec < 60
			ago = sec.to_s + " seconds ago"
		elsif min == 1
			ago = min.to_s + " minute ago"
		elsif min < 60
			ago = min.to_s + " minutes ago"
		elsif hrs == 1
			ago = hrs.to_s + " hour ago"
		elsif hrs < 24
			ago = hrs.to_s + " hours ago"
		elsif dys == 1
			ago = dys.to_s + " day ago"
		else
			ago = dys.to_s + " days ago"
		end
		
		return ago
	end
	
	def log_action string
		if @user
			@user.log_action( string )
		end
	end
	
	
end
