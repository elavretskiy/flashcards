class FriendsService
  class << self
    def invite(emails)
      @incorrect_emails = ''
      emails = emails.select do |email|
        if email[/\A([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})\z/i]
          User.exists?(email: email) ? false : true
        else
          @incorrect_emails += @incorrect_emails.blank? ? email : (', ' + email)
        end
      end

      emails.each { |email| FriendsMailer.invite(email).deliver_now } if @incorrect_emails.blank?
      @incorrect_emails
    end
  end
end
