class HomeController < ApplicationController
	def index
		if params[:id]
			@load_program = Program.find( params[:id] )
		end
	
		if @is_ie
			render "is_ie"
			return
		end
	end
	
	# Account
	#=================================================================================================

	def login
		@errors = []

		if params[:name] && params[:password]
			if params[:name].blank?
				@errors.push "Name field is blank."				
			end
			
			if params[:password].blank?
				@errors.push "Password field is blank."								
			end 			

			if @errors.length == 0
				@user = User.find_by_name_and_password( params[:name], params[:password] )
				
				if ! @user 
					@errors.push "Name and password combination not found."
				else
					session[:user_id] = @user.id
				end
			end
			
			if @errors.length == 0 		
				redirect_to "/"
				log_action( "login" )
				return
			end
		end
	end
	
	def create_account
		@errors = []

		if params[:name] && params[:password]
			if params[:name].blank?
				@errors.push "Name field is blank."				
			else
				existing = User.find( :first, :conditions=>["name=?",params[:name]] )
				if existing
					@errors.push "Name alrady taken."
				end
			end
			
			if params[:name].match( /[^A-Za-z0-9\._]/ )
				@errors.push "Names con only conatin letters, numbers, period and underscore"
			end
			
			if params[:password].blank?
				@errors.push "Password field is blank."								
			end 			
			
			if params[:password] != params[:password_verify]
				@errors.push "Passwords don't match."								
			end
			
			if @errors.length == 0
				@user = User.new
				@user.name = params[:name]
				@user.password = params[:password]
				@user.save!
				log_action( "created account" )
				session[:user_id] = @user.id

				redirect_to "/"
				return
			end
		end
	end

	def logout
		session[:user_id] = nil
		redirect_to "/"
	end
	
	# Programs
	#=================================================================================================

	def save_program
		if params[:program_name]
			m = params[:program_name].match( /(.+):(.+)/ )
			if m
				user_name = m[1]
				program_name = m[2].downcase
			else
				user_name = @user.name
				program_name = params[:program_name].downcase
			end
			program_name = strip_all_but_legal_program_name_chars( program_name )
		end
		
		begin
			user = User.find( :first, :conditions=>[ "name=?", user_name ] )
			program = Program.find( :first, :conditions=>[ "user_id=? and name=?", user.id, program_name ] )
		rescue
		end
		
		if user
			start_code = params[:start_code]
			version_id = 0
			
			if ! program
				program = Program.new
				program.user_id = user.id
				program.name = program_name
			else
				# SAVE old version
				program_version = ProgramVersion.new
				program_version.program_id = program.id
				program_version.user_id = @user ? @user.id : 0
				program_version.start_code = program.start_code
				program_version.loop_code = program.loop_code
				program_version.save!
				version_id = program_version.id
			end

			program.start_code = params[:start_code]
			program.loop_code = params[:loop_code]
			
			program.save!
			
			log_action( "saved " + user.name + ":" + program_name )

			render :json=>{ :version_id=>version_id }
		else
			render :text=>"unknown user"
		end
	end

	def my_programs
		render :layout=>false
	end
	
	def load_program
		program = load_program_from_id_or_name( params[:id], params[:name] )
		
		if program
			full_name = program.name
			if !@user || program.user_id != @user.id
				user = User.find( program.user_id )
				full_name = user.name + ":" + program.name.downcase
			end
			log_action( "loaded " + full_name )
			render :json=>{ :start_code=>program.start_code, :loop_code=>program.loop_code, :full_name=>full_name, :program_id=>program.id }
		else
			render :text=>"not found"
		end
	end

	def version_program
		program = Program.find( params[:program_id] )
		
		# FIND the currently selected version
		current_index = -1
		program.program_versions.each_with_index do |p,i|
			if p.id == params[:version_current_id].to_i
				current_index = i
				break
			end
		end
		
		if params[:version_which] == "prev"
			if current_index == -1
				current_index = program.program_versions.length
			end
			new_index = [ 0, current_index-1 ].max
			if program.program_versions.length > 0
				new_version_id = program.program_versions[new_index].id
				start_code = program.program_versions[new_index].start_code
				loop_code = program.program_versions[new_index].loop_code
				version_label = "Version " + time_to_ago_string( program.program_versions[new_index].created_at )
			else
				new_version_id = 0
				start_code = program.start_code
				loop_code = program.loop_code
				version_label = "Current version"
			end
		elsif params[:version_which] == "next"
			if current_index == -1 || current_index == program.program_versions.length-1
				new_version_id = 0
				start_code = program.start_code
				loop_code = program.loop_code
				version_label = "Current version"
			else
				new_index = [ program.program_versions.length-1, current_index+1 ].min
				new_version_id = program.program_versions[new_index].id
				start_code = program.program_versions[new_index].start_code
				loop_code = program.program_versions[new_index].loop_code
				version_label = "Version " + time_to_ago_string( program.program_versions[new_index].created_at )
			end
		elsif params[:version_which] == "curr"
			new_version_id = 0
			start_code = program.start_code
			loop_code = program.loop_code
			version_label = "Current version"
		end
		
		render :json=>{ :start_code=>start_code, :loop_code=>loop_code, :version_id=>new_version_id, :version_label=>version_label }
	end

	# Functions
	#============================================================================================
	
	def load_function
		if !params[:fid].blank?
			function = PublicFunction.find( params[:fid] )
		else
			function = PublicFunction.find_by_name params[:name]
		end
		
		if function
			render :json=>{ :name=>function.name, :code=>function.name + " = " + function.code, :function_id=>function.id }
		else
			render :text=>"not found"
		end
	end
	
	def save_function
		if @user
			code = params[:func]
			m = code.match( /(\$[A-Za-z0-9_]+)\s*=\s*(function\s*\(.*)/m )
			if m
				name = m[1]
				code = m[2]
				function = PublicFunction.find_by_name( name )
				if ! function
					function = PublicFunction.new
				else
					# SAVE old version
					function_version = FunctionVersion.new
					function_version.public_function_id = function.id
					function_version.user_id = @user ? @user.id : 0
					function_version.code = function.code
					function_version.save!
				end
				function.name = name
				function.code = code
				function.save!
				
				log_action( "saved function " + name )
			end
		end
		render :nothing=>true
	end
	
	def export_functions
		@conflicts = []
		func_count = params[:count].to_i
		for i in (0..func_count-1)
			name = params["name-"+i.to_s]
			code = params["code-"+i.to_s]
			function = PublicFunction.find_by_name( name )
			if function
				@conflicts.push name
			end
		end
		
		if @conflicts.length == 0 
			for i in (0..func_count-1)
				name = params["name-"+i.to_s]
				code = params["code-"+i.to_s]
				function = PublicFunction.find_by_name( name )
				if ! function
					function = PublicFunction.new
				end
				function.name = name
				function.code = code
				function.save!
			end
			render :text=>"no conflicts"
		else
			render :layout=>false
		end			
	end
	
	def list_functions
		render :layout=>false
	end
	
	def delete_function
		PublicFunction.delete( params[:fid] )
		render :nothing=>true
	end
	
	def version_function
		function = PublicFunction.find( params[:function_id] )
		
		# FIND the currently selected version
		current_index = -1
		function.function_versions.each_with_index do |p,i|
			if p.id == params[:version_current_id].to_i
				current_index = i
				break
			end
		end
		
		if params[:version_which] == "prev"
			if current_index == -1
				current_index = function.function_versions.length
			end
			new_index = [ 0, current_index-1 ].max
			if function.function_versions.length > 0
				new_version_id = function.function_versions[new_index].id
				code = function.function_versions[new_index].code
				version_label = "Version " + time_to_ago_string( function.function_versions[new_index].created_at )
			else
				new_version_id = 0
				code = function.code
				version_label = "Current version"
			end
		elsif params[:version_which] == "next"
			if current_index == -1 || current_index == function.function_versions.length-1
				new_version_id = 0
				code = function.code
				version_label = "Current version"
			else
				new_index = [ function.function_versions.length-1, current_index+1 ].min
				new_version_id = function.function_versions[new_index].id
				code = function.function_versions[new_index].code
				version_label = "Version " + time_to_ago_string( function.function_versions[new_index].created_at )
			end
		elsif params[:version_which] == "curr"
			new_version_id = 0
			code = function.code
			version_label = "Current version"
		end
		
		render :json=>{ :code=>function.name + " = " + code, :version_id=>new_version_id, :version_label=>version_label }
	end
	
	# Comments
	#=================================================================================================

	def load_comments
		@program = load_program_from_id_or_name( params[:id], params[:name] )

		@messages = []
		if @program
			@messages = @program.messages.sort { |a,b| a.id <=> b.id }
		end
		render :layout=>false
	end
	
	def post_comment
		@program = load_program_from_id_or_name( params[:id], params[:name] )

#		if @program
#			m = Message.new
#			m.user_id = @user.id
#			m.program_id = @program.id
#			m.message = params[:message]
#			m.save!
#			log_action( "posted to " + @program.name )
#		end
		render :nothing=>true
	end
	
	def delete_comment
		Message.delete( params[:mid] )
		render :nothing=>true
	end
	
	# Friends
	#=================================================================================================

	def my_friends
		render :layout=>false
	end
		
	def add_friend
		if params[:name]
			@friend = User.find( :first, :conditions=>[ "name=?", params[:name] ] )
			
			if @friend
				f = Friendship.find( :first, :conditions=>["user_id=? and friend_id=?",@user.id,@friend.id] )
				if ! f
					friendship = Friendship.new
					friendship.user_id = @user.id
					friendship.friend_id = @friend.id
					friendship.save!
				end
				log_action( "friended " + @friend.name )
			end
		end
		render "my_friends", :layout=>false
	end
	
	def unfriend
		Friendship.delete_all( [ "user_id=? and friend_id=?", @user.id, params[:id] ] )
		render :nothing=>true
	end
	
	# Pages
	#=================================================================================================

	def load_page
		params[:name].downcase!
		if params[:name] == "all"
			raw_text = ""
			Page.find( :all ).sort { |a,b| a.name <=> b.name }.each do |p|
				raw_text += "* `" + p.name + "," + p.name + "`\n"
			end
			html_text = page_to_html( raw_text )
			render :json=>{ :raw_text=>raw_text, :html_text=>html_text }
		elsif params[:name] == "users"
			raw_text = ":h1 All users and their programs\n\n"
			User.find( :all ).sort { |a,b| a.name <=> b.name }.each do |u|
				raw_text += ":h2 " + u.name + "\n\n"
				for p in u.programs.sort { |a,b| a.name <=> b.name }
					raw_text += "* `program:" + u.name + ":" + p.name.downcase + "," + p.name.downcase + "`\n"
				end
			end
			html_text = page_to_html( raw_text )
			render :json=>{ :raw_text=>raw_text, :html_text=>html_text }
		elsif params[:name] == "actions"
			if @user && @user.super_user?
				html_text = ""
				actions = Action.find( :all, :order=>"created_at desc", :limit=>1000 )
				for a in actions
					user = User.find( a.user_id )
					if user.name != "zack"
						html_text += user.name + " " + a.action + " " + time_to_ago_string( a.created_at ) + "<br/>\n"
					end
				end
				render :json=>{ :raw_text=>"", :html_text=>html_text }
			else
				render :json=>{ :raw_text=>"", :html_text=>"super users only" }
			end
		else
			begin
				page = Page.find( :first, :conditions=>[ "name=?", params[:name] ] )
			rescue
			end
			
			if page
				raw_text = page.text
				html_text = page_to_html( page.text )
				log_action( "viewed " + page.name )
				render :json=>{ :raw_text=>raw_text, :html_text=>html_text, :page_id=>page.id }
			else
				render :json=>{ :raw_text=>"", :html_text=>"", :page_id=>0 }
			end
		end
	end
	
	def save_page
		params[:page_name].downcase!
		begin
			page = Page.find( :first, :conditions=>[ "name=?", params[:page_name] ] )
		rescue
		end

		if ! page
			page = Page.new
			page.user_id = @user.id
			page.name = params[:page_name]
		else
			# SAVE old version
			page_version = PageVersion.new
			page_version.page_id = page.id
			page_version.user_id = @user ? @user.id : 0
			page_version.text = page.text
			page_version.save!
		end

		page.text = strip_html( params[:text] )
		
		log_action( "save page " + page.name )
		page.save!
		
		render :text=>"success"
	end
	
	def version_page
		page = Page.find( params[:page_id] )

		# FIND the currently selected version
		current_index = -1
		page.page_versions.each_with_index do |p,i|
			if p.id == params[:version_current_id].to_i
				current_index = i
				break
			end
		end

		if params[:version_which] == "prev"
			if current_index == -1
				current_index = page.page_versions.length
			end
			new_index = [ 0, current_index-1 ].max
			if page.page_versions.length > 0
				new_version_id = page.page_versions[new_index].id
				raw_text = page.page_versions[new_index].text
				version_label = "Version " + time_to_ago_string( page.page_versions[new_index].created_at )
			else
				new_version_id = 0
				raw_text = page.text
				version_label = "Current version"
			end
		elsif params[:version_which] == "next"
			if current_index == -1 || current_index == page.page_versions.length-1
				new_version_id = 0
				raw_text = page.text
				version_label = "Current version"
			else
				new_index = [ page.page_versions.length-1, current_index+1 ].min
				new_version_id = page.page_versions[new_index].id
				raw_text = page.page_versions[new_index].text
				version_label = "Version " + time_to_ago_string( page.page_versions[new_index].created_at )
			end
		elsif params[:version_which] == "curr"
			new_version_id = 0
			raw_text = page.text
			version_label = "Current version"
		end
		
		render :json=>{ :raw_text=>raw_text, :version_id=>new_version_id, :version_label=>version_label }
	end

	def new_page
		params[:name].downcase!
		begin
			page = Page.find( :first, :conditions=>[ "name=?", params[:name] ] )
		rescue
		end
		
		if page
			render :text=>"duplicate"
		else
			page = Page.new
			page.user_id = @user.id
			page.name = params[:name]
			page.save!
			render :text=>"success"
		end
	end	

	# Art
	#=================================================================================================
	
	def get_art
		render :layout=>false
	end
	
	def upload
		a = Asset.new
		a.user_id = @user ? @user.id : 0
		a.filename = params[:userfile]
		a.data = params[:userfile].read
		a.save!
		
		render :text=>a.id.to_s
	end
	
	def get_asset
		if params[:id]
			a = Asset.find( params[:id] )
		else
			a = Asset.find( :first, :conditions=>["name=?",params[:name]] )
		end

		mime_type = "image/jpeg";
		mime_type = "image/png" if a.filename =~ /.png$/
		
		send_data( a.data, :type=>mime_type, :filename=>a.filename, :disposition=>'inline' )
	end
	
	def save_asset
		existing = Asset.find( :first, :conditions=>["name = ?",params[:name]] )
		if existing
			render :text=>"collision"
		else
			a = Asset.find( params[:id] )
			a.name = params[:name]
			a.save!
			render :text=>"saved"
		end
	end
	
	def delete_asset
		a = Asset.find( params[:id] )
		if a && @user && (@user.id == a.user_id || @user.super_user?)
			Asset.delete( a.id )
		end
		render :nothing=>true
	end

	def embeded
		@program = Program.find( params[:id] )
		render :layout=>false
	end
	
	def embeded_test
	end
	
end
