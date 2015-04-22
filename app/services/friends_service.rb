class FriendsService
  class << self
    def invite(emails)
      @incorrect_emails = []
      emails = emails.select do |email|
        if email[/\A([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})\z/i]
          !User.exists?(email: email)
        else
          @incorrect_emails << email
        end
      end

      emails.each { |email| FriendsMailer.invite(email).deliver_now } if @incorrect_emails.empty?
      @incorrect_emails.join(', ')
    end
  end
end
