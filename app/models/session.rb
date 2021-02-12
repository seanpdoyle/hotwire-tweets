class Session < ApplicationModel
  attribute :username, :string
  attribute :password, :string
  attribute :user

  validates :username, presence: true
  validates :password, presence: true

  def self.find(session)
    new user: User.find_by(id: session[:user_id])
  end

  def destroy(session)
    session.clear
  end

  def signed_in?
    user.present?
  end

  def sign_in!(session)
    if valid? && (user = User.find_by(username: username)) && user.authenticate_password(password)
      self.user = user
      session[:user_id] = user.id
      true
    else
      errors.add :base, :invalid
      false
    end
  end
end
