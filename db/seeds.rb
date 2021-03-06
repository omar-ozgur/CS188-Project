# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

begin
  # Attempt to grab the mutex
  DummyMutex.create(id: 1, number: 1)

  # Users
  User.delete_all
  user_count = 40
  (1..user_count).each do |i|
  	user = User.create!({
  		first_name: i.to_s,
  		last_name: i.to_s,
  		email: i.to_s + "@a.com",
  		username: i.to_s,
  		created_at: Faker::Time.between(30.days.ago, Time.now),
  		password: "foobar",
  		id: i
  	})
  end
  
  p "Created #{user_count} users."
  
  # Tags
  Tag.delete_all
  tags = Tag.create!([{ name: 'numpy' },
  					{ name: 'pandas' },
  					{ name: 'python2' },
  					{ name: 'python3' },
                      { name: 'django' },
  					{ name: 'mvc' },
  					{ name: 'debugging' },
  					{ name: 'pygame' },
  					{ name: 'flask' },
  					{ name: 'string.format' },
  					{ name: 'lambdas' }                  
  					])
  
  p "Created some tags."
  
  # Posts
  Post.where.not(:user_id => [1]).delete_all
  post_content = [{
  	description: "How to find number of rows of a huge csv file in pandas",
  	snippit: "import foo\nmethodToCall = getattr(foo, 'bar')\nresult = methodToCall()",
  	user_id: 1
  }, {
  	description: "python pygame blit. Getting an image to display",
  	snippit: "# import the relevant libraries
  import time
  import pygame
  import pygame.camera
  from pygame.locals import *
  # this is where one sets how long the script
  # sleeps for, between frames.sleeptime__in_seconds = 0.05
  # initialise the display window
  pygame.init()
  pygame.camera.init()
  
  screen = pygame.display.set_mode((640, 480), 0, 32)
  
  # set up a camera object
  cam = pygame.camera.Camera(0)
  # start the camera
  cam.start()
  
  while 1:
      # sleep between every frame
      time.sleep( 10 )
      # fetch the camera image
      image = cam.get_image()
      # blank out the screen
      screen.fill((0,0,2))
      # copy the camera image to the screen
      screen.blit( image, ( 0, 0 ) )
      # update the screen to show the latest screen image
      pygame.display.update()",
  	user_id: 1
  }, {
  	description: "given total returns and dividends, vectorize the implied price",
  	snippit: "while True:
      for e in pygame.event.get():
              if e.type==QUIT:        #break the loop and quit
                      pygame.quit()
                      sys.exit()
                      break
      
      screen.fill((255,0,255))            #fill the screen with magenta
      screen.blit(background_surface, (0,0))
      display.update()",
  	user_id: 1
  }, {
  	description: "Get file extension from MIME type text/plain;charset=UTF-8 with mimetypes() library in Python",
  	snippit: "class ScrollBar:
      # ... code ...
      def render(self, display, x, y):
          self.subSurface.blit(self.handle_image, (0, self.handle_pos))
          self.subSurface.blit(self.upbtn_image, (0, 0))
          self.subSurface.blit(self.dnbtn_image, (0, self.height - self.btn_height))
          # ... other rendering operations
          display.blit(self.subSurface, (x, y))",
  	user_id: 1
  }, {
  	description: "Unable to make high number of posts on remote machine vs local using asynio and aiohttp",
  	snippit: "self.subSurface.blit(self.image, (x, y)) ",
  	user_id: 1
  }, {
  	description: "Python3.5 send object over socket (Pygame cam image)",
  	snippit: "pygame.draw.rect(self.subSurface, color, rect)",
  	user_id: 1
  }]
  
  (1..10).each do |i|
  	post_content.each do |content|
  		userID = rand(user_count) % (user_count - 2) + 2
  		post = Post.create!({
  		  description: Faker::Lorem.sentence,
  		  snippit: content[:snippit],
  		  created_at: Faker::Time.between(2.days.ago, Time.now),
  		  user_id: userID,
  		  language: 'python'
  		})
  		tag_id_offset = rand(Tag.count)
  		rand_tag_id = Tag.offset(tag_id_offset).first.id
  		post.post_tags.create!(post_id: post.id, tag_id: rand_tag_id )
  
  		tag_id_offset = rand(Tag.count)
  		rand_tag_id = Tag.offset(tag_id_offset).first.id
  		post.post_tags.create!(post_id: post.id, tag_id: rand_tag_id )
  
  		# gen upvotes
  		upvote_times = rand(50)
  		(1..upvote_times).each do |j|
  			userID = rand(user_count) % (user_count - 2) + 2
  			post.liked_by User.find(userID)
  		end
  
  		# gen downvotes
  		downvote_times = rand(50)
  		(1..downvote_times).each do |j|
  			userID = rand(user_count) % (user_count - 2) + 2
  			post.disliked_by User.find(userID)
  		end
  	end
  end
  
  p "Created #{post_content.length * 10} posts and some upvotes/downvotes."
  
  # Comments
  num_comments = 200
  (1..num_comments).each do |i|
  	userID = rand(user_count) % (user_count - 2) + 2
  
    if Rails.env.production?
  	  rand_post_id = Post.order("RAND()").limit(1).first.id
    else
  	  rand_post_id = Post.order("RANDOM()").limit(1).first.id
    end
  
  	Comment.create!({
  		comment: Faker::Lorem.sentence,
  		created_at: Faker::Time.between(2.days.ago, Time.now),
  		user_id: userID,
  		post_id: rand_post_id
  	})
  end
  
  p "Created #{num_comments} comments."
  
  p "DONE: Created #{user_count} users, #{post_content.length * 10} posts, #{num_comments} comments, some tags, and some upvotes/downvotes."
rescue
  puts "Oh no, I was too slow to grab the mutex!"
  puts "I don't get to seed any data :("
end

