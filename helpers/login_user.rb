module LoginUser
  def self.confirm_login?(user)
    if user.nil?
      true
    end
  end
end