mockuser = User.new
mockuser.save
mockmailbox = Mailbox.new(:user => mockuser)
mockmailbox.save

