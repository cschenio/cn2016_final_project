module PermissionAuthable
  def has_permission?(role_str)
    role_rank = case role_str
                when "super" then 2
                when "user" then 1
                when "none" then 0 # probably useless
                end
    user_rank = current_session_user_rank
    return user_rank >= role_rank
  end

  def my_mail?(mail)
    rank = current_session_user_rank
    super_accept_none_reject(rank) do
      user = User.find(session[:id])
      return mail.sender == user || mail.receiver == user
    end
  end

  def my_file?(file)
    rank = current_session_user_rank
    super_accept_none_reject(rank) do
      # todo: check if the user should see the file
      return false
    end
  end


  private
  def super_accept_none_reject(rank)
    case rank
    when 0
      return false
    when 1
      yield
    when 2
      return true
    end
  end

  def current_session_user_rank
    if session[:id].nil?
      0
    else
      user = User.find(session[:id])
      user.super? ? 2 : 1
    end
  end
end
