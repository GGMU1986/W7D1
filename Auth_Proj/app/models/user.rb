class User < ApplicationRecord


    after_initialize :ensure_session_token

    validates :username, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence:true
    validates :password, length: {minimum: 6, allow_nil: true}
    # Hash collisions - why do we not include unique above?

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)

        if user && user.is_password?(password)
            user
        else
            nil
        end
    end

    def reset_session_token!
        ## We want some more clarification in this method's function
        self.session_token = SecureRandom::urlsafe_base64
        self.save!
        self.session_token
    end

    def password=(password)
        # Why BCrypt was not working in Pry
        #com back the gem bcrypt on gem
        self.password_digest = BCrypt::Password.create(password) 
        # passsword_digest: "$2a$12$8caRbNzPMqUTy8XLq74Fn.9ekOBtAAiXqNKDEl8LJJGs1FPJhFw6e"
        @password = password
    end

    def password
        @password
    end

    def is_password?(password)
        password_object = BCrypt::Password.new(password_digest)
        password_object.is_password?(password)
    end



end