superuser = User.new(:username => "superuser", :password => "superpassword", :super => true)
superuser.save

supermailbox = Mailbox.new(:user => superuser)
supermailbox.save

normaluser = User.new(:username => "normaluser", :password => "normalpassword", :super => false)
normaluser.save

normalmailbox = Mailbox.new(:user => normaluser)
normalmailbox.save


