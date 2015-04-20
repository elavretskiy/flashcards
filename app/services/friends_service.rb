class FriendsService
  class << self
    def invite(emails)
      @emails_validation = true
      @mailing_list = []

      @mailing_list = emails.map do |email|
        if email[/\A([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})\z/i]
          email if User.exists?(email: email)
        else
          @emails_validation = false
          break
        end
      end

      if @emails_validation
        @mailing_list.each { |email| UserInterfaceMailer.invite_friends(email).deliver }
        true
      else
        false
      end
    end
  end
end
