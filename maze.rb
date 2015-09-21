class Maze
	attr_accessor :rooms_array,:exit,:slenderman,:exit
	def initialize(rooms)
		@rooms = rooms
		@rooms_array = []   
		@exit = 'E'
		@slenderman = 'S'
		create_rooms 
		insert_exit
		insert_slenderman 
		maze_shift(500)
	end 
	def maze_shift(amount)
		for index in 0..amount
			@rooms_array = @rooms_array.shuffle
		end 
	end
	def create_rooms
		for index in 1..@rooms
			room = Room.new(index)
			@rooms_array << room
		end
	end 
	def insert_slenderman 
		@rooms_array[rand(rooms)].objects << @slenderman
	end 
	def insert_exit
		@rooms_array[rand(rooms)].objects << @exit
	end
end

class Player
	attr_accessor :location
	def initialize(location) 
		@location = location
	end
	def action
		puts "1.go forward 2.go back 3.stay" 
	  gets.chomp.to_i
	end
	def prompt(str)
	  
	end
	def sense(rooms, slenderman)
		slenderman_location = find(slenderman, rooms) 
		case (@location - slenderman_location).abs 
		when 3
			puts "you feel uneasy, almost as if someone is watching you."
		when 2
			puts "you feel really creeped out now."
		when 1
			puts "your heart is beating wildly."
		end  
	end
	def find(object, rooms_array)
		index = 0;
		rooms_array.each do |room| 
			if room.objects.include? object 
				break 
			end
			index+=1
		end	
		return index
	end
end

class Room
	attr_accessor :num
	attr_accessor :objects
	def initialize(num)
		@num = num
		@objects = []
	end
	def enter(player, rooms_array, object) 
		if @objects.include? "E" 
			puts "the way out is found"
			state = "end" 
		elsif @objects.include? "S"  
			puts "hello"
			state = "end"
		else
			puts "...the room is empty."	
			player.sense(rooms_array, object)
			action = player.action 
			case action
			when 1
				puts "you decide to go forward
				"
				state = "forward"
			when 2	
				puts "you decide to go back
				"
				state = "back"
			else	
				puts "you decide to stay
				"
				state = "stay"	
			end
		end  
		return state
	end
end 

class Manager
	attr_accessor :maze,:rooms,:exit,:slenderman,:player,:turns,:random_room
	def initialize(rooms)
		@maze = Maze.new(rooms)
		@rooms = rooms 
		@start = 1
		@random_room = rand(@start..@rooms)
		@player = Player.new(@random_room)
		@slenderman = maze.slenderman 
		@turns = 1 
		game_start
	end	
	def game_start  
	puts @random_room   
		@maze.rooms_array[@random_room].objects << @player   
		state = "start" 
		while state != "end"
			puts "turn: " + @turns.to_s  
			@turns+=1
			if @turns % 3 == 0
				move(@slenderman, rand(@rooms)) 
			end
			if @turns % 10 == 0 
				maze.maze_shift(1)  
				puts "the room began to shake.....then...it stopped.
				"  
			end
			case true  
			when state == "forward" 
				@random_room+=1
				if @random_room > @rooms
					@random_room = @start
				end	
				@player.location = @random_room
				puts "player: "+ @player.location.to_s  
				puts "slenderman: "+ find(@slenderman).to_s 
				puts "you open the door to the next room"
				state = @maze.rooms_array[@random_room].enter(@player, @maze.rooms_array, @slenderman) 
				
			when state == "back"
				@random_room-=1
				if @random_room < 0
					@random_room = @rooms
				end	
				@player.location = @random_room
				puts "player: "+ @player.location.to_s  
				puts "slenderman: "+ find(@slenderman).to_s 
				puts "you open the door to the next room"	
				state = @maze.rooms_array[@random_room].enter(@player, @maze.rooms_array, @slenderman) 
				 
			when state == "stay" 
				puts "player: "+ @player.location.to_s  
				puts "slenderman: "+ find(@slenderman).to_s 
				state = @maze.rooms_array[@player.location].enter(@player, @maze.rooms_array, @slenderman) 
			when state == "start"
				puts "player: "+ @player.location.to_s 
				puts "slenderman: "+ find(@slenderman).to_s  
				puts "you open the door to the next room"	
				state = @maze.rooms_array[@random_room].enter(@player, @maze.rooms_array, @slenderman)  	
			end	
		end
	end 
	def find(object)
		index = 0;
		@maze.rooms_array.each do |room| 
			if room.objects.include? object 
				break 
			end
			index+=1
		end	
		return index
	end
	def move(object, location)  
		object = @maze.rooms_array[find object].objects.pop 
		@maze.rooms_array[location].objects << object  
	end
	
end 
 
game = Manager.new(20)   
 
