# -*- encoding : utf-8 -*-
# Ta linijka JEST ZE WZGLĘDU NA KODOWANIE W 1.9.2

class Account < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation
  attr_accessor :new_password, :new_password_confirmation

  attr_accessor :password
  before_save :encrypt_password
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :username
  validates_uniqueness_of :username
  validate :validate_new_password, :on => :update

  # Kroki rejestracji.

  attr_writer :current_step
  # validates_presence_of :rules, :if => lambda { |o| o.current_step == "second" }

  ### PRZECZYTAJ: http://omgbloglol.com/post/392895742/improved-validations-in-rails-3
  ## && - I (AND)
  ## || - ALBO (OR)

  def validate_new_password
    if self.password.nil? || (!self.password_hash.nil? && get_password_hash(self.password) != self.password_hash)
      errors.add(:base, "Wprowazone hasło jest niepoprawne")
    end
  end

  def current_step
    @current_step || steps.first
  end


  def steps
    %w[first second last]
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end

  ## Następna część modelu.

  def self.authenticate(username, password)
    user = find_by_username(username)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = get_password_hash(password) #działamy na obiekcie
    end
  end


  private
  ## Wszystko pod tym jest dostępne do wywołania tylko przez klasę, nie wolno zrobić np.
  # a = Account.new
  # a.encrypt('sbc','cbs') [NIE ZADZIAŁA]


  ## Wołamy: Account.encrypt(password)
  def get_password_hash(password)
    BCrypt::Engine.hash_secret(password, self.password_salt)
  end

end

