class UserInterfaceService
  class << self
    def invite_friends(emails)
      emails_list = emails.delete ' '
      emails_array = emails_list.split(',')

      @emails_check = true
      @mailing_list = []
      emails_array.each do |email|
        if email[/\A([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})\z/i]
          @mailing_list << email unless User.exists?(email: email)
        else
          @emails_check = false
          break
        end
      end

      if @emails_check
        @mailing_list.each { |email| UserInterfaceMailer.invite_friends(email).deliver }
        true
      else
        false
      end
    end
  end
end
