require 'rails_helper'

describe Dashboard::ProfileController do
  describe 'invite friends' do
    describe 'deliveries' do
      before do
        @user = create(:user)
        @controller.send(:auto_login, @user)
      end

      it 'one correct email' do
        post :invite_friends, { format: 'js', invite_friends: { emails: 'one@test.com' } }
        expect(ActionMailer::Base.deliveries.count).to eql(1)
      end

      it 'two correct emails' do
        post :invite_friends, { format: 'js',
                                invite_friends: { emails: 'one@test.com, two@test.com' } }
        expect(ActionMailer::Base.deliveries.count).to eql(3)
      end

      it 'one correct and one incorrect email' do
        post :invite_friends, { format: 'js',
                                invite_friends: { emails: 'one@test.com, two@' } }
        expect(ActionMailer::Base.deliveries.count).to eql(3)
      end

      it 'two correct emails with one equal user email' do
        post :invite_friends, { format: 'js',
                                invite_friends: { emails: 'test@test.com, one@test.com' } }
        expect(ActionMailer::Base.deliveries.count).to eql(4)
      end
    end

    describe 'mail params' do
      before do
        @user = create(:user)
        @controller.send(:auto_login, @user)
        post :invite_friends, { format: 'js', invite_friends: { emails: 'one@test.com' } }
        @mail = ActionMailer::Base.deliveries.last
      end

      it 'from' do
        expect(@mail.from).to eql ['cards@flashcards.com']
      end

      it 'to' do
        expect(@mail.to).to eql ['one@test.com']
      end

      it 'subject' do
        expect(@mail.subject).to eql('Приглашаем Вас на сайт flashcards.')
      end
    end
  end
end
