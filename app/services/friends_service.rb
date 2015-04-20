class FriendsService
  class << self
    def invite(emails)
      @incorrect_emails = ''
      emails.delete_if do |email|
        if email[/\A([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})\z/i]
          User.exists?(email: email)
        else
          @incorrect_emails += if @incorrect_emails.blank?
                                 email
                               else
                                 ', ' + email
                               end
        end
      end

      emails.each { |email| FriendsMailer.invite(email).deliver_now } if @emails_correct
      @incorrect_emails
    end
  end
end
